import sys

class AF:
    def __init__(self,n_states,alphabet,start_state,transitions):
        self.n = n_states
        self.alphabet = alphabet
        self.start_state = start_state
        self.transitions = transitions

    def print_states(self):
        string_states = ''
        for i in range(self.n):
            string_states += 'q'+str(i)+' '
        print(string_states)

    def check_seq(self,seq):
        state = self.start_state
        for letter in seq:
            state = self.transitions[state][alphabet_dict[letter]]
            if state == -1 :
                return False
        if self.transitions[state][len(alphabet)]==1:
            return True
        else:
            return False

    def longest_prefix(self,seq):
        prefix = ''
        for i in range(len(seq)+1):
            if self.check_seq(seq[:i]):
                prefix = seq[:i]
        print("cel mai lung prefix acceptat:",prefix)

ND = False

if len(sys.argv) < 2:
    print("Taking keyboard input")
    n = int(input("n="))
    alphabet = input("alphabet=").strip().split()
    alphabet_dict = {}
    for index,letter in enumerate(alphabet):
        alphabet_dict[letter]=index
    start_state = int(input("starea initiala="))
    Q = []
    for i in range(n):
        # Q.append(list(map(int,input(f"q{i}=").strip().split())))
        line = input(f"q{i}=").strip().split()
        transitions=[]
        for element in line:
            if ',' in element:
                ND = True
                transitions.append(list(map(int,element.split(sep=','))))
            else:
                transitions.append(int(element))
        Q.append(transitions)
    
else:
    file_name = sys.argv[1]
    print("Reading from file",file_name)
    with open(file_name) as f:
        n = int(f.readline().strip())
        alphabet = f.readline().strip().split()
        alphabet_dict = {}
        for index,letter in enumerate(alphabet):
            alphabet_dict[letter]=index
        start_state = int(f.readline().strip())
        Q = []
        for i in range(n):
            # Q.append(list(map(int,f.readline().strip().split())))
            line = f.readline().strip().split()
            transitions=[]
            for element in line:
                if ',' in element:
                    ND = True
                    transitions.append(list(map(int,element.split(sep=','))))
                else:
                    transitions.append(int(element))
            Q.append(transitions)

final_states = [i for i,_ in enumerate(Q) if Q[i][len(alphabet)]==1]

af =  AF(n,alphabet,start_state,Q)

menu = "Menu:\n0 - exit\n1 - multimea starilor\n2 - alfabetul\n3 - tranzitiile\n4 - multimea starilor finale"
if not ND:
    menu += "\n5 - verifica secventa\n6 - cel mai lung prefix"
else:
    print("Automatul este nedeterminist, verificarea secventelor este dezactivata")
print(menu)

while True:
    choice = int(input(">>> "))
    if choice == 0:
        break
    if choice == 1:
        af.print_states()
    if choice == 2:
        print(af.alphabet)
    if choice == 3:
        for i,q in enumerate(af.transitions):
            print(f"q{i} ",q[:len(alphabet)])
    if choice == 4:
        string_states = ''
        for final_state in final_states:
            string_states += 'q'+str(final_state)+' '
        print(string_states)
    if choice == 5 and not ND:
        seq = input("secventa:").strip()
        if af.check_seq(seq):
            print("secventa acceptata!")
        else:
            print("secventa neacceptata!")
    if choice == 6 and not ND:
        seq = input("secventa:").strip()
        af.longest_prefix(seq)