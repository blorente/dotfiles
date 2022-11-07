-- As far as I know, lunarvim doesn't accept symlinks in its root config, so we just load the thing.
package.path = package.path .. ";" .. os.getenv( "HOME" ) .. "/.config/lvim/lua"
require("blorente_config")
