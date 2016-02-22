#!/usr/bin/env python
import requests
import re

def get_excuse():
    search = re.compile("<a *[^>]*>(.*?)</a *>")
    resp = requests.get("http://programmingexcuses.com/")
    tag = search.findall(resp.text)
    return tag[-1]


if __name__ == "__main__":
    print get_excuse()
