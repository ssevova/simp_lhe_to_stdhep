# simp_lhe_to_stdhep
## Package to take input SIMP LHEs, swap the PGD ID=622 and 625 particles, in order to displace the dark rho, then covert to stdhep format.

You can use this tool to convert a single LHE to STDHEP by calling:
```
python runConvertAll.py -i <input LHE file> -o <output STDHEP file> -ct <ctau>
```

Or this tool can be used to convert all `.lhe.gz` files contained in a directory to STDHEP by calling:
```
python runConvertAll.py -d <directory with zipped lhe files> -ct <ctau>
```
