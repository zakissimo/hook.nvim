local M = {}
local devicons_ok, devicons = pcall(require, "nvim-web-devicons")

M.trim = function(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

M.get = function(filename, prefix)
    local icon = prefix
    local e = vim.fn.fnamemodify(filename, ":e")

    if devicons_ok and devicons.get_icon(e) ~= nil then
        icon = devicons.get_icon(e)
    end

    return icon
end

M.add = function(names, prefix, map, usuffix)
    local t = {}
    local len = 0

    for _, n in pairs(names) do
        local suffix = string.rep(" ", string.len(usuffix))
        if vim.api.nvim_buf_get_option(map[n], 'modified') then suffix = usuffix end
        local name = M.get(n, prefix) .. " " .. n .. " " .. suffix
        len = math.max(string.len(name) - 2, len)
        table.insert(t, name)
    end

    return len, t
end

M.del = function(names)
    local t = {}

    for _, n in pairs(names) do
        local _, _, s = string.find(n, "%s(%w+/%w+%.?%w+%s?%(?%d*%)?)%s")

        table.insert(t, M.trim(s))
    end

    return t
end

M.del_one = function(n)
    local _, _, s = string.find(n, "%s(%w+/%w+%.?%w+%s?%(?%d*%)?)%s")

    return M.trim(s)
end

return M
