#!/bin/env python

""" Find duplicate files in a directory. """


import sys
import argparse
import os
import hashlib


def getHashAlgorithyms():
    """ Gets a list of hashlib constructures that can be
        used to generate the digest of a file.
    """

    return {
        "md5": hashlib.md5,
        "sha1": hashlib.sha1,
        "sha224": hashlib.sha224,
        "sha256": hashlib.sha256,
        "sha384": hashlib.sha384,
        "sha512": hashlib.sha512
    }


def main(argv):
    """Generate a list of files and find duplicates

    ARGS:
        argv - Application Arguments. try '-h' for details

    RETURNS:
        None
    """

    algorithyms = getHashAlgorithyms()

    parser = argparse.ArgumentParser(description="Locate duplicate files")
    parser.add_argument("-m", default="md5",
                        choices=algorithyms,
                        help="Specify what hashing algorithym t use")
    parser.add_argument("DIR", default=".",
                        nargs="*",
                        help="A list of directories to check.")
    args = parser.parse_args(argv)

    genFiles = getFiles(args.DIR)
    dups = findDups(genFiles, algorithyms[args.m])

    for key in dups:
        print("## Duplication Set {}".format(key))
        for _file in dups[key]:
            print(_file)
        print('')


def findDups(files, algorithym):
    """Find duplicate files from a list of files

    ARGS:
        files - A enumerable of file paths to search for duplicates
        algorithym - The hashing function used to identify duplicates

    RETURNS:
        A list of all files that are identified as duplicates.
    """

    seen = set()
    dups = set()
    digestPath = {}

    for filePath in files:
        digest = hashFile(filePath, algorithym)
        if digest in seen:
            dups.add(digest)
        else:
            seen.add(digest)
            digestPath[digest] = []
        digestPath[digest].append(filePath)

    return {k: digestPath[k] for k in dups}


def hashFile(filePath, algorithym):
    """Generate the digest of a file using the specified hash algorythm

    ARGS:
        filePath - The path to the file to hash
        algorithym - The libash constructure used to hash the file

    RETURNS:
        A all hex representation of the files digest.
    """

    hasher = algorithym()

    with open(filePath, 'rb') as fid:
        for line in fid:
            hasher.update(line)

    return hasher.hexdigest()


def getFiles(dirs):
    for _topDir in dirs:
        for _dir, _, _files in os.walk(_topDir):
            for _file in _files:
                yield "{}{}{}".format(_dir, os.sep, _file)

if __name__ == "__main__":
    main(sys.argv[1:])
