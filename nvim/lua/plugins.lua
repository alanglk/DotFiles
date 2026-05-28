-- ~/.config/nvim/lua/plugins.lua

return {
	-- Multicursor
	{
	    "jake-stewart/multicursor.nvim",
	    branch = "1.0",
	    config = function()
		local mc = require("multicursor-nvim")
		mc.setup()

		local set = vim.keymap.set

		-- Add or skip cursor above/below the main cursor.
		set({"n", "x"}, "<up>", function() mc.lineAddCursor(-1) end)
		set({"n", "x"}, "<down>", function() mc.lineAddCursor(1) end)
		set({"n", "x"}, "<leader><up>", function() mc.lineSkipCursor(-1) end)
		set({"n", "x"}, "<leader><down>", function() mc.lineSkipCursor(1) end)

		-- Add or skip adding a new cursor by matching word/selection
		set({"n", "x"}, "<leader>n", function() mc.matchAddCursor(1) end)
		set({"n", "x"}, "<leader>s", function() mc.matchSkipCursor(1) end)
		set({"n", "x"}, "<leader>N", function() mc.matchAddCursor(-1) end)
		set({"n", "x"}, "<leader>S", function() mc.matchSkipCursor(-1) end)

		-- Add and remove cursors with control + left click.
		set("n", "<c-leftmouse>", mc.handleMouse)
		set("n", "<c-leftdrag>", mc.handleMouseDrag)
		set("n", "<c-leftrelease>", mc.handleMouseRelease)

		-- Disable and enable cursors.
		set({"n", "x"}, "<c-q>", mc.toggleCursor)

		-- Mappings defined in a keymap layer only apply when there are
		-- multiple cursors. This lets you have overlapping mappings.
		mc.addKeymapLayer(function(layerSet)

		    -- Select a different cursor as the main one.
		    layerSet({"n", "x"}, "<left>", mc.prevCursor)
		    layerSet({"n", "x"}, "<right>", mc.nextCursor)

		    -- Delete the main cursor.
		    layerSet({"n", "x"}, "<leader>x", mc.deleteCursor)

		    -- Enable and clear cursors using escape.
		    layerSet("n", "<esc>", function()
			if not mc.cursorsEnabled() then
			    mc.enableCursors()
			else
			    mc.clearCursors()
			end
		    end)
		end)



		-- Pressing `gaip` will add a cursor on each line of a paragraph.
		-- Can also be used to add cursor for each line of visual selection.
		set({"n", "x"}, "ga", mc.addCursorOperator)

		-- Clone every cursor and disable the originals.
		set({"n", "x"}, "<leader><c-q>", mc.duplicateCursors)

		-- Align cursor columns.
		set("n", "<leader>a", mc.alignCursors)

		-- Split visual selections by regex.
		set("x", "S", mc.splitCursors)

		-- match new cursors within visual selections by regex.
		set("x", "M", mc.matchCursors)

		-- bring back cursors if you accidentally clear them
		set("n", "<leader>gv", mc.restoreCursors)

		-- Add a cursor for all matches of cursor word/selection in the document.
		set({"n", "x"}, "<leader>A", mc.matchAllAddCursors)

		-- Rotate the text contained in each visual selection between cursors.
		set("x", "<leader>t", function() mc.transposeCursors(1) end)
		set("x", "<leader>T", function() mc.transposeCursors(-1) end)

		-- Append/insert for each line of visual selections.
		-- Similar to block selection insertion.
		set("x", "I", mc.insertVisual)
		set("x", "A", mc.appendVisual)

		-- Increment/decrement sequences, treating all cursors as one sequence.
		set({"n", "x"}, "g<c-a>", mc.sequenceIncrement)
		set({"n", "x"}, "g<c-x>", mc.sequenceDecrement)

		-- Add a cursor and jump to the next/previous search result.
		set("n", "<leader>/n", function() mc.searchAddCursor(1) end)
		set("n", "<leader>/N", function() mc.searchAddCursor(-1) end)

		-- Jump to the next/previous search result without adding a cursor.
		set("n", "<leader>/s", function() mc.searchSkipCursor(1) end)
		set("n", "<leader>/S", function() mc.searchSkipCursor(-1) end)

		-- Add a cursor to every search result in the buffer.
		set("n", "<leader>/A", mc.searchAllAddCursors)

		-- Pressing `<leader>miwap` will create a cursor in every match of the
		-- string captured by `iw` inside range `ap`.
		-- This action is highly customizable, see `:h multicursor-operator`.
		set({"n", "x"}, "<leader>m", mc.operator)

		-- Add or skip adding a new cursor by matching diagnostics.
		set({"n", "x"}, "]d", function() mc.diagnosticAddCursor(1) end)
		set({"n", "x"}, "[d", function() mc.diagnosticAddCursor(-1) end)
		set({"n", "x"}, "]s", function() mc.diagnosticSkipCursor(1) end)
		set({"n", "x"}, "[S", function() mc.diagnosticSkipCursor(-1) end)

		-- Press `mdip` to add a cursor for every error diagnostic in the range `ip`.
		set({"n", "x"}, "md", function()
			-- See `:h vim.diagnostic.GetOpts`.
			mc.diagnosticMatchCursors({ severity = vim.diagnostic.severity.ERROR })
		end)



		-- Customize how cursors look.
		local hl = vim.api.nvim_set_hl
		hl(0, "MultiCursorCursor", { reverse = true })
		hl(0, "MultiCursorVisual", { link = "Visual" })
		hl(0, "MultiCursorSign", { link = "SignColumn"})
		hl(0, "MultiCursorMatchPreview", { link = "Search" })
		hl(0, "MultiCursorDisabledCursor", { reverse = true })
		hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
		hl(0, "MultiCursorDisabledSign", { link = "SignColumn"})
	    end
	},

    -- Color Theme (Terminal only)
    {
        "folke/tokyonight.nvim",
        lazy = false,    -- Load immediately on startup
        priority = 1000, -- Make sure it loads before any other plugin initializes
        cond = not vim.g.vscode,
        config = function()
            require("tokyonight").setup({
                style = "moon", -- Options: storm, moon, night, day
                transparent = false, 
                styles = {
                    sidebars = "dark",
                    floats = "dark",
                },
            })
        end
    },

    -- File explorer tree (Terminal only)
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons", -- Adds file icons
        },
        cond = not vim.g.vscode,
        config = function()
            -- Recommended global settings for nvim-tree
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1

            require("nvim-tree").setup({
                sort = {
                    sorter = "case_sensitive",
                },
                view = {
                    width = 30,
                    side = "left",
                },
                renderer = {
                    group_empty = true, -- Groups empty folders together
                    highlight_git = true,
                    icons = {
                        show = {
                            git = true,
                        }
                    }
                },
                git = {
                    enable = true,
                },
                filters = {
                    dotfiles = false, -- Set to true if you want to hide .git, .env, etc.
                    custom = { "^build$" },
                },
            })

            -- Keybindings for the explorer
            local set = vim.keymap.set
            set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle Directory Tree" })
            set("n", "<leader>E", ":NvimTreeFindFileToggle<CR>", { desc = "Focus Directory Tree on Current File" })
        end
    },

    -- Telescope fuzzy finder (Terminal only)
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = { 
            "nvim-lua/plenary.nvim",
            -- This makes sorting much faster (requires make/gcc, which you already have)
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }
        },
        cond = not vim.g.vscode,
        config = function()
            local telescope = require("telescope")
            
            telescope.setup({
                defaults = {
                    -- Keep Telescope fast by ignoring heavy binaries and build caches
                    file_ignore_patterns = { 
                        "build/", "^%.git/", "^%.cache/", "%.o$", "%.a$", "%.so$"
                    },
                    -- Make the live_grep search smarter (hidden files, smart case)
                    vimgrep_arguments = {
                        "rg",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                        "--hidden",
                    },
                },
                pickers = {
                    find_files = {
                        hidden = true, -- Allow finding hidden files like .env or .gitignore
                    }
                }
            })
            
            -- Load the compiled C extension for speed
            pcall(telescope.load_extension, "fzf")

            -- Keybindings mapping
            local builtin = require("telescope.builtin")
            local set = vim.keymap.set
            
            -- Matching your VS Code muscle memory!
            set("n", "<leader>ff", builtin.find_files, { desc = "Telescope: Find Files" })
            set("n", "<leader>sf", builtin.live_grep, { desc = "Telescope: Search in Files" })
            
            -- Standard extra Telescope bindings
            set("n", "<leader>fb", builtin.buffers, { desc = "Telescope: Find Buffers" })
            set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope: Help Tags" })
            
            -- C++ LSP Integrations
            set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Telescope: Find Symbols (Functions/Classes)" })
            set("n", "gr", builtin.lsp_references, { desc = "Telescope: Go to References" })
        end
    },

    -- Treesitter code highlighting (Terminal only)
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        lazy = false,
        build = ":TSUpdate", 
        cond = not vim.g.vscode,
        config = function() -- <-- Added this wrapper function
            require'nvim-treesitter.configs'.setup {
              -- A list of parser names, or "all" (the listed parsers MUST always be installed)
              ensure_installed = { "c", "cpp", "cuda", "lua", "python", "cmake", "proto", "vim", "vimdoc", "query", "markdown", "markdown_inline" },

              -- Install parsers synchronously (only applied to `ensure_installed`)
              sync_install = false,

              -- Automatically install missing parsers when entering buffer
              auto_install = true,

              -- List of parsers to ignore installing (or "all")
              ignore_install = { "javascript" },

              highlight = {
                enable = true,

                -- Removed "c" from here so your C code actually highlights!
                disable = function(lang, buf)
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,

                additional_vim_regex_highlighting = false,
              },
            }
        end -- <-- Closed the wrapper function
    },

    -- CMake Integration (Terminal only)
    {
        "Civitasv/cmake-tools.nvim",
        ft = { "c", "cpp", "cmake", "proto", "cuda" },
        dependencies = { "nvim-lua/plenary.nvim" },
        cond = not vim.g.vscode,
        config = function()
            require("cmake-tools").setup({
                cmake_command = "cmake",
                cmake_build_directory = "build", -- Overridden dynamically by Presets
                cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
                cmake_dap_configuration = {
                    name = "Launch GDB",
                    type = "gdb",
                    request = "launch",
                    stopAtEntry = false,
                    runInTerminal = true,
                },
            })

            local set = vim.keymap.set
            set("n", "<leader>cs", ":CMakeSelectBuildPreset<CR>", { desc = "Select Build Preset" })
            set("n", "<leader>cg", ":CMakeGenerate<CR>", { desc = "CMake Generate" })
            set("n", "<leader>cb", ":CMakeBuild<CR>", { desc = "CMake Build" })
            set("n", "<leader>cr", ":CMakeRun<CR>", { desc = "CMake Run" })
            set("n", "<leader>cd", ":CMakeDebug<CR>", { desc = "CMake Debug" })
        end
    },

    -- GDB debugging DAP (Terminal only)
    {
        "mfussenegger/nvim-dap",
        ft = { "c", "cpp", "cuda" },
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "theHamsta/nvim-dap-virtual-text",
        },
        cond = not vim.g.vscode,
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")


            dapui.setup()
            require("nvim-dap-virtual-text").setup()
            -- Integration with VScode launch.json
            require('dap.ext.vscode').load_launchjs(nil, {
                cppdbg = { "c", "cpp", "cuda" },
            })

            -- require('persistent-breakpoints').setup({ 
            --     load_breakpoints_event = { "BufReadPost" }, 
            -- })

            dap.defaults.cpp.exception_breakpoints = { 'cpp_throw' }
            dap.defaults.cpp.exception_breakpoints = { 'throw' } -- Microsoft's cppdbg
            dap.defaults.fallback.terminal_win_cmd = "50vsplit new"

            -- Toggle debugger layout panels automatically
            dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
            dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
            -- dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

            dap.adapters.gdb = {
                type = "executable",
                command = "gdb",
                args = { "-i", "dap" }
            }

            local cpptools = vim.fn.glob(
              vim.fn.expand("~/.vscode/extensions/ms-vscode.cpptools-*/debugAdapters/bin/OpenDebugAD7"),
              false,
              true
            )[1]
            dap.adapters.cppdbg = {
                id = "cppdbg",
                type = "executable",
                command = cpptools,
            }

            local set = vim.keymap.set
            set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
            set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
            set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
            set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })
            set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
        end
    },

    -- Clangd code intellisense (Terminal only)
    {
        "neovim/nvim-lspconfig",
        ft = { "c", "cpp", "cmake", "proto", "cuda" },
        cond = not vim.g.vscode,
        config = function()
            -- 1. Define your custom configuration flags
            local clangd_cmd = {
                "clangd",
                "--background-index",
                "--clang-tidy",
                "--header-insertion=iwyu",
                "--completion-style=detailed",
                "--function-arg-placeholders",
                "--fallback-style=llvm",
            }
            local clangd_init_opts = {
                compilationDatabasePath = "build" 
            }

            -- 2. Modern Neovim 0.11+ API Migration
            -- Fetch the pre-defined community configuration table for clangd
            local clangd_cfg = vim.lsp.config.clangd or {}
            
            -- Deeply merge your custom command adjustments into it
            clangd_cfg.cmd = clangd_cmd
            clangd_cfg.init_options = clangd_init_opts

            -- Register and fully activate the language server natively
            vim.lsp.config("clangd", clangd_cfg)
            vim.lsp.enable("clangd")
            
            -- Basic diagnostic navigation keymaps
            local set = vim.keymap.set
            set("n", "[g", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
            set("n", "]g", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
            set("n", "K", vim.lsp.buf.hover, { desc = "LSP Hover Documentation" })
            set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
        end
    }


}
