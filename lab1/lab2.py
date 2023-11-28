import re
import sys

atoms = []

with open(sys.argv[1],'r') as f:
	file = f.read()

res , count = re.subn(r">>"," ",file)	
if count>0:
	atoms.append(">>")

res , count = re.subn(r"<<"," ",res)
if count>0:
	atoms.append("<<")

res , count = re.subn(r"!="," ",res)
if count>0:
    atoms.append("!=")

regex = r"[^a-zA-Z0-9\s]"
chars = re.findall(regex, res)
atoms += chars
res = re.sub(regex," ",res)

lines = res.splitlines()
for line in lines:
	words = line.split()
	atoms += words

atoms = set(atoms)
print(atoms)
