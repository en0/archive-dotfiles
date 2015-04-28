#!/usr/bin/env python3
__author__ = 'en0'

""" A basic mixer bar. """

import alsaaudio
from PyQt4 import QtGui, QtCore
from sys import argv
import ctypes
from threading import Timer
import socket
from argparse import ArgumentParser, REMAINDER
from os import fork, getpid, kill
from signal import SIGTERM, SIGINT, signal
import pickle


class MixerControl:
    def __init__(self, control='Master', id=0, cardindex=0):
        self._mixer = alsaaudio.Mixer(control=control, id=id, cardindex=cardindex)

    @property
    def level(self):
        _t = self._mixer.getvolume()
        return int(sum(self._mixer.getvolume()) / len(_t))

    @level.setter
    def level(self, value):
        try:
            value = 100 if value > 100 else value
            value = 0 if value < 0 else value
            self._mixer.setvolume(value)
        except alsaaudio.ALSAAudioError:
            pass

    @property
    def mute(self):
        return sum(self._mixer.getmute()) == 1

    @mute.setter
    def mute(self, value):
        self._mixer.setmute(1 if value else 0)

    def set_relative_level(self, offset):
        self.level = self.level + offset

    def toggle_mute(self):
        self.mute = not self.mute


class VolumeUI(QtGui.QDialog):
    def __init__(self, parent=None):
        super(VolumeUI, self).__init__(parent)

        self.mixer = MixerControl(cardindex=1)

        self.ctrl = ControlSocket()
        self.ctrl.volume_set.connect(self.on_data_ready)

        self.setWindowTitle("Volume")
        self.setWindowFlags(self.windowFlags() | QtCore.Qt.FramelessWindowHint | QtCore.Qt.WindowStaysOnTopHint)
        self.setAttribute(QtCore.Qt.WA_X11DoNotAcceptFocus)
        self.setFocusPolicy(QtCore.Qt.NoFocus)
        self.resize(300, 40)
        self.layout = QtGui.QVBoxLayout()
        self.bar = QtGui.QProgressBar(self)
        self.bar.setFocusPolicy(QtCore.Qt.NoFocus)
        self.layout.addWidget(self.bar)
        self.setLayout(self.layout)
        self.ctrl.start()
        self.hide_timer = None

    def on_data_ready(self, data):

        def my_hide():
            self.hide()

        if self.hide_timer:
            self.hide_timer.cancel()

        self.hide_timer = Timer(2.0, my_hide)
        self.hide_timer.start()

        if data['mute'] == 0:  # Un-Mute
            self.mixer.mute = False
        elif data['mute'] == 1:  # Mute
            self.mixer.mute = True
        elif data['mute'] == 2:  # Toggle
            self.mixer.toggle_mute()

        self.mixer.set_relative_level(data['adjust'])
        self.bar.setDisabled(self.mixer.mute)
        self.bar.setValue(self.mixer.level)
        self.show()


class ControlSocket(QtCore.QThread):
    volume_set = QtCore.pyqtSignal(object)
    toggle_mute = QtCore.pyqtSignal(object)

    def run(self):
        _socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        _socket.bind(("127.0.0.1", 8899))
        while True:
            buff, _ = _socket.recvfrom(512)
            if len(buff) > 0:
                self.volume_set.emit(pickle.loads(buff))


def daemon_main(daemon_args):
    _parser = ArgumentParser("start and stop the background daemon.")
    _parser.add_argument("--no-fork", action='store_true', default=False, help='Run daemon in foreground')
    _parser.add_argument("--pid-file", type=str, help="The location of the PID file.")
    _parser.add_argument("action", choices=['start', 'stop'], help='Start or Stop the daemon')

    _args = _parser.parse_args(daemon_args)

    if _args.action == 'start':
        with open(_args.pid_file, 'w') as fid:
            if not _args.no_fork:
                pid = fork()
                if pid != 0:
                    fid.write(str(pid))
                    exit(0)
            else:

                pid = getpid()
                fid.write(str(pid))

                def signal_handler(sig, bt):
                    _ = sig
                    _ = bt
                    kill(pid, SIGTERM)

                signal(SIGINT, signal_handler)

        # This libX11.so is imported to fixes a multi-threading issue.
        # If you are trying to port this code, you should be safe to remove it.
        # Check the documentation for your platform.
        x11 = ctypes.cdll.LoadLibrary('libX11.so')
        x11.XInitThreads()

        app = QtGui.QApplication(argv)
        _ = VolumeUI()
        exit(app.exec())

    else:
        with open(_args.pid_file, 'r') as fid:
            try:
                pid = int(fid.read())
                kill(pid, SIGTERM)
            except ValueError:
                exit(1)


def mixer_main(mixer_args):
    mute_value = {
        "on": 1,
        "off": 0,
        "toggle": 2,
        None: -1
    }
    _parser = ArgumentParser("Send command to volume daemon")
    _parser.add_argument("--adjust", default=0, type=int, help='The value to adjust the volume by.')
    _parser.add_argument("--mute", choices=mute_value, default=None, help="Set the mute state, (on, off, toggle)")
    _args = _parser.parse_args(mixer_args)

    buff = pickle.dumps({
        'adjust': _args.adjust,
        'mute': mute_value[_args.mute]
    })

    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.sendto(buff, ('127.0.0.1', 8899))


if __name__ == '__main__':
    sub_commands = {
        'daemon': daemon_main,
        'mixer': mixer_main
    }

    parser = ArgumentParser("Simple X11 Volume Tool")
    parser.add_argument("command", choices=sub_commands, help="Specify a sub command.")
    parser.add_argument("args", nargs=REMAINDER)
    args = parser.parse_args(argv[1:])
    sub_commands[args.command](args.args)
