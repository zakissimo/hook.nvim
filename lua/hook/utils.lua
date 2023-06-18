local M = {}

M.add_new_buf = function(bufnr, bnames, bmap, vim_init)
    local binfo = vim.fn.getbufinfo(bufnr)[1]
    local fname = vim.fn.fnamemodify(binfo.name, ":h:t")
                    .. "/" .. vim.fn.fnamemodify(binfo.name, ":t")
    local uniq_fname = fname .. " (" .. bufnr .. ")"

    if binfo.name ~= ""
        and (vim.fn.getftype(binfo.name) == "file" or vim_init)
        and tonumber(binfo.listed) == 1
        and bmap[fname] ~= bufnr
        and bmap[uniq_fname] ~= bufnr
    then
        if bmap[fname] ~= nil then
            fname = uniq_fname
        end
        table.insert(bnames, fname)
        bmap[fname] = bufnr
    end
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
