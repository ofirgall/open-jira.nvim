---@mod open-jira.nvim Open Jira shorthands
local M = {}

local default_config = {
    url = 'https://jira.atlassian.com/browse/'
}

local loaded_config = default_config

---Expand Jira shorthand with the url
---@param shorthand string
---@return string The expanded url
local function expand_jira_shorthand(shorthand)
    local url = nil
    if type(loaded_config.url) == 'function' then
        url = loaded_config.url(shorthand)
    else
        url = loaded_config.url
    end

    return url .. shorthand
end

---Open Jira shorthands `JRASERVER-63928` for example
---@param text string
---@return table string[]|nil
local function open_fn(text)
    local urls = {}
    for url in text:gmatch('%w+-%d+') do
        table.insert(urls, expand_jira_shorthand(url))
    end

    return urls
end

---@param config table user config
---@usage [[
----- Default config
---require('open').setup {
---    -- string|function(shorthand: string): string
---    url = 'https://jira.atlassian.com/browse/'
---}
---@usage ]]
M.setup = function(config)
    config = config or {}
    config = vim.tbl_deep_extend('keep', config, default_config)

    loaded_config = config

    require('open').register_opener({
        name = 'jira',
        open_fn = open_fn
    })
end

return M
