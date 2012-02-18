import XMonad.Config.Xfce
import XMonad.Layout.Named
import qualified XMonad.StackSet as W
import XMonad.Layout.SimpleFloat
import XMonad
import XMonad.Core
import XMonad.Layout.Spacing
 
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.Man
 
import XMonad.Layout
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
 
import XMonad.Hooks.DynamicLog hiding (dzen)
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.SetWMName
import XMonad.Hooks.XPropManage
 
import XMonad.Util.EZConfig
import XMonad.Util.Run
import Graphics.X11.Xlib
import qualified Data.Map as M
import Data.List
import System.IO

--main = xmonad $ defaults
myBorderWidth = 1
myModMask = mod1Mask
myNormalBorderColor = "#cccccc"
--myWorkSpaces = ["1:main","2:web","3:code","4:chat","5:misc"]
myWorkSpaces = ["L","2","3","4"] ++ map show[5..7]

myFont = "-*-terminus-*-*-*-*-12-*-*-*-*-*-iso8859-*"
myBitmapsPath = "/root/xbm8x8/"
--q_vim         = (fmap (isPrefixOf "vim:") title <&&> q_xterms) <||> appName =? "xterm-vim" -- title is not set immediately
myManageHook = composeAll . concat $
             [
		-- web
		[className =? b --> doF (W.shift "2") | b <- myClassWebShifts]
	       ,[className =? c --> doF  (W.shift "5") | c <- myClassChatShifts]
	       ,[className =? d --> doF (W.shift "3") | d <- myClassCodeShifts]
               ,[title =? f --> doF (W.shift "4") | f <- myClassMailShifts]
               ,[(fmap ( c `isInfixOf`) title) --> doF (W.shift "3") | c <- vimTerm]
               --,[ fmap ( "vim: " `isInfixOf`) title     --> doF (W.shift "3:code")]
               --,[(title =? e <&&> className =? "rxvt-256color") --> doF (W.shift "3:code") | e <- vimTerm]

	     ] 
		where
		myClassWebShifts = ["Firefox", "Filezilla", "Chromium"]
		myClassChatShifts = ["emesene", "Xchat", "iirsi"]
		myClassCodeShifts = ["Gvim"]
                myClassMailShifts = ["mutt"]
                vimTerm           = ["vim", "vim:","vim: "] 

-- myManageHook3 :: ManageHook
-- myManageHook3 = xPropManageHook xPropMatches

xPropMatches :: [XPropMatch]
xPropMatches = [([(wM_NAME, any("vim:" `isInfixOf`))], pmP(W.shift "3"))]
 
 
  

--myManageHook = composeAll
--   [ className =? "Gimp" --> doFloat ]

--myWorkSpaces =
--   [
--      wrapBitmap "arch_10x10.xbm",
--      wrapBitmap "fox.xbm",
--      wrapBitmap "dish.xbm",
--      wrapBitmap "cat.xbm",
--      wrapBitmap "empty.xbm",
--      wrapBitmap "shroom.xbm",
--      wrapBitmap "bug_02.xbm",
--      wrapBitmap "eye_l.xbm",
--     wrapBitmap "eye_r.xbm" 

--   ]
--   where
--      wrapBitmap bitmap = "^p(5)^i(" ++ myBitmapsPath ++ bitmap ++ ")^p(5)"


-- Colors
myBgBgColor = "black"
myFgColor = "gray80"
myBgColor = "gray20"
myHighlightedFgColor = "white"
myHighlightedBgColor = "gray40"
 
myActiveBorderColor = "gray80"
myInactiveBorderColor = "gray20"
 
myCurrentWsFgColor = "white"
myCurrentWsBgColor = "gray40"
myVisibleWsFgColor = "gray80"
myVisibleWsBgColor = "gray20"
myHiddenWsFgColor = "gray80"
myHiddenEmptyWsFgColor = "gray50"
myUrgentWsBgColor = "brown"
myTitleFgColor = "white"
 
myUrgencyHintFgColor = "white"
myUrgencyHintBgColor = "brown"

myFocusBorderColor = "#cd8b00"
myDefaultGaps = [(0,0,0,0)]
-------------------- layouthooks --------------------

myLayoutHook' = customLayout
customLayout = avoidStrutsOn [U] (spaced ||| smartBorders tiled ||| smartBorders (Mirror tiled) ||| noBorders Full)
	where
	 spaced = named "Spacing" $ spacing 4 $ Tall 1 (3/100) (1/2)
	 tiled  = named "Tiled" $ spacing 4 $ ResizableTall 1 (2/100) (1/2) []

-- Define defalut layouts used on most workspaces
--defaultLayouts = tiled ||| Mirror tiled ||| simpleFloat ||| Full
--myLayout = avoidStruts (tiled ||| Mirror tiled ||| Full) ||| Full
--	where
--	--defautl tiling algorithm partitions the sce
--	tiled = Tall nmaster delta ratio
--	-- The default number of windows in the master pane
--	nmaster = 1
--	--Default proportion of screen occupied by master pan
--	ratio = 1/2
--	delta = 3/100

