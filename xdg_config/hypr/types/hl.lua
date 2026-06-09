---@meta

---@class hl
hl = {}

---@param key string
---@param value string
function hl.env(key, value) end

---@param config table
function hl.config(config) end

---@param path string
function hl.plugin(path) end

---@param name string
---@param config table
function hl.plugin_config(name, config) end

---@param monitor table
function hl.monitor(monitor) end

---@param rule table
function hl.workspace_rule(rule) end

---@param rule table
function hl.window_rule(rule) end

---@param rule table
function hl.layer_rule(rule) end

---@param anim table
function hl.animation(anim) end

---@param gesture table
function hl.gesture(gesture) end

---@param event string
---@param callback function
function hl.on(event, callback) end

---@param action any
function hl.dispatch(action) end

---@param key string
---@param action any
---@param opts? table
function hl.bind(key, action, opts) end

---@class hl.dsp
hl.dsp = {}

---@param cmd string
---@return any
function hl.dsp.exec_cmd(cmd) end

---@param cmd string
---@return any
function hl.dsp.exec_raw(cmd) end

---@param action string
---@return any
function hl.dsp.layout(action) end

---@class hl.dsp.focus
---@param opts table
---@return any
function hl.dsp.focus(opts) end

hl.dsp.window = {}
function hl.dsp.window.close() end
function hl.dsp.window.float(opts) end
function hl.dsp.window.center() end
function hl.dsp.window.move(opts) end
function hl.dsp.window.drag() end
function hl.dsp.window.resize() end
function hl.dsp.window.pseudo() end
function hl.dsp.window.fullscreen(opts) end

hl.dsp.workspace = {}
function hl.dsp.workspace.toggle_special() end
