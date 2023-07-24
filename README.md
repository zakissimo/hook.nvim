# Hook

The Hook neovim plugin provides a quick and easy way to switch between open buffers in neovim.

---

## Features

* Toggle a list of open buffers with customizable window size
* Go to a specific buffer by index (mappable to any bind)
* Easily close any buffers (just use `dd`)


## Installation

Install the plugin using your favorite package manager. For example, using packer:
```lua
use({
    "zakissimo/hook.nvim",
    config = function()
        -- setup table is optional, commented fields are the defaults
        require('hook').setup({
            -- width = 31,
            -- height = 7,
            prefix = "", -- default is ">"
            -- name = " Hook ",
            -- suffix = "[+]"
        })
        -- You probably don't need that many binds
        vim.keymap.set({ "t", "n" }, "<Leader>m", "<CMD>HookToggle<CR>")
        vim.keymap.set({ "t", "n" }, "<M-7>", "<CMD>HookPull 1<CR>")
        vim.keymap.set({ "t", "n" }, "<M-8>", "<CMD>HookPull 2<CR>")
        vim.keymap.set({ "t", "n" }, "<M-9>", "<CMD>HookPull 3<CR>")
        vim.keymap.set({ "t", "n" }, "<M-0>", "<CMD>HookPull 4<CR>")
        vim.keymap.set({ "t", "n" }, "<M-u>", "<CMD>HookPull 5<CR>")
        vim.keymap.set({ "t", "n" }, "<M-i>", "<CMD>HookPull 6<CR>")
        vim.keymap.set({ "t", "n" }, "<M-o>", "<CMD>HookPull 7<CR>")
        vim.keymap.set({ "t", "n" }, "<M-p>", "<CMD>HookPull 8<CR>")
    end,
})
```

## Usage

Call the setup function in your config once (with or without any options)

```lua
require('hook').setup()
```

Map the `toggle` and `pull` functions to your desired binds like so:

```lua
vim.keymap.set("n", "<M-n>", ":lua require'hook'.toggle()<CR>")
vim.keymap.set("n", "<M-7>", ":lua require'hook'.pull(1)<CR>")
vim.keymap.set("n", "<M-8>", ":lua require'hook'.pull(2)<CR>")
vim.keymap.set("n", "<M-9>", ":lua require'hook'.pull(3)<CR>")
vim.keymap.set("n", "<M-0>", ":lua require'hook'.pull(4)<CR>")
```

## Buffer mappings

```
<CR>    Open file on previous window
<C-v>   Open file on vertical split
<C-x>   Open file on horizontal split
<C-t>   Open file in new tab
dd      Delete buffer (When Hook window gets closed)
```

## Customization (Optionnal)

To customize dimensions and filename prefix / suffix, you can change the following while passing it to setup:

```lua
require('hook').setup({
    width = 31,
    height = 7,
    prefix = ">",
    name = " Hook ", -- Window name, leave empty for minimalistic look
    suffix = "[+]" -- Indication that buffer is modified and not saved, leave empty if you're a save spammer
})
```
Note that if you have [devicons](https://github.com/nvim-tree/nvim-web-devicons) plugin installed, the `prefix` will only be used when no devicon was found for the current filetype. Also note that `width` is only used for initial window width size, we then use the maximum buffer filename length to compute it.

## Why?

While using vim I found myself relying too much on [nvim-tree](https://github.com/nvim-tree/nvim-tree.lua) to move around between files.
I tried ThePrimeagen's [harpoon](https://github.com/ThePrimeagen/harpoon) to solve my issues, but realised it wasn't for me.
* It's slow on school computers (I'm a cs student)
* You can't have `autochdir` set to true
* I don't want/need to save my preferences by projects
* I don't really need terminal and tmux integration
* I want to leverage the existence of buffers
