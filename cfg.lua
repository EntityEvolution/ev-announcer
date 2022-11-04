cfg = {
  qb = GetResourceState('qb-core') == 'started',
  delay = {
    active = true,
    time = 60000,
    all = false, -- If true, it will send all messages at once.
    random = true, -- If true, it will pick a random message from the list to send instead of sending them in order (delay.all must be false).
  },
  messages = {
    {'Title', 'Message', 'success', 5000, true }, -- Title, Message, Type, DurationOfMessage(ms), active
    {'Title 2', 'Cool message', 'error', 5000, true }
  },
  commands = {
    active = true, -- Enable/Disable commands
    prefix = 'ev_', -- Prefix for commands
    list = {
      'delay', -- Sets delay between messages
      'toggleActive', -- Toggles active state of messages by index
      'toggleActiveAll', -- Toggles active state of all messages
    }
  }
}


local TYPES = {
  ['success'] = { 0, 255, 0 },
  ['error'] = { 255, 0, 0 },
  ['info'] = { 0, 0, 255 },
  ['warning'] = { 255, 255, 0 },
  ['default'] = { 255, 255, 255 }
}
function Notify(title, message, type, duration)
  if cfg.qb then
    QBCore.Functions.Notify({
      text = title,
      caption = message,
    }, type, duration)
  else
    local foundType = TYPES[type]
    if foundType == nil then
      foundType = TYPES['default']
    end
    TriggerEvent('chat:addMessage', {
      color = foundType,
      multiline = true,
      args = { title, message }
    })
  end
end