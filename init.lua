-- DO NOT EDIT THIS FILE DIRECTLY
-- This is a file generated from a literate programing source file located at
-- https://github.com/zzamboni/dot-hammerspoon/blob/master/init.org.
-- You should make any changes there and regenerate it from Emacs org-mode using C-c C-v t

hs.logger.defaultLogLevel="info"

hyper       = {"cmd","alt","ctrl"}
shift_hyper = {"cmd","alt","ctrl","shift"}
ctrl_cmd    = {"cmd","ctrl"}

col = hs.drawing.color.x11

work_logo = hs.image.imageFromPath(hs.configdir .. "/files/work_logo_2x.png")

hs.loadSpoon("SpoonInstall")

spoon.SpoonInstall.repos.zzspoons = {
  url = "https://github.com/zzamboni/zzSpoons",
  desc = "zzamboni's spoon repository",
}

spoon.SpoonInstall.use_syncinstall = true

Install=spoon.SpoonInstall

Install:andUse("BetterTouchTool", { loglevel = 'debug' })
BTT = spoon.BetterTouchTool

DefaultBrowser = "com.brave.Browser.dev"
-- DefaultBrowser = "com.google.Chrome"
JiraApp = "org.epichrome.eng.Jira"
WikiApp = "org.epichrome.eng.Wiki"
CollabApp = DefaultBrowser
SmcaApp = DefaultBrowser
OpsGenieApp = DefaultBrowser

Install:andUse("URLDispatcher",
               {
                 config = {
                   url_patterns = {
                     { "https?://issue.swisscom.ch",          JiraApp },
                     { "https?://issue.swisscom.com",         JiraApp },
                     { "https?://jira.swisscom.com",          JiraApp },
                     { "https?://wiki.swisscom.com",          WikiApp },
                     { "https?://collaboration.swisscom.com", CollabApp },
                     { "https?://smca.swisscom.com",          SmcaApp },
                     { "https?://app.opsgenie.com",           OpsGenieApp },
                     { "https?://app.eu.opsgenie.com",        OpsGenieApp },
                     { "msteams:",                            "com.microsoft.teams" }
                   },
                   url_redir_decoders = {
                     { "Office 365 safelinks check",
                       "https://eur03.safelinks.protection.outlook.com/(.*)\\?url=(.-)&.*",
                       "%2" },
                     { "MS Teams URLs",
                       "(https://teams.microsoft.com.*)", "msteams:%1", true },
                     { "Fix broken Preview anchor URLs",
                       "%%23", "#", false, "Preview" },
                   },
                   default_handler = DefaultBrowser
                 },
                 start = true,
                 -- loglevel = 'debug'
               }
)

Install:andUse("WindowHalfsAndThirds",
               {
                 config = {
                   use_frame_correctness = true
                 },
                 hotkeys = 'default'
               }
)

myGrid = { w = 6, h = 4 }
Install:andUse("MiroWindowsManager",
               {
                 disable = true,
                 config = {
                   GRID = myGrid
                 },
                 hotkeys = {
                   up =         { ctrl_cmd, "up" },
                   right =      { ctrl_cmd, "right" },
                   down =       { ctrl_cmd, "down" },
                   left =       { ctrl_cmd, "left" },
                   fullscreen = { hyper,    "up" }
                 }
               }
)

Install:andUse("WindowGrid",
               {
                 config = { gridGeometries = { { myGrid.w .."x" .. myGrid.h } } },
                 hotkeys = {show_grid = {hyper, "g"}},
                 start = true
               }
)

Install:andUse("WindowScreenLeftAndRight",
               {
                 config = {
                   animationDuration = 0
                 },
                 hotkeys = 'default'
               }
)

Install:andUse("ToggleScreenRotation",
               {
                 hotkeys = { first = {hyper, "f15"} }
               }
)

Install:andUse("UniversalArchive",
               {
                 config = {
                   evernote_archive_notebook = ".Archive",
                   archive_notifications = false
                 },
                 hotkeys = { archive = { { "ctrl", "cmd" }, "a" } }
               }
)

function chrome_item(n)
  return { apptype = "chromeapp", itemname = n }
end

function OF_register_additional_apps(s)
  s:registerApplication("Swisscom Collab", chrome_item("tab"))
  s:registerApplication("Swisscom Wiki", chrome_item("wiki page"))
  s:registerApplication("Swisscom Jira", chrome_item("issue"))
  s:registerApplication("Brave Browser Dev", chrome_item("page"))
end

Install:andUse("SendToOmniFocus",
               {
                 disable = true,
                 config = {
                   quickentrydialog = false,
                   notifications = false
                 },
                 hotkeys = {
                   send_to_omnifocus = { hyper, "t" }
                 },
                 fn = OF_register_additional_apps,
               }
)

Install:andUse("EvernoteOpenAndTag",
               {
                 hotkeys = {
                   open_note = { hyper, "o" },
                   --                     ["open_and_tag-+work"] = { hyper, "w" },
                   --                     ["open_and_tag-+personal"] = { hyper, "p" },
                   --                     ["tag-@zzdone"] = { hyper, "z" }
                 }
               }
)

