#!/usr/bin/env python2

import urllib2
import feedparser
import subprocess
from os import remove
from time import sleep

FEED_URL  = 'https://mail.google.com/mail/feed/atom'
ICON_PATH = '/home/en0/.scripts/res/Gmail-icon.png'
MSG_FMT = u'FROM: {author}\nSUBJECT: {title}'
TITLE_FMT = u'{INDEX} of {new} New Email(s)'
UNREAD_FLAG = '/home/en0/.scripts/res/UNREAD.lock'
DELAY = 60*3 ## Every 10 min

seen_email = set()

def build_auth_handler(user, passwd):
    auth_handler = urllib2.HTTPBasicAuthHandler()
    auth_handler.add_password(
        realm='New mail feed',
        uri='https://mail.google.com',
        user='{user}@gmail.com'.format(user=user),
        passwd=passwd)
    return auth_handler

def get_atom(auth):
    opener = urllib2.build_opener(auth)
    urllib2.install_opener(opener)
    feed = urllib2.urlopen(FEED_URL)
    return feed.read()


def get_mail(auth):

    ret = []

    xml = get_atom(auth)

    d = feedparser.parse(xml)
    unread = d['entries']

    for mail in unread:
        _id = mail['id']
        if _id not in seen_email:
            seen_email.add(_id)
            ret.append(mail)

    return {
        'unread' : len(unread),
        'unread_mail' : unread,
        'new' : len(ret),
        'new_mail' : ret,
    }


def notify_new_email(details):
    i = 0
    for email in details['new_mail']:
        i += 1
        title = TITLE_FMT.format(INDEX=i, **details)
        body = MSG_FMT.format(**email)
        subprocess.call([
            'notify-send',
            '-t', '1000',
            '-i', ICON_PATH,
            title.encode('ascii','ignore'),
            body.encode('ascii','ignore'),
        ])


def set_unread_flag(details):
    if details['unread'] > 0:
        with open(UNREAD_FLAG, 'w') as fd:
            fd.write("NEW: {0}\n".format(details['new']))
            fd.write("UNREAD: {0}\n".format(details['unread']))
    else:
        try: remove(UNREAD_FLAG)
        except OSError: pass


def check(auth):
    details = get_mail(auth)
    notify_new_email(details)
    set_unread_flag(details)


if __name__ == '__main__':

    print "You need to configure username and password"
    exit(1)

    auth = build_auth_handler('user','pass')

    while True:
        check(auth)
        sleep(DELAY)



