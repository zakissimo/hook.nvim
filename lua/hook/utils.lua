local M = {}

M.begins_with = function(str, prefix)
    return string.sub(str, 1, #prefix) == prefix
end

M.remove_garbage_input = function(win_names, bmap)
    local new_win_names = {}

    for _, win_name in ipairs(win_names) do
        if bmap[win_name] ~= nil then
            table.insert(new_win_names, win_name)
        end
    end

    return new_win_names
end

M.close_bufs = function(win_names, bnames, bmap)
    for _, bname in pairs(bnames) do
        if not M.in_arr(win_names, bname) then
            vim.cmd("bd! " .. bmap[bname])
            bmap[bname] = nil
        end
    end

    return win_names
end

M.in_arr = function(arr, e)
    for _, v in ipairs(arr) do
        if v == e then
            return true
        end
    end

    return false
end

M.get_idx = function(arr, e)
    for i, v in ipairs(arr) do
        if v == e then
            return i
        end
    end

    return -1
end

return M