Install:andUse("TextClipboardHistory",
               {
                 disable = true,
                 config = {
                   show_in_menubar = false,
                 },
                 hotkeys = {
                   toggle_clipboard = { { "cmd", "shift" }, "v" } },
                 start = true,
               }
)

function BTT_restart_hammerspoon(s)
  BTT:bindSpoonActions(s, {
                         config_reload = {
                           kind = 'touchbarButton',
                           uuid = "FF8DA717-737F-4C42-BF91-E8826E586FA1",
                           name = "Restart",
                           icon = hs.image.imageFromName(hs.image.systemImageNames.ApplicationIcon),
                           color = hs.drawing.color.x11.orange,
  }})
end

Install:andUse("Hammer",
               {
                 repo = 'zzspoons',
                 config = { auto_reload_config = false },
                 hotkeys = {
                   config_reload = {hyper, "r"},
                   toggle_console = {hyper, "y"}
                 },
                 fn = BTT_restart_Hammerspoon,
                 start = true
               }
)

function BTT_caffeine_widget(s)
  BTT:bindSpoonActions(s, {
                         toggle = {
                           kind = 'touchbarWidget',
                           uuid = '72A96332-E908-4872-A6B4-8A6ED2E3586F',
                           name = 'Caffeine',
                           widget_code = [[
  do
    title = " "
    icon = hs.image.imageFromPath(spoon.Caffeine.spoonPath.."/caffeine-off.pdf")
    if (hs.caffeinate.get('displayIdle')) then
      icon = hs.image.imageFromPath(spoon.Caffeine.spoonPath.."/caffeine-on.pdf")
    end
    print(hs.json.encode({ text = title,
                           icon_data = BTT:hsimageToBTTIconData(icon) }))
  end
      ]],
                           code = "spoon.Caffeine.clicked()",
                           widget_interval = 1,
                           color = hs.drawing.color.x11.black,
                           icon_only = true,
                           icon_size = hs.geometry.size(15,15),
                           BTTTriggerConfig = {
                             BTTTouchBarFreeSpaceAfterButton = 0,
                             BTTTouchBarItemPadding = -6,
                           },
                         }
  })
end

Install:andUse("Caffeine", {
                 start = true,
                 hotkeys = {
                   toggle = { hyper, "1" }
                 },
                 fn = BTT_caffeine_widget,
})

Install:andUse("MenubarFlag",
               {
                 config = {
                   colors = {
                     ["U.S."] = { },
                     Spanish = {col.green, col.white, col.red},
                     ["Latin American"] = {col.green, col.white, col.red},
                     German = {col.black, col.red, col.yellow},
                   }
                 },
                 start = true
               }
)

Install:andUse("MouseCircle",
               {
                 disable = true,
                 config = {
                   color = hs.drawing.color.x11.rebeccapurple
                 },
                 hotkeys = {
                   show = { hyper, "m" }
                 }
               }
)

Install:andUse("ColorPicker",
               {
                 disable = true,
                 hotkeys = {
                   show = { hyper, "z" }
                 },
                 config = {
                   show_in_menubar = false,
                 },
                 start = true,
               }
)

Install:andUse("BrewInfo",
               {
                 config = {
                   brew_info_style = {
                     textFont = "Inconsolata",
                     textSize = 14,
                     radius = 10 }
                 },
                 hotkeys = {
                   -- brew info
                   show_brew_info = {hyper, "b"},
                   open_brew_url = {shift_hyper, "b"},
                   -- brew cask info
                   show_brew_cask_info = {shift_hyper, "c"},
                   open_brew_cask_url = {hyper, "c"},
                 }
               }
)

Install:andUse("TimeMachineProgress",
               {
                 start = true
               }
)

Install:andUse("TurboBoost",
               {
                 config = {
                   disable_on_start = true
                 },
                 hotkeys = {
                   toggle = { hyper, "0" }
                 },
                 start = true,
                 --                   loglevel = 'debug'
               }
)

Install:andUse("EjectMenu", {
                 config = {
                   eject_on_lid_close = true,
                   show_in_menubar = true,
                   notify = true,
                 },
                 hotkeys = { ejectAll = { hyper, "=" } },
                 start = true,
                 loglevel = 'debug'
})

Install:andUse("HeadphoneAutoPause",
               {
                 start = true
               }
)

Install:andUse("Seal",
               {
                 hotkeys = { show = { {"cmd"}, "space" } },
                 fn = function(s)
                   s:loadPlugins({"apps", "calc", "safari_bookmarks",
                                  "screencapture", "useractions"})
                   s.plugins.safari_bookmarks.always_open_with_safari = false
                   s.plugins.useractions.actions =
                     {
                         ["Hammerspoon docs webpage"] = {
                           url = "http://hammerspoon.org/docs/",
                           icon = hs.image.imageFromName(hs.image.systemImageNames.ApplicationIcon),
                         },
                         ["Leave corpnet"] = {
                           fn = function()
                             spoon.WiFiTransitions:processTransition('foo', 'corpnet01')
                           end,
                           icon = work_logo,
                         },
                         ["Arrive in corpnet"] = {
                           fn = function()
                             spoon.WiFiTransitions:processTransition('corpnet01', 'foo')
                           end,
                           icon = work_logo,
                         },
                         ["Translate using Leo"] = {
                           url = "http://dict.leo.org/englisch-deutsch/${query}",
                           icon = 'favicon',
                           keyword = "leo",
                         }
                     }
                   s:refreshAllCommands()
                 end,
                 start = true,
               }
)

