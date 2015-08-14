#!/bin/bash

##
## This script has been tested to work when run on SLURM cluster as follows:
##
##    sbatch /path/to/script.sh 
##

if [ ! -x "runCA" ]; then
	
	echo "Celera Assembler 'runCA' is not in your path; modify 'PATH' in this script."
	
	# export PATH="/PATH/TO/wgs-8.3rc2/Linux-amd64/bin:$PATH"

	exit 1
fi

runCA -p ecoli-trim -d ecoli-trim -s ecoli-trim.spec ecoli-untrimmed.frg
