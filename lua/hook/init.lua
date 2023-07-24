local utils = require("hook.utils")
local affix = require("hook.affix")

local M = {}

M._switch = false

M.default = {
    width = 31,
    height = 7,
    prefix = ">",
    name = " Hook ",
    suffix = "[+]"
}

M.setup = function(user_opts)
    M.bnames = {}
    M.bmap = {}
    if user_opts then
        M.default = vim.tbl_deep_extend("force", M.default, user_opts)
    end
    M.default.slen = string.len(M.default.suffix)
end

local init = function()
    M.bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(M.bufnr, "Hook")
    vim.cmd("highlight HookHl guifg=#ffffff")
    local opts = { buffer = M.bufnr, remap = false }

    vim.keymap.set("n", ":", function ()
        print("No command mode allowed while Hook is opened.")
    end, opts)
    vim.keymap.set("n", "<ESC>", function()
        M._close()
    end, opts)
    vim.keymap.set("n", "<CR>", function()
        M._open_file()
    end, opts)
    vim.keymap.set("n", "<C-v>", function()
        M._open_file("v")
    end, opts)
    vim.keymap.set("n", "<C-x>", function()
        M._open_file("s")
    end, opts)
    vim.keymap.set("n", "<C-t>", function()
        M._open_file("t")
    end, opts)
end

local config = {
    title = { { M.default.name, "HookHl" } },
    title_pos = "center",
    relative = "editor",
    width = M.default.width,
    height = M.default.height,
    row = math.floor(((vim.o.lines - M.default.height) / 2) - 1),
    col = math.floor((vim.o.columns - M.default.width) / 2),
    style = "minimal",
    border = {
        { "╭", "HookHl" },
        { "─", "HookHl" },
        { "╮", "HookHl" },
        { "│", "HookHl" },
        { "╯", "HookHl" },
        { "─", "HookHl" },
        { "╰", "HookHl" },
        { "│", "HookHl" },
    }
}

local HookAugroup = vim.api.nvim_create_augroup("HookAugroup", { clear = true })

vim.api.nvim_create_autocmd({ "VimEnter" }, {
    group = HookAugroup,
    callback = function()
        local buf_data = vim.fn.getbufinfo()
        for _, value in ipairs(buf_data) do
            utils.add_new_buf(value.bufnr, M.bnames, M.bmap, true)
        end
    end,
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
    group = HookAugroup,
    callback = function()
        config.row = math.floor(((vim.o.lines - M.default.height) / 2) - 1)
        config.col = math.floor((vim.o.columns - config.width) / 2)
    end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
    group = HookAugroup,
    callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        utils.add_new_buf(bufnr, M.bnames, M.bmap, false)
    end,
})

vim.api.nvim_create_autocmd({ "BufDelete" }, {
    group = HookAugroup,
    callback = function()
        local bufnr = vim.fn.expand("<abuf>")
        if bufnr ~= nil then
            for fname, b in pairs(M.bmap) do
                if tonumber(b) == tonumber(bufnr) then
                    M.bmap[fname] = nil
                    table.remove(M.bnames, utils.get_idx(M.bnames, fname))
                end
            end
        end
    end,
})

vim.api.nvim_create_autocmd({ "WinLeave" }, {
    group = HookAugroup,
    pattern = "Hook",
    callback = function()
        if M._switch then
            M._close()
        end
    end,
})

M._close = function()
    M._switch = false
    vim.api.nvim_win_close(M.winid, false)
    local win_names = vim.api.nvim_buf_get_lines(M.bufnr, 0, -1, false)
    win_names = affix.del(win_names)
    win_names = utils.remove_garbage_input(win_names, M.bmap)
    M.bnames = utils.close_bufs(win_names, M.bnames, M.bmap)
end

M._open = function()
    M._switch = true
    local bufnr = vim.api.nvim_get_current_buf()
    local winid = vim.fn.win_getid(vim.fn.bufwinnr(bufnr))
    local wintype = vim.fn.win_gettype(winid)
    if wintype == "popup" then
        print("Please close the current popup window before opening Hook.")
    else
        local max_len, win_names = affix.add(M.bnames, M.default.prefix, M.bmap, M.default.suffix)
        if max_len > 0 then
            vim.api.nvim_buf_set_lines(M.bufnr, 0, -1, false, win_names)
            config.width = max_len
            config.col = math.floor((vim.o.columns - config.width) / 2)
            M.winid = vim.api.nvim_open_win(M.bufnr, true, config)
            vim.api.nvim_win_set_cursor(M.winid, {1, 1})
        end
    end
end

M._open_file = function(mode)
    local name = affix.del_one(vim.api.nvim_get_current_line())

    M._close()
    if mode == "v" then
        vim.cmd("vs")
    elseif mode == "s" then
        vim.cmd("sp")
    elseif mode == "t" then
        vim.cmd("tabnew")
    end
    vim.cmd("b! " .. M.bmap[name])
end

M.toggle = function()
    if not M.bufnr then init() end
    if vim.fn.bufwinnr(M.bufnr) <= -1 then
        M._open()
    else
        M._close()
    end
end

M.pull = function(idx)
    local bufnr = M.bmap[M.bnames[idx]]
    if bufnr then vim.cmd("b " .. bufnr) end
end

return M
