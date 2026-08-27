--- === Hyper ===
---
--- Hold a trigger key to activate a modal Hyper layer.
--- Sequential bindings reset when the trigger key is released.
---
--- Example:
--- ```lua
--- hs.loadSpoon("Hyper")
--- spoon.Hyper:start()
--- spoon.Hyper:bindSequence({}, "5", {
---   function() hs.alert.show("first") end,
---   function() hs.alert.show("second") end,
--- })
--- ```

local obj = {}
obj.__index = obj

obj.name = "Hyper"
obj.version = "0.1.0"
obj.author = "François Côté"
obj.homepage = "https://github.com/francoiscote/dotfiles"
obj.license = "MIT - https://opensource.org/licenses/MIT"

--- Hyper.trigger
--- Variable
--- Trigger key specification. Defaults to unmodified F18.
obj.trigger = { {}, "F18" }

function obj:init()
  if self._modal then return self end

  self._modal = hs.hotkey.modal.new()
  self._sequenceResetters = {}

  return self
end

--- Hyper:bind(mods, key, ...) -> Hyper
--- Method
--- Binds a hotkey active while the Hyper trigger is held.
function obj:bind(mods, key, ...)
  self:init()
  self._modal:bind(mods, key, ...)

  return self
end

--- Hyper:bindSequence(mods, key, actions) -> Hyper
--- Method
--- Runs the next action on each key press. Wraps after the last action.
function obj:bindSequence(mods, key, actions)
  self:init()
  assert(type(actions) == "table" and #actions > 0, "actions must be a non-empty list")

  for _, action in ipairs(actions) do
    assert(type(action) == "function", "each action must be a function")
  end

  local tapCount = 0
  table.insert(self._sequenceResetters, function()
    tapCount = 0
  end)

  return self:bind(mods, key, function()
    tapCount = tapCount % #actions + 1
    actions[tapCount]()
  end)
end

--- Hyper:resetSequences() -> Hyper
--- Method
--- Resets every sequential binding to its first action.
function obj:resetSequences()
  for _, reset in ipairs(self._sequenceResetters or {}) do
    reset()
  end

  return self
end

--- Hyper:start() -> Hyper
--- Method
--- Activates the Hyper trigger.
function obj:start()
  self:init()
  if self._triggerHotkey then return self end

  self._triggerHotkey = hs.hotkey.bind(self.trigger[1], self.trigger[2], function()
    self._modal:enter()
  end, function()
    self._modal:exit()
    self:resetSequences()
  end)

  return self
end

--- Hyper:stop() -> Hyper
--- Method
--- Deactivates the Hyper trigger and modal layer.
function obj:stop()
  if self._modal then self._modal:exit() end

  if self._triggerHotkey then
    self._triggerHotkey:delete()
    self._triggerHotkey = nil
  end

  return self:resetSequences()
end

return obj
