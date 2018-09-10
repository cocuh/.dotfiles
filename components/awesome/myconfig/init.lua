local myconfig = {}

sysconst = require("myconfig.sysconst")

return {
  const = require('myconfig.const'),
  tag = require('myconfig.tag'),
  screen = require('myconfig.screen'),
  wallpaper = require('myconfig.wallpaper'),
  sysconst = sysconst,
  initialize = sysconst.initialize,
}
