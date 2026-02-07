return function(_, bufnr)
  -- we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.

  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

  nmap("gd", function()
    require("snacks").picker.lsp_definitions({
      filter = {
        filter = function(item)
          return not vim.endswith(item.file, "_model_helpers.php")
        end,
      },
    })
  end, "[G]oto [D]efinition")

  -- NOTE: why are these functions that call the telescope builtin?
  -- because otherwise they would load telescope eagerly when this is defined.
  -- due to us using the on_require handler to make sure it is available.
  nmap("gr", function()
    require("snacks").picker.lsp_references()
  end, "[G]oto [R]eferences")
  nmap("gI", function()
    require("snacks").picker.lsp_implementations()
  end, "[G]oto [I]mplementation")
  nmap("<leader>ds", function()
    require("snacks").picker.lsp_symbols()
  end, "[D]ocument [S]ymbols")
  nmap("<leader>ws", function()
    require("snacks").picker.lsp_workspace_symbols()
  end, "[W]orkspace [S]ymbols")

  nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")

  -- See `:help K` for why this keymap
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  nmap("<C-h>", vim.lsp.buf.signature_help, "Signature Documentation")

  -- Lesser used LSP functionality
  nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
  nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
  nmap("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist Folders")

  -- autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh({ bufnr = 0 })
  vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
    buffer = bufnr,
    callback = function()
      vim.lsp.codelens.refresh({ bufnr = 0 })
    end,
  })
end
