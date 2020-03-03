import os
import sys
import re
import json
from argparse import ArgumentParser

def getFiles(directory):
    """Get files in directory as list recursively."""
        # os.listdir only for locally downloaded files
    _files=[]
    for item in os.listdir(directory):
        path = os.path.join(directory, item)
        if not os.path.isdir(path) and ".lhe.gz" in path:
            _files.append(path)
        elif os.path.isdir(path):
            getFiles(path)
    return _files

def getArgs():
    """Get arguments from command line."""
    parser = ArgumentParser()
    parser.add_argument(
        '-i', '--inlhe', default='in.lhe', help="Name of the input LHE file.")
    parser.add_argument(
        '-d', '--indir', default='', help="Directory containing multiple LHE files to be displaced & converted to STDHEP")
    parser.add_argument(
        '-o', '--outstdhep', default='out.stdhep', help="Name of the output STDHEP file.")
    parser.add_argument(
        '-ct','--ctau', default='10', help="Value used to displace dark rho.")
    return parser

def main():
    args = getArgs().parse_args()

    filelist=getFiles(args.indir)
#    print(filelist)
    
    for infile in filelist:
        print("In-file: %s" %infile)
        os.system('cp '+infile+' .')
        lhe_file=infile.split('/')[-1]
        os.system('gunzip '+lhe_file)
        _lhe_file='%s.%s' %(lhe_file.split('.')[0],lhe_file.split('.')[1])

        print("Input lhe file: %s" %_lhe_file)
        os.system('mv '+ _lhe_file + ' in.lhe')
        out_stdhep='%s.%s'%(_lhe_file.split('.')[0],'stdhep')
        
        fin  = open("hadwrt_template.f", "rt")
        fout = open("hadwrt_test.f", "wt")

        checkWords = ("XXX_INFILE_XXX","XXX_OUTFILE_XXX", "XXX_CTAU_XXX")    
        repWords = ('in.lhe','out.stdhep',args.ctau)

        for line in fin:
            for check, rep in zip(checkWords, repWords):
                line=line.replace(check,rep)
            fout.write(line)
        fin.close()
        fout.close()

        os.system('make')
        os.system('./hadwrt_test')
        print("Copy out.stdhep to %s" %out_stdhep)
        os.system('cp out.stdhep ' + out_stdhep)
        
if __name__ == '__main__':
    main()
