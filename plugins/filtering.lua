local function save_filter(msg, name, value)
        local hash = nil
        if msg.to.type == 'chat' then
                hash = 'chat:'..msg.to.id..':filters'
        end
        if msg.to.type == 'user' then
                return 'ععظ  ظ ظ  غ ظ عع'
        end
        if hash then
                redis:hset(hash, name, value)
                return "ظ عظ،ظ ع
 ظ ظ "
        end
end

local function get_filter_hash(msg)
        if msg.to.type == 'chat' then
                return 'chat:'..msg.to.id..':filters'
        end
end

local function list_filter(msg)
        if msg.to.type == 'user' then
                return 'ععظ  ظ ظ  غ ظ عع'
        end
        local hash = get_filter_hash(msg)
        if hash then
                local names = redis:hkeys(hash)
                local text = 'ع
                                ظ ظ  غ ع
                                        ع
ظ ظ  ع ع
        ظ ظ  ظ ظ ع:\n______________________________\n'
                for i=1, #names do
                        text = text..'> '..names[i]..'\n'
                end
                return text
        end
end

local function get_filter(msg, var_name)
        local hash = get_filter_hash(msg)
        if hash then
                local value = redis:hget(hash, var_name)
                if value == 'msg' then
                        return 'غ ع
                                   ع
ع   غ ظ ظ ظ ظ ظ   ظ ع
ظ  ع
ع
ععظ  ظ ظ ظ ظ ظ ظ  ظ عظ ظ  ظ غ ظ ظ ظ  ظ ظ  ظ ع
ظ  ظ ظ ظ عظ ظ  ظ عظ عظ  ظ ظ '
        elseif value == 'kick' then
          send_large_msg('chat#id'..msg.to.id, "ظ ع ظ ع
                                                        ع
                                                          ظ ظ ع
 ظ ظ ظ  ظ  ععظ ع ع غ عظ ظ ظ   ظ ظ  ظ ظ ظ ع
ع   غ عظ عغ ع ع
ظ­ظ عع
 ع
 ظ ع ظ ")
     chat_del_user('chat#id'..msg.to.id, 'user#id'..msg.from.id, ok_cb, true)
    end
  end
end

local function get_filter_act(msg, var_name)
  local hash = get_filter_hash(msg)
  if hash then
    local value = redis:hget(hash, var_name)
    if value == 'msg' then
     return 'ظ ظ ظ ظ ظ  ع ظ ظ غ ظ  ظ ع ظ  ع غ ع
                                               ع
ع'
    elseif value == 'kick' then
     return 'ظ  ع غ ع
                     ع
ع ع
ع
ععظ  ظ ظ ظ  ع ظ­ظ ع ظ عظ ع ظ  ظ ظ '
    elseif value == 'none' then
     return 'ظ  ع غ ع
                     ع
ع ظ ظ  ع ع
          ظ ظ  ظ ظ ظ ظ، ظ ظ ع ظ ظ ظ '
    end
  end
end

local function run(msg, matches)
  local data = load_data(_config.moderation.data)
  if matches[1] == "ilterlist" then
    return list_filter(msg)
  elseif matches[1] == "ilter" and matches[2] == ">" then
    if data[tostring(msg.to.id)] then
     local settings = data[tostring(msg.to.id)]['settings']
     if not is_momod(msg) then
        return "ظ ع
ظ  ع
ظ عظ  ععظ ظ عظ "
     else
        local value = 'msg'
        local name = string.sub(matches[3]:lower(), 1, 1000)
        local text = save_filter(msg, name, value)
        return text
     end
    end
  elseif matches[1] == "ilter" and matches[2] == "+" then
    if data[tostring(msg.to.id)] then
     local settings = data[tostring(msg.to.id)]['settings']
     if not is_momod(msg) then
        return "ظ ع
ظ  ع
ظ عظ  ععظ ظ عظ "
     else
        local value = 'kick'
        local name = string.sub(matches[3]:lower(), 1, 1000)
        local text = save_filter(msg, name, value)
        return text
     end
    end
  elseif matches[1] == "ilter" and matches[2] == "-" then
    if data[tostring(msg.to.id)] then
     local settings = data[tostring(msg.to.id)]['settings']
     if not is_momod(msg) then
        return "ظ ع
ظ  ع
ظ عظ  ععظ ظ عظ "
     else
        local value = 'none'
        local name = string.sub(matches[3]:lower(), 1, 1000)
        local text = save_filter(msg, name, value)
        return text
     end
    end
  elseif matches[1] == "ilter" and matches[2] == "?" then
    return get_filter_act(msg, matches[3]:lower())
  else
    if is_sudo(msg) then
     return
    elseif is_admin(msg) then
     return
    elseif is_momod(msg) then
     return
    elseif tonumber(msg.from.id) == tonumber(our_id) then
     return
    else
     return get_filter(msg, msg.text:lower())
    end
  end
end

return {
  description = "Set and Get Variables",
  usage = {
  user = {
    "filter ? (word) : ع
ظ ظ عظ ع ظ غ ظ  ظ ع
                   ظ ع
ع
 ",
    "filterlist : ع
                    ظ ظ  ع ع
                            ظ ظ  ظ ظ ع عظ ",
  },
  moderator = {
    "filter > (word) : ظ ظ ظ ظ ظ  غ ظ ظ ع ع
                                           ظ ظ ",
    "filter + (word) : ع
ع
ععظ  غ ظ ظ ع ع
              ظ ظ ",
    "filter - (word) : ظ­ظ ع ظ ظ  ع ع
                                     ظ ظ ",
  },
  },
  patterns = {
    "^[Ff](ilter) (.+) (.*)$",
    "^[Ff](ilterlist)$",
    "(.*)",
  },
  run = run
}
