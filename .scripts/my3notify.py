"""
This is a plugin for weechat that sends message notifications through
notify-send.
"""

import weechat as w import subprocess as s


SCRIPT_NAME    = "my3notify"
SCRIPT_AUTHOR  = "Ian Laird <irlaird@gmail.com>"
SCRIPT_VERSION = "1.0"
SCRIPT_LICENSE = "GPL3"
SCRIPT_DESC    = "Send notifications to libnotify using notify-send"

ICON_PATH = '/usr/share/icons/hicolor/32x32/apps/weechat.png'

w.register(SCRIPT_NAME, SCRIPT_AUTHOR, SCRIPT_VERSION, SCRIPT_LICENSE, SCRIPT_DESC, "", "")

def on_msg(*a):

    try:
        data, bfr, timestamp, tags, displayed, highlight, sender, message = a
        arg_keys = ('DATA','BFR','TIMESTAMP','TAGS','DISPLAYED','HIGHLIGHT','SENDER','MESSAGE')

        args = dict(zip(arg_keys, a))

        if data == 'private':
            title = "{SENDER} (Private Message):"
            message = "{MESSAGE}"
        elif highlight == '1':
            title = "{SENDER} (Highlight Message):"
            message = "{MESSAGE}"
        else:
            return w.WEECHAT_RC_OK
            #title = "WeeChat - {SENDER} says:"
            #message = "{MESSAGE}"


        s.call(["notify-send", '-c', 'irc', '-i', ICON_PATH, title.format(**args), message.format(**args)])

    except Exception as e:
        w.prnt("{0}".format(e))

    return w.WEECHAT_RC_OK


w.hook_print("", "notify_message", "", 1, "on_msg", "")
w.hook_print("", "notify_private", "", 1, "on_msg", "private")
w.hook_print("", "notify_highlight", "", 1, "on_msg", "highlight") # Not sure if this is needed