logHook' ::  Handle -> X ()
--h is ajust a variable
logHook' h = dynamicLogWithPP $ customPP { ppOutput = hPutStrLn h }
customPP :: PP
customPP = defaultPP
	{
	-- display current workspace as darkgrey on light grey 
	--ppCurrent  = dzenColor "#303030" "#909090" . pad
	--ppCurrent  = wrapFgBg myCurrentWsFgColor myCurrentWsBgColor
	--ppCurrent  = wrap "^fg(#000000)^bg(#a6c292) " " ^fg()^bg()"
        ppCurrent    = dzenColor myOrange my20grey . wrap ( "^i(" ++ myBitmapsPath ++ "plus.xbm)"  ) "" . dzenColor myBlue "". pad
        -- ppCurrent = dzenColor my30grey my90grey . wrap ("^fg(" ++ myIFGColor ++ ")^i(" ++ myBitmapsPath ++ "plus.xbm)") "". pad
        --ppCurrent  = wrap "^fg(#eeeeee)^bg(#89b83f)^p(2)^i(~/xbm8x8/eye_l.xbm)" "^p(2)^fg()^bg()"
	-- display other workspaces which contain windows as a brighter grey
       ,ppHidden 	= dzenColor mydrkyllw "" . wrap ("^i(" ++ myBitmapsPath ++ "square_nv.xbm)") "" .dzenColor mydrkblue "" . pad
	-- display other workspaces with no windows as a normal grey
       ,ppHiddenNoWindows	= dzenColor my11grey ""  . pad
	-- display the current layout as a brighter grey
       ,ppLayout 		= dzenColor "#909090" "" .
        (
        \x -> case x of
            "Spacing" -> wrapBitmap "arch.xbm"
            "Tiled" -> wrapBitmap "ac.xbm"
            "Mirror Tiled" -> wrapBitmap "half.xbm"
            "Full" -> wrapBitmap "stop.xbm"
        )

	-- if a window on a hidden workspace needs my attention, wrap its workspace with bright red braces 
       -- ,ppUrgent		= wrap (dzenColor "#ff0000" "" "[") (dzenColor "#ff0000" "" "]") . pad 
        ,ppUrgent = dzenColor myYellow "" . wrap ( "^i(" ++ myBitmapsPath ++ "square.xbm)" ) "" . dzenColor mydrkblue "". dzenStrip
        -- show the current window's title as a brightergrey and bracketed, aslo shorten if it goes over 40 characters
       ,ppTitle			= wrap "^fg(#031c4b) [" "] ^fg()". shorten 60
       -- ,ppTitle                 = wrap("^fg(" ++ mydarkOr ++ "[") . shorten 60
	-- no seperator between workspaces
       ,ppWsSep			= ""
	-- put a few spaces between each object
       ,ppSep			= ""
        -- h is a just a variable (has to be the same above)
	}
	where
    		wrapBitmap bitmap = "^p(9)^i(" ++ myBitmapsPath ++ bitmap ++ ")^p(9)"
--myStatusBar  = "dzen2 -p -ta l -fn Verdana-8 -x 0 -y 0 -w 450 -h 15 -fg '#606060' -bg '#303030' "
my11grey       = "#1c1818"
my14blue       = "#1463f4"
my30grey       = "#303030"
-- my30grey    = "#ff0000"
myBlue         = "#1464F4"
mydrkblue      = "#031c4b"
myOrange       = "#ffa500"
myOrange2      = "#ffce73"
mydarkOr       = "#794f00"
-- myYellow    = "#ffd700"
myYellow       = "#ffcf00"
mydrkyllw      = "#4a4400"
myWhite        = "#ffffff"
myRed          = "#ff0000"
my20grey       = "#202020"
my90grey       = "#909090"
-- my90grey    = "#0000ff"

myIFGColor     = "#ffffff" -- Icon
-- myIFGColor  = "#000000"
-- myRIFGColor = "#ff0000"

myStatusBar = "dzen2 -w 650 -h 18 -ta l -fg '#3EB5FF' -bg '#000000'"

myConky = "conky -c ~/.conkyrc | dzen2 -x '650' -y '0' -h 18 -w 750 -ta l -fg '#3EB5FF' -bg '#000000'"
main = do
       myStatusBarPipe <- spawnPipe myStatusBar
       myConkyPipe <- spawnPipe myConky
       -- xmonad $ withUrgencyHook dzenUrgencyHook { args = ["-bg", "brickred", "-xs", "1"] } $ xfceConfig 
       xmonad $ withUrgencyHook NoUrgencyHook $ xfceConfig
        { 
                borderWidth        = 1,
                terminal           = "urxvt",
                normalBorderColor  = "#00cccc",
                focusedBorderColor = "#cd8b00",
                workspaces         = myWorkSpaces,
                manageHook         = myManageHook <+> manageDocks,
                logHook            = logHook' myStatusBarPipe,
                layoutHook         = myLayoutHook'
        } 