function reconfigSpotifyProxy(proxy)
  local spotify = hs.appfinder.appFromName("Spotify")
  local lastapp = nil
  if spotify then
    lastapp = hs.application.frontmostApplication()
    spotify:kill()
    hs.timer.usleep(40000)
  end
  -- I use CFEngine to reconfigure the Spotify preferences
  cmd = string.format(
    "/usr/local/bin/cf-agent -K -f %s/files/spotify-proxymode.cf%s",
    hs.configdir, (proxy and " -DPROXY" or " -DNOPROXY"))
  output, status, t, rc = hs.execute(cmd)
  if spotify and lastapp then
    hs.timer.doAfter(
      3,
      function()
        if not hs.application.launchOrFocus("Spotify") then
          hs.notify.show("Error launching Spotify", "", "")
        end
        if lastapp then
          hs.timer.doAfter(0.5, hs.fnutils.partial(lastapp.activate, lastapp))
        end
    end)
  end
end

function reconfigAdiumProxy(proxy)
  app = hs.application.find("Adium")
  if app and app:isRunning() then
    local script = string.format([[
  tell application "Adium"
    repeat with a in accounts
      if (enabled of a) is true then
        set proxy enabled of a to %s
      end if
    end repeat
    go offline
    go online
  end tell
  ]], hs.inspect(proxy))
    hs.osascript.applescript(script)
  end
end

function stopApp(name)
  app = hs.application.get(name)
  if app and app:isRunning() then
    app:kill()
  end
end

function forceKillProcess(name)
  hs.execute("pkill " .. name)
end

function startApp(name)
  hs.application.open(name)
end

Install:andUse("WiFiTransitions",
               {
                 config = {
                   actions = {
                     -- { -- Test action just to see the SSID transitions
                     --    fn = function(_, _, prev_ssid, new_ssid)
                     --       hs.notify.show("SSID change",
                     --          string.format("From '%s' to '%s'",
                     --          prev_ssid, new_ssid), "")
                     --    end
                     -- },
                     { -- Enable proxy config when joining corp network
                       to = "corpnet01",
                       fn = {hs.fnutils.partial(reconfigSpotifyProxy, true),
                             hs.fnutils.partial(reconfigAdiumProxy, true),
                             hs.fnutils.partial(forceKillProcess, "Dropbox"),
                             hs.fnutils.partial(stopApp, "Evernote"),
                       }
                     },
                     { -- Disable proxy config when leaving corp network
                       from = "corpnet01",
                       fn = {hs.fnutils.partial(reconfigSpotifyProxy, false),
                             hs.fnutils.partial(reconfigAdiumProxy, false),
                             hs.fnutils.partial(startApp, "Dropbox"),
                       }
                     },
                   }
                 },
                 start = true,
               }
)

local wm=hs.webview.windowMasks
Install:andUse("PopupTranslateSelection",
               {
                 config = {
                   popup_style = wm.utility|wm.HUD|wm.titled|
                     wm.closable|wm.resizable,
                 },
                 hotkeys = {
                   translate_to_en = { hyper, "e" },
                   translate_to_de = { hyper, "d" },
                   translate_to_es = { hyper, "s" },
                   translate_de_en = { shift_hyper, "e" },
                   translate_en_de = { shift_hyper, "d" },
                 }
               }
)

Install:andUse("DeepLTranslate",
               {
                 disable = true,
                 config = {
                   popup_style = wm.utility|wm.HUD|wm.titled|
                     wm.closable|wm.resizable,
                 },
                 hotkeys = {
                   translate = { hyper, "e" },
                 }
               }
)

Install:andUse("Leanpub",
               {
                 config = {
                   watch_books = {
                     -- api_key gets set in init-local.lua like this:
                     -- spoon.Leanpub.api_key = "my-api-key"
                     { slug = "learning-hammerspoon" },
                     { slug = "learning-cfengine" },
                     { slug = "emacs-org-leanpub" },
                     { slug = "be-safe-on-the-internet" },
                     { slug = "lit-config"  },
                     { slug = "zztestbook" },
                   },
                   books_sync_to_dropbox = true,
                 },
                 start = true,
})

Install:andUse("KSheet", {
                 hotkeys = {
                   toggle = { hyper, "/" }
                 }
})

local localfile = hs.configdir .. "/init-local.lua"
if hs.fs.attributes(localfile) then
  dofile(localfile)
end

Install:andUse("FadeLogo",
               {
                 config = {
                   default_run = 1.0,
                 },
                 start = true
               }
)

-- hs.notify.show("Welcome to Hammerspoon", "Have fun!", "")
