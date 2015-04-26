#!/usr/bin/env python

"""
This script is intended to listen for notifications from my virtual
machines. I needed process isolation and din't want to use the builtin methods
to do this.
"""

from gi.repository import Notify
import msgpack
import signal
import threading
import queue
import socket

q = queue.Queue()
Notify.init("speakup")
isRunning = True
PORT = 4321


def sendNotify(title, message, urgency):
    if urgency == 0:
        u = Notify.Urgency.LOW
    elif urgency == 3:
        u = Notify.Urgency.CRITICAL
    else:
        u = Notify.Urgency.NORMAL

    m = Notify.Notification.new(title, message, None)
    m.set_urgency(u)
    m.show()


def consumer():
    while(isRunning or not q.empty()):
        try:
            m = q.get(True, 10)
            sendNotify(
                m[b'title'].decode(),
                m[b'message'].decode(),
                m[b'urgency'],
            )
        except queue.Empty:
            pass


def producer(c):
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.bind(("", PORT))
    while(isRunning):
        data, addr = s.recvfrom(1024)
        q.put(msgpack.unpackb(data))
    c.join()


def sig_handler(signum, frame):
    print("Shutting Down (10 seconds)...")
    global isRunning
    isRunning = False

if __name__ == "__main__":
    signal.signal(signal.SIGINT, sig_handler)
    consumer = threading.Thread(target=consumer)
    consumer.start()
    producer(consumer)
