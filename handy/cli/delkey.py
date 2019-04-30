import sys

from handy.json.handler import load,save
from handy.dict.mixedict import delkey,rmempty,isin

msg_no_output = "When outpath not indicated, it will use inputpath as default.\n\
                 Please Type y/n/p(Yes/No/Outpath):\n"
msg_not_found = "file doesn't exist or wrong file."
msg_help = "Written by junying, 2019-04-29 \
            \nUsage: delkey [key] [inpath] [outpath]"
def main():
    if len(sys.argv) < 3: print(msg_help); return
    elif len(sys.argv) == 3:
        answer = raw_input(msg_no_output) if sys.version_info[0] == 2 else input(msg_no_output)
        if 'y' in answer: outpath=sys.argv[2]
        elif 'n' in answer: return
        else: outpath = answer
    else:
        outpath = sys.argv[3]
    indata = load(sys.argv[2]); key = sys.argv[1]
    if not indata: print(msg_not_found); return
    delkey(indata,key); rmempty(indata); save(indata,outpath)
    
