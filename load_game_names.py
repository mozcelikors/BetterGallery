#
# @author mozcelikors
#

import json
import sys
import os

path = os.environ["BETTERGALLERYDIR"]
NON_STEAM = "Non-steam Game"

file1 = open(path+'/out/ids.txt', 'r')
ids = file1.readlines()
file1.close();
file1= open(path+'/out/ids.txt', 'r')
ids_original=file1.readlines()
file1.close();
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
# Strips the newline character
for line in ids_original:
    ids_original[i] = line.strip()
    i = i+1

i = 0
for idx in ids:
    names[i] = NON_STEAM
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
    if (k<len(names)-2):
        file2.write(line+'\n')
    else:
        file2.write(line)
    k = k + 1

# Sort to make sure Non-steam games are last
file3 = open(path+'/out/names_sorted.txt', 'a')
file4 = open(path+'/out/ids_sorted.txt', 'a')

print(ids_original)
print(names)

j=0
for name in names:
    if (name != NON_STEAM):
            file3.write(name+'\n');
            file4.write(ids_original[j]+'\n');
    j = j + 1

j=0
for name in names:
    if (name == NON_STEAM):
        if (j<len(ids_original)-2):
            file3.write(name+'\n');
            file4.write(ids_original[j]+'\n');
        else:
            file3.write(name);
            file4.write(ids_original[j]);
    j = j + 1

file2.close();
file3.close();
file4.close();

