local nvim_lsp = require'nvim_lsp'
local configs = require'nvim_lsp/configs'
local util = require'nvim_lsp/util'

local server_name = "graphql"
local bin_name = "graphql"

local installer = util.npm_installer {
  server_name = server_name;
  packages = {"graphql-language-service@2.3.2"};
  binaries = {bin_name}
}

-- Check if it's already defined for when I reload this file.
-- if not nvim_lsp[server_name] then
  configs[server_name] = {
    default_config = util.utf8_config {
      cmd = {bin_name, "server"};
      filetypes = {"graphql"};
      root_dir = util.root_pattern(".graphqlrc.yml");
    };
    on_new_config = function(new_config)
      local install_info = installer.info()
      if install_info.is_installed then
        if type(new_config.cmd) == 'table' then
          -- Try to preserve any additional args from upstream changes.
          new_config.cmd[1] = install_info.binaries[bin_name]
        else
          new_config.cmd = {install_info.binaries[bin_name]}
        end
      end
    end;
    docs = {
      description = [[
https://github.com/graphql/graphiql/tree/master/packages/graphql-language-service

`graphql-language-service` can be installed via `:LspInstall graphql` or by yourselv with npm:
```sh
npm install -g graphql-language-service
```
]];
      default_config = {
        root_dir = [[root_pattern(".graphqlrc.yml")]];
        on_init = [[function to handle changing offsetEncoding]];
        capabilities = [[default capabilities, with offsetEncoding utf-8]];
      }
    }
  }
-- end

configs[server_name].install = installer.install
configs[server_name].install_info = installer.info

-- vim:et ts=2 sw=2
