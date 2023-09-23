#
# @author mozcelikors
#

import json
import sys
import os

path = os.environ["BETTERGALLERYDIR"]

file1 = open(path+'/out/ids.txt', 'r')
ids = file1.readlines()
names = ids

i = 0
# Strips the newline character
for line in ids:
    ids[i] = line.strip()
    i = i+1

#print(ids)

y = json.load(sys.stdin)
z = y["applist"].get("apps")
#print(z[0]["appid"])
#print(z[0]["name"])

i = 0
for idx in ids:
    names[i] = "Non-steam Game"
    res = None
    for sub in z:
        if sub['appid'] == int(idx):
            res = sub
            break
    try:
        print (res['name'])
        names[i] = res['name']
    except:
        err=1
    i = i+1

file2 = open(path+'/out/names.txt', 'a')
k=0
for line in names:
    if (k<i-1):
        file2.write(line+'\n')
    else:
        file2.write(line)
    k = k + 1

file1.close();
file2.close();

