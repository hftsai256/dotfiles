# NixOS Installation Guide – Declarative (disko + nixos-anywhere) + Legacy Manual Method

**Primary/recommended method (2026+):** Fully declarative disk layout with [`disko`](https://github.com/nix-community/disko) + remote install via [`nixos-anywhere`](https://github.com/nix-community/nixos-anywhere).  
**Legacy method:** The original manual LUKS + tmpfs + Btrfs steps (still useful for understanding or offline installs).

Root password and user accounts are **declarative** (defined in your flake). Imperative `passwd` changes are wiped on reboot because of tmpfs root + impermanence.

**Assumptions**
- UEFI system with TPM 2.0
- Single main NVMe drive (example: `/dev/nvme0n1`)
- Secure Boot **disabled** in firmware during first install (re-enabled afterward)

## Recommended: Declarative Remote Install (disko + nixos-anywhere)

Your flake (`nix/flake.nix`) already includes:
- `disko` input + module (loaded for `aetherforge`)
- `disk-configuration.nix` (declarative GPT → ESP + swap + LUKS + Btrfs subvolumes)
- `hardware-configuration.nix` (generated once via nixos-anywhere)
- `impermanence`, `lanzaboote`, TPM2, etc.

### 1. Prepare the target machine (aetherforge example)

1. **PXE-boot** (or netboot) the target into a **NixOS live installer** (unstable recommended).  
   - Your machine must have network boot enabled in firmware.
   - Once booted, it gets an IP via DHCP and SSH is available (root login with password or key).

2. From **your development machine** (the one with the flake checked out):

```bash
cd ~/dotfiles/nix   # or wherever your nix/ flake lives

# Optional: generate hardware-configuration.nix on first run (you already did this for aetherforge)
nix run github:nix-community/nixos-anywhere -- \
  --generate-hardware-config nixos-generate-config ./hosts/aetherforge/hardware-configuration.nix \
  --flake .#aetherforge \
  root@<TARGET-IP-FROM-PXE>

# Normal run (after hardware config is committed)
nix run github:nix-community/nixos-anywhere -- \
  --flake .#aetherforge \
  root@<TARGET-IP-FROM-PXE>
```

**Notes on the command**
- `--flake .#aetherforge` → points to your `nixosConfigurations.aetherforge` (which already imports `disk-configuration.nix` + `hardware-configuration.nix`).
- The target is already a NixOS installer (PXE), so nixos-anywhere skips kexec and goes straight to disko → format → install.
- If you need to pass a LUKS passphrase non-interactively: add `--disk-encryption-keys /tmp/luks.key "$(cat /path/to/passphrase)"`.
- `--build-on-remote` can be added if your dev machine is much slower.
- Disko will automatically create:
  - EFI partition (`/boot`)
  - Swap
  - LUKS container named `enc`
  - Btrfs subvolumes (`/nix`, `/persist`, `/home`)
  - tmpfs root (`/`)

After the command finishes, the machine reboots into your full NixOS config.

## Legacy: Manual Installation (LUKS + tmpfs root + Btrfs)

(Kept for reference or air-gapped installs)

### 1. Boot installer
- Disable Secure Boot in firmware.
- Boot NixOS unstable live image → `sudo -i`

### 2. Partitioning / LUKS / Btrfs (manual)

```bash
parted /dev/nvme0n1 -- mklabel gpt
parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 1GiB
parted /dev/nvme0n1 -- set 1 esp on
parted /dev/nvme0n1 -- mkpart primary 1GiB 17GiB  # 16 GB Swap, depends on RAM size
parted /dev/nvme0n1 -- mkpart primary 17GiB 100%

mkfs.vfat -F 32 -n EFI /dev/nvme0n1p1
mkswap -L swap /dev/nvme0n1p2 && swapon /dev/nvme0n1p2

cryptsetup luksFormat --type luks2 /dev/nvme0n1p3
cryptsetup open /dev/nvme0n1p3 enc

mkfs.btrfs -L nixos /dev/mapper/enc
mount /dev/mapper/enc /mnt
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/persist
btrfs subvolume create /mnt/home
umount /mnt
```

### 3. Mount & install

```bash
mount -t tmpfs none /mnt
mkdir -p /mnt/{boot,nix,persist,home}

mount /dev/nvme0n1p1 /mnt/boot
mount -o subvol=nix,compress-force=zstd:3,noatime /dev/mapper/enc /mnt/nix
mount -o subvol=persist,compress-force=zstd:3,noatime /dev/mapper/enc /mnt/persist
mount -o subvol=home,compress-force=zstd:3 /dev/mapper/enc /mnt/home

git clone https://git.htwillows.net/hftsai256/dotfiles.git /mnt/etc/nixos
nixos-generate-config --root /mnt

# IMPORTANT: copy the generated fileSystems."/persist" block into your flake and add neededForBoot = true;
```

```bash
nixos-install --root /mnt --no-root-passwd --flake /mnt/etc/nixos#aetherforge
reboot
```

## First Boot & Post-Install Setup (same for both methods)

1. Boot → manual LUKS unlock (first boot only).
2. Log in with your declarative user/root password from the flake.
3. Generate and enroll Secure Boot keys (if using lanzaboote):

```bash
sudo nix run nixpkgs#sbctl create-keys
sudo nix run nixpkgs#sbctl verify
sudo nix run nixpkgs#sbctl enroll-keys -- --microsoft
bootctl status
```

Persist `/var/lib/sbctl` via impermanence.

4. Re-enable Secure Boot in firmware.
5. Enroll TPM2 for auto-unlock:

```bash
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+2+7+12 --wipe-slot=tpm2 /dev/nvme0n1p3
```

Reboot a couple of times to confirm auto-unlock works.

6. Final rebuild (applies any remaining modules, Home Manager, etc.):

```bash
sudo nixos-rebuild switch --flake /etc/nixos#your-hostname
```

Everything (including Home Manager profiles) activates on rebuild.

## Tips & Gotchas

- **hardware-configuration.nix** – generated by nixos-anywhere (or `nixos-generate-config`). Commit it; do **not** edit by hand.
- **/persist** – must have `neededForBoot = true;` (already in your `disk-configuration.nix`).
- **Secure Boot / lanzaboote** – disable temporarily for first install if you hit issues (`secureBoot.enable = false;` in your host config).
- **Impermanence** – everything outside `/persist` and `/nix` is ephemeral.
- **flake structure** – all hosts live under `nix/hosts/<hostname>/`. `aetherforge` already uses unstable + disko.
- **Re-provisioning** – just PXE boot again and re-run nixos-anywhere. Disko will wipe and re-create everything.

## References

- [nixos-anywhere Quickstart](https://nix-community.github.io/nixos-anywhere/quickstart.html)
- [disko documentation](https://github.com/nix-community/disko)
- [NixOS tmpfs root + Btrfs + Impermanence](https://elis.nu/blog/2020/05/nixos-tmpfs-as-root/)
- [Secure Boot + TPM2 on NixOS](https://jnsgr.uk/2024/04/nixos-secure-boot-tpm-fde)
