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

atoms = list(set(atoms))
kw_op_sep = ['if', 'else', 'while', 'cout', '>>', 'int', '<<', '#', ')', '(', '+', 'namespace', ';', 'main', '=', '<', '>', 'iostream', 'void', 'using', 'endl', 'std', 'include', 'cin', '{', '}', '*', '-', '!=', 'char', 'circle', '.']

def string_to_int(string):
    total = 0

    for char in string:
        total += ord(char)

    return total

def nones(n):
    l = []
    for _ in range(n):
        l.append(None)
    return l

m = 101

def d1(c):
    return c%m

def d2(c):
    return 1+c%(m-1)

def d(c,i):
    return (d1(c)+i*d2(c))%m

TS = nones(m)

try:
    print("FIP:")
    i=0
    while i<len(file):
        fit_atom = ''
        atom_index = -1
        for index, atom in enumerate(atoms):
            if file[i:i+len(atom)] == atom and len(atom)>len(fit_atom):
                fit_atom = atom
                atom_index = index
        if atom_index != -1:
            if fit_atom not in kw_op_sep: # ID sau CONST
                if fit_atom[0].isdigit(): # CONST
                    value = int(fit_atom)
                    j = 0
                    while TS[d(value,j)] is not None and TS[d(value,j)] != fit_atom:
                        j += 1
                    TS[d(value,j)] = fit_atom
                    print(str(0)+" CONST "+str(d(value,j)))
                else: # ID
                    if len(fit_atom) > 8:
                        raise Exception(fit_atom+" is longer than 8 characters")
                    value = string_to_int(fit_atom)
                    j = 0
                    while TS[d(value,j)] is not None and TS[d(value,j)] != fit_atom:
                        j += 1
                    TS[d(value,j)] = fit_atom
                    print(str(1)+" ID "+str(d(value,j)))
            else:
                print(str(atom_index+2)+" "+fit_atom) # +2 ,0 si 1 rezervat pentru CONST respectiv ID
            i += len(fit_atom)
        else:
            i += 1
finally:    
    print("")
    print("TS:")
    for index, symbol in enumerate(TS):
        if symbol is not None:
            print(str(index)+" "+symbol)
