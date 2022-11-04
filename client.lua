-- Commands
local prefix = cfg.commands.prefix
if commands.active then
  RegisterCommand(prefix .. cfg.commands.list[1], function(_, args)
    local delay = tonumber(args[1])
    if delay and delay > 0 then
      cfg.delay.time = delay
      Notify('Delay', 'Delay between messages set to ' .. delay .. 'ms', 'success', 5000)
    else
      Notify('Delay', 'Invalid delay', 'error', 5000)
    end
  end, false)

  RegisterCommand(prefix .. cfg.commands.list[2], function(_, args)
    local idx = tonumber(args[1])
    if idx == nil or idx <= 0 then
      print('Invalid index')
      return
    end

    if idx > #cfg.messages then
      -- Calculate what the index should be based on the number of messages
      idx = idx % #cfg.messages
      if idx == 0 then
        idx = #cfg.messages
      end
    end

    cfg.messages[idx][6] = not cfg.messages[idx][6]
    print('Toggled active state of message "' .. idx .. '" to "' .. tostring(cfg.messages[idx][6]) .. '"')
  end, false)

  local AllActive = true
  RegisterCommand(prefix .. cfg.commands.list[3], function()
    AllActive = not AllActive
    for i = 1, #cfg.messages do
      cfg.messages[i][6] = AllActive
    end
    print('Toggled active state of all messages to "' .. tostring(AllActive) .. '"')
  end, false)
end

-- Send all the messages
CreateThread(function()
  while true do
    Wait(cfg.interval)
    for i = 1, #cfg.messages do
      if cfg.messages[i][6] then
        -- Delay between messages if enabled
        if cfg.delay.active then
          Wait(cfg.delay.time)
        end
        Notify(cfg.messages[i][1], cfg.messages[i][2], cfg.messages[i][3], cfg.messages[i][4])
      end
    end
  end
end)