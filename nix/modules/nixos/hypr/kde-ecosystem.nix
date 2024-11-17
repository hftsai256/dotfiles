{ config, pkgs, ... } :
{
  environment.systemPackages = with pkgs.kdePackages; [
    pkgs.polkit
    polkit-qt-1
    polkit-kde-agent-1

    frameworkintegration # provides Qt plugin
    kauth # provides helper service
    kcoreaddons # provides extra mime type info
    kded # provides helper service
    kfilemetadata # provides Qt plugins
    kguiaddons # provides geo URL handlers
    kiconthemes # provides Qt plugins
    kimageformats # provides Qt plugins
    kio # provides helper service + a bunch of other stuff
    kio-admin # managing files as admin
    kio-extras # stuff for MTP, AFC, etc
    kio-extras-kf5
    kio-fuse # fuse interface for KIO
    kpackage # provides kpackagetool tool
    kservice # provides kbuildsycoca6 tool
    kwallet # provides helper service
    kwallet-pam # provides helper service
    kwalletmanager # provides KCMs and stuff

    kwin
    ark
    kdegraphics-thumbnailers
    dolphin
    okular
    gwenview

    libplasma # provides Kirigami platform theme
    plasma-integration # provides Qt platform theme
    kde-gtk-config # syncs KDE settings to GTK

    breeze
    breeze-icons
    breeze-gtk
    ocean-sound-theme
    plasma-workspace-wallpapers
    pkgs.hicolor-icon-theme
    qqc2-breeze-style
    qqc2-desktop-style
  ];

  security = {
    polkit.enable = true;
    pam.services.login.kwallet = {
      enable = true;
      package = pkgs.kdePackages.kwallet-pam;
    };
  };

  systemd.user.services.polkit-kde-authentication-agent-1 = {
    enable = true;
    description = "The KDE's Implementation of Policy Kit Authentication Agent";
    after = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  systemd.user.services.pam-kwallet-init = {
    enable = true;
    description = "Unlock KWallet with PAM";
    after = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
