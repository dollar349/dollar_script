#!/usr/bin/python3
import os
from pathlib import Path
import sys

cnt=len(sys.argv)
Fileanme_list=[]

if cnt != 2:
    exit(-1)

for path in Path(os.getcwd()).rglob(sys.argv[1]):
    Fileanme_list.append(path.absolute())

for Fileanme in Fileanme_list:
        print (Fileanme)
        fp = open(Fileanme, "r")
        for line in iter(fp):
            print (line)
        fp.close()

"""
fp = open('filename.txt', "r")
for line in iter(fp):
    print (line)
fp.close()
"""


#for path in Path(os.getcwd()).rglob('*.bbappend'):
#    print(path.name)
