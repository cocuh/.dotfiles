import XMonad
import Data.Monoid
import System.Exit

import XMonad.Actions.WindowBringer

import XMonad.Layout.WindowNavigation
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog

import XMonad.Util.Run
import XMonad.Util.NamedScratchpad
import System.IO

import qualified XMonad.StackSet as W
import qualified Data.Map as M

import XMonad.Hooks.SetWMName

import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders

--Layout
myLayout = windowNavigation(tiled) ||| Mirror tiled ||| noBorders (fullscreenFull Full)
    where 
    tiled = Tall nmaster delta ratio
    nmaster = 1
    ratio = 3/5
    delta = 5/100

--Workspace
myWorkspaces = ["1","2","3","4","5","6","7","8","9","0", "-", "="]

--Workspace application attach
myManageHook = composeAll
    ([className =? "mikutter" --> doShift "6"
    ---
    ,className =? "Gimp" --> doFloat
    ])<+>manageScratchpad

--Scrwatchpad
scratchpads :: [NamedScratchpad]
scratchpads = [
    NS "htop"
        "mlterm -T=htop -e htop"
        (title =? "htop")
        (customFloating $ W.RationalRect (1/12) (1/12) (5/6) (5/6)),

    NS "tmp"
        "mlterm -T=tmp"
        (title =? "tmp")
        (customFloating $ W.RationalRect (1/12) (1/12) (5/6) (5/6)),

    NS "stardict"
        "stardict"
        (title =? "StarDict")
        (customFloating $ W.RationalRect (1/12) (1/12) (5/6) (5/6))]


manageScratchpad :: ManageHook
manageScratchpad = namedScratchpadManageHook scratchpads


--Keybinding
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [((modm.|.shiftMask,xK_Return),spawn "mlterm")
    ,((modm,            xK_Return),spawn $ XMonad.terminal  conf)
    --,((modm,            xK_p     ),spawn "dmenu_run")
    ,((modm,            xK_d     ),spawn "rofi -show run -font 'Ricty 14' -fg '#00ff00' -bg '#000000' -hlfg '#b9ff64' -hlbg '#303030' -opacity 85")
    ,((modm,            xK_n     ),spawn "rofi -show window -font 'Ricty 14' -fg '#a0a0a0' -bg '#000000' -hlfg '#ffb964' -hlbg '#303030' -fg-active '#ffb0b0' -opacity 85")
    ,((modm,            xK_Tab   ),spawn "rofi -show window -font 'Ricty 14' -fg '#a0a0a0' -bg '#000000' -hlfg '#ffb964' -hlbg '#303030' -fg-active '#ffb0b0' -opacity 85")
    ,((modm.|.shiftMask,xK_c     ),kill)
    ,((modm.|.shiftMask,xK_q     ),kill)
    ,((modm,            xK_f     ),sendMessage NextLayout)
    --,((modm,            xK_f     ),sendMessage $ Toggle FULL) ---なぜかできない
    ,((modm,            xK_comma ),refresh)
    ,((modm,            xK_t     ),withFocused $ windows . W.sink)
    --Restart and Quit
    ,((modm.|.shiftMask,xK_r     ),spawn "xmonad --recompile; xmonad --restart")
    ,((modm.|.shiftMask,xK_Escape),io(exitWith ExitSuccess))

    --wallpaper change
    ,((modm,            xK_w     ),spawn "python /home/cocuh/bin/WallpaperChanger/wallpaperchanger.py")
    ,((modm.|.shiftMask,xK_w     ),spawn "feh --bg-fill ~/picture/wallpaper/saya.jpg")

    --move focus
    ,((modm,            xK_j     ),windows W.focusDown)
    ,((modm,            xK_k     ),windows W.focusUp)
    ,((modm,            xK_h     ),sendMessage Shrink)
    ,((modm,            xK_l     ),sendMessage Expand)
    --move window
    ,((modm.|.shiftMask,xK_j     ),windows W.swapDown)
    ,((modm.|.shiftMask,xK_k     ),windows W.swapUp)
    --------spawp the focused window and the master window
    ,((modm,            xK_space ),windows W.swapMaster)
    --reset workspace
    ,((modm,            xK_r     ),do
        screenWorkspace 0 >>= flip whenJust (windows . W.view)
        (windows . W.greedyView) "1"
        screenWorkspace 1 >>= flip whenJust (windows . W.view)
        (windows . W.greedyView) "-")
    --Scratchpad
    ,((modm,            xK_grave ),namedScratchpadAction scratchpads "htop")
    ,((modm,            xK_t     ),namedScratchpadAction scratchpads "tmp")
    ,((modm,            xK_e     ),namedScratchpadAction scratchpads "stardict")
    ,((modm,            xK_slash ),spawn "import ~/hoge.png && mogrify +repage ~/hoge.png")
    ,((modm.|.shiftMask,xK_slash ),spawn "import -window \"$(xdotool getwindowfocus -f)\" ~/hoge.png && mogrify +repage ~/hoge.png")
    ,((modm.|.shiftMask,xK_comma ),spawn "import -window root ~/hoge.png && mogrify +repage ~/hoge.png")
    ,((modm.|.shiftMask,xK_Print ),spawn "import -window root ~/hoge.png && mogrify +repage ~/hoge.png")
    ,((modm,            xK_o     ),spawn "~/bin/utils/xrandr_one")
    ,((modm.|.shiftMask,xK_o     ),spawn "~/bin/utils/xrandr_init")
    --,((modm,            
    --,((modm.|.shiftMask,
    ]
    ++
    
    --Workspace Keybinding
        [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1,xK_2,xK_3,xK_4,xK_5,xK_6,xK_7,xK_8,xK_9,xK_0,xK_minus,xK_equal]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    ++

    --screen selecting
        [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_bracketleft, xK_bracketright] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
        ++
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_z, xK_x] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
    ]


main = do
    xmonad $ defaultConfig{
     borderWidth = 1
    ,normalBorderColor = "#000000"
    ,focusedBorderColor = "#2222BB"
    ----------------------------------
    ,terminal = "mlterm"
    ----------------------------------
    ,layoutHook = avoidStruts$myLayout
    ,workspaces = myWorkspaces
    ,manageHook = myManageHook <+> manageHook defaultConfig
    ,startupHook=setWMName "LG3D"
    --Keybinding
    ,keys = myKeys
    ,mouseBindings = myMouseBindings
    ,focusFollowsMouse = False
    --
    ,modMask = mod4Mask
    }

