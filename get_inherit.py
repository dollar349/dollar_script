#!/usr/bin/python3
import os
from pathlib import Path
import sys

cnt=len(sys.argv)

if cnt != 2:
    exit(-1)

for path in Path(os.getcwd()).rglob(sys.argv[1]):
    print(path.absolute())

"""
fp = open('filename.txt', "r")
for line in iter(fp):
    print line
fp.close()
"""


#for path in Path(os.getcwd()).rglob('*.bbappend'):
#    print(path.name)
