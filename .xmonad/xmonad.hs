import qualified XMonad.StackSet as W
import Graphics.X11.ExtraTypes.XF86
import XMonad
--import XMonad.Actions.Volume
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Run(spawnPipe)

-- for some reason stalonetray floats automatically. maybe there is a
-- way not to automatically float it. This works at least.
doSink :: ManageHook
doSink = doF . W.sink =<< ask

manageHook' = composeAll [
  --(className =? "Conkeror" <&&> resource =? "Addons") --> doFloat,
  className =? "Kruler" --> doFloat,
  className =? "qemu-system-x86_64" --> doFloat,
  className =? "stalonetray" --> doShift "10:attic" <+> doSink,
  className =? "Skype" --> doFloat,
  className =? "Vlc" --> doFloat,
  className =? "Wine" --> doFloat,
  className =? "Xmessage" --> doFloat,
  stringProperty "WM_NAME" =? "Crack Attack!" --> doFloat,
  stringProperty "WM_NAME" =? "glxgears" --> doFloat
  ]

modMask' = mod4Mask
workspaces' = ["1:chat","2","3","4","5","6","7","8","9","10:attic"]
workspaceKeys' = [xK_1..xK_9] ++ [xK_0]

main = do
  xmonad $ defaultConfig {
    manageHook = manageHook' <+> manageHook defaultConfig,
    modMask = modMask',
    terminal = "urxvt",
    workspaces = workspaces'
    } `additionalKeys` ([
    ((modMask' .|. shiftMask, xK_e), spawn "emacsclient -c"),
    ((modMask' .|. shiftMask, xK_f), spawn "firefox"),
    ((modMask' .|. shiftMask, xK_k), spawn "conkeror"),
    ((modMask' .|. shiftMask, xK_m), spawn "urxvt -e aumix"),
    ((modMask' .|. shiftMask, xK_o), spawn "urxvt -e check-mail"),
    ((modMask' .|. shiftMask, xK_r), spawn "chromium"),
    ((modMask' .|. shiftMask, xK_t), spawn "urxvt -e ssh tesla"),
    ((modMask' .|. shiftMask, xK_v), spawn "vlc"),
    ((modMask' .|. shiftMask, xK_w), spawn "wpa_gui"),
    ((modMask' .|. shiftMask, xK_z), spawn "xlock"),
    ((0, xK_Print), spawn "scrot -e 'mv $f ~/shots/'"),
    ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s -e 'mv $f ~/shots/'")
  --  ((0, xF86XK_AudioLowerVolume), lowerVolume 2 >>= alert),
  --  ((0, xF86XK_AudioRaiseVolume), raiseVolume 2 >>= alert)
    ] ++ [((m .|. modMask', k), windows $ f i)
         | (i, k) <- zip workspaces' workspaceKeys'
         , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
         ])
