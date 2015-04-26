#!/bin/env python3

""" Get an excuse for the my project manager. """

from html.parser import HTMLParser
from urllib import request


class ExcuseParser(HTMLParser):
    def __init__(self):
        super(ExcuseParser, self).__init__()
        self._content = None
        self._title = None
        self.Data = {}

    def _findData(self, line, offset):
        for key in sorted([k for k in self.Data[line] if k > offset]):
            return self.Data[line][key]

    def getExcuse(self):
        line, offset = self._content
        return self._findData(line, offset)

    def getTitle(self):
        line, offset = self._title
        return self._findData(line, offset)

    def handle_starttag(self, tag, attrs):
        if tag == 'a':
            self._content = self.getpos()
        elif tag == 'title':
            self._title = self.getpos()

    def handle_data(self, data):
        line, offset = self.getpos()
        content = self.Data.get(line, {})
        content[offset] = data
        self.Data[line] = content

parser = ExcuseParser()
with request.urlopen('http://programmingexcuses.com/') as web_fid:
    line = True
    while line:
        line = web_fid.readline()
        parser.feed(line.decode('ascii'))

# print(": ".join([parser.getTitle(), parser.getExcuse()]))
print(parser.getExcuse())
