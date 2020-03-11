local vim = vim
local api = vim.api
local validate = vim.validate
local configs = require('nvim_lsp/configs')
local util = require('nvim_lsp/util')

local server_name = 'eslint'
local bin_name = 'eslint-language-server'

local function make_installer(config)
  validate {
    server_name = { config.server_name, 's' },
    url = { config.url, 's' },
    filename = { config.filename, 's' },
    binary = { config.binary, 's' }
  }

  local install_dir = util.path.join(util.base_install_dir, config.server_name)
  local binary_path = util.path.join(install_dir, config.binary)

  local function get_install_info()
    return {
      cmd = { binary_path, "--stdio" },
      install_dir = install_dir,
      is_installed = util.has_bins(binary_path)
    }
  end

  local function install()
    if not util.has_bins('sh', 'curl', 'unzip') then
      api.nvim_err_writeln('Installation requires "sh", "curl", "unzip"')
      return
    end

    if get_install_info().is_installed then
      return print(config.server_name, 'is already installed')
    end

    local install_params = {
      install_dir = install_dir,
      url = config.url,
      filename = config.filename,
      binary = config.binary
    }
    local install_script = ([[
      set -e

      curl -L '{{url}}' -o '{{filename}}'
      unzip '{{filename}}'
      rm '{{filename}}'

      cat <<EOF >{{binary}}
#!/usr/bin/env bash

DIR=\$(cd \$(dirname \$0); pwd)
node \$DIR/extension/server/out/eslintServer.js \$*
EOF

      chmod +x {{binary}}
    ]]):gsub('{{(%S+)}}', install_params)

    vim.fn.mkdir(install_params.install_dir, 'p')
    util.sh(install_script, install_params.install_dir)

    if not get_install_info().is_installed then
      api.nvim_err_writeln('Installation of ' .. config.server_name .. ' failed')
    end
  end

  return {
    install = install,
    info = get_install_info
  }
end

local installer = make_installer {
  server_name = server_name,
  url = 'https://github.com/microsoft/vscode-eslint/releases/download/release%2F2.1.0-next.1/vscode-eslint-2.1.0.vsix',
  filename = 'vscode-eslint.vsix',
  binary = bin_name
}

-- if not nvim_lsp[server_name] then
  configs[server_name] = {
    default_config = util.utf8_config {
      cmd = installer.info().cmd,
      filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
      root_dir = util.root_pattern('package.json'),
      settings = {
        eslint = {
          quiet = false
        }
      }
    },
    on_new_config = function(new_config)
      local install_info = installer.info()
      if install_info.is_installed then
        if type(new_config.cmd) == 'table' then
          -- Try to preserve any additional args from upstream changes.
          new_config.cmd[1] = install_info.binaries[bin_name]
        else
          new_config.cmd = { install_info.binaries[bin_name] }
        end
      end
    end,
    docs = {
      description = [[
      TODO: Description
]],
      default_config = {
        root_dir = [[root_pattern("package.json")]],
      }
    }
  }
-- end

configs[server_name].install = installer.install
configs[server_name].install_info = installer.info
