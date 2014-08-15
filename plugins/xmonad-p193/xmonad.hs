import XMonad
import Data.Monoid
import System.Exit

import XMonad.Layout.WindowNavigation
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog

import XMonad.Util.Run
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
myWorkspaces = ["1","2","3","4","5","6","7","8","9","0"]

--Workspace application attach
myManageHook = composeAll
	[className =? "mikutter" --> doShift "6"
	---
	,className =? "Gimp" --> doFloat
	]

--Keybinding
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
	[((modm.|.shiftMask,xK_Return),spawn $ XMonad.terminal  conf)
	,((modm,            xK_Return),spawn $ XMonad.terminal  conf)
	,((modm,            xK_p     ),spawn "dmenu_run")
	,((modm,            xK_d     ),spawn "dmenu_run")
	,((modm.|.shiftMask,xK_c     ),kill)
	,((modm.|.shiftMask,xK_q     ),kill)
	,((modm,            xK_f     ),sendMessage NextLayout)
	--,((modm,            xK_f     ),sendMessage $ Toggle FULL) ---なぜかできない
	,((modm,            xK_n     ),refresh)
	,((modm,            xK_t     ),withFocused $ windows . W.sink)
	--Restart and Quit
	,((modm.|.shiftMask,xK_r     ),spawn "xmonad --recompile; xmonad --restart")
	,((modm.|.shiftMask,xK_Escape),io(exitWith ExitSuccess))

	--wallpaper change
	,((modm,            xK_w     ),spawn "python /home/cocu/bin/WallpaperChanger/wallpaperchanger.py")
	,((modm.|.shiftMask,xK_w     ),spawn "feh --bg-fill ~/picture/wallpaper/saya.jpg")
	,((modm,            xK_m     ),spawn "python /home/cocu/bin/utils/minecraft-input_helper")


	--move focus
	,((modm,            xK_j     ),sendMessage $ Go D)
	,((modm,            xK_k     ),sendMessage $ Go U)
	,((modm,            xK_h     ),sendMessage $ Go L)
	,((modm,            xK_l     ),sendMessage $ Go R)
	--move window
	,((modm.|.shiftMask,xK_j     ),windows W.swapDown)
	,((modm.|.shiftMask,xK_k     ),windows W.swapUp)
	--------spawp the focused window and the master window
	,((modm,            xK_space ),windows W.swapMaster)
	--reset workspace
	,((modm,            xK_r     ),do
		screenWorkspace 0 >>= flip whenJust (windows . W.view)
		(windows . W.greedyView) "0"
		screenWorkspace 1 >>= flip whenJust (windows . W.view)
		(windows . W.greedyView) "1")
	--,((modm,            
	--,((modm.|.shiftMask,
	]
	++
	
	--Workspace Keybinding
    	[((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1,xK_2,xK_3,xK_4,xK_5,xK_6,xK_7,xK_8,xK_9,xK_0]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
	++

	--screen selecting
    	[((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_bracketright, xK_bracketleft] [0..]
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
	,terminal = "urxvt"
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

