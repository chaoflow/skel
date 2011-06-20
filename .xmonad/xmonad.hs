import XMonad
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Run(spawnPipe)

main = do 
  xmonad $ defaultConfig {
    modMask = mod4Mask,
    terminal = "urxvt"
    } `additionalKeys` [
    ((mod4Mask .|. shiftMask, xK_e), spawn "emacsclient -c"),
    ((mod4Mask .|. shiftMask, xK_f), spawn "firefox"),
    ((mod4Mask .|. shiftMask, xK_k), spawn "conkeror"),
    ((mod4Mask .|. shiftMask, xK_o), spawn "urxvt -e offlineimap"),
    ((mod4Mask .|. shiftMask, xK_v), spawn "vlc"),
    ((mod4Mask .|. shiftMask, xK_w), spawn "wicd-client -n"),
    ((mod4Mask .|. shiftMask, xK_z), spawn "xlock"),
    ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s"),
    ((0, xK_Print), spawn "scrot")
    ]
