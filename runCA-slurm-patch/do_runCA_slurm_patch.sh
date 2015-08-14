#!/bin/bash

##
## Patches Celera Assembler 8.3'runCA.pl' to add 'SLURM' grid resource manager support
##
## Brett Whitty
## brett@gnomatix.com
##

## This script will take care of everything, provided you have 'curl' installed

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CLEAR='\033[0m'

## Grab the 'latest' Celera Assembler code from Sourceforge

## this will redirect to the latest
LATEST_URL="http://sourceforge.net/projects/wgs-assembler/files/latest/download?source=files"

## for convenience
LATEST_NAME="wgs-latest.tar.bz2" 

## working directory
WORKING_DIR=`readlink -f $(dirname $0)`

## will use curl for the download
CURL_BIN=`which curl`

if [ "${CURL_BIN}" = "" ]; then
    printf "${RED}This script requires that you have 'curl' available in your path.${CLEAR}\n"
    exit 1
fi

printf "${YELLOW}This script will download the latest version of Celera Assembler\nand patch 'runCA.pl' to add support for 'SLURM'.${CLEAR}\n"
read -p "Is this OK? [Y/n]: " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Nn]$ ]]; then
    printf "${RED}Aborting script...${CLEAR}\n"
    exit 1
fi

printf "${YELLOW}Downloading 'latest' version of Celera Assembler from Sourceforge...${CLEAR}\n"

${CURL_BIN} -L ${LATEST_URL} -o ${LATEST_NAME}

## could trap errors, but too lazy
if [ $? -eq 0 ]; then
    printf "${GREEN}Download seems OK.${CLEAR}\n"
else
    echo "${RED}There was some error running 'curl'.${CLEAR}\n"
    exit 1
fi

printf "${YELLOW}Extracting archive...${CLEAR}\n"

tar xjf ${LATEST_NAME}

## see above
if [ $? -eq 0 ]; then
    printf "${GREEN}Archive extraction seems OK.${CLEAR}\n"
else 
    echo "${RED}There was an error extracting the archive.${CLEAR}\n"
    exit 1
fi

printf "${YELLOW}Looking for 'runCA.pl' script under working dir...${CLEAR}\n"

## should find one script that matches under working dir
SCRIPT_COUNT=`find ${WORKING_DIR} -name "runCA.pl" | wc -l`

if [ "${SCRIPT_COUNT}" -eq "1" ]; then

    printf "${YELLOW}Found 'runCA.pl' and will now patch...${CLEAR}\n"

    ## use the path from find
    RUNCA=`find ${WORKING_DIR} -name "runCA.pl"`

    ## apply the patch
    patch ${RUNCA} << "SLURM_PATCH"
--- ./wgs-8.3rc2/src/AS_RUN/runCA.pl	2015-05-20 17:28:27.000000000 -0400
+++ runCA-with-slurm	2015-08-14 11:04:12.000000000 -0400
@@ -307,6 +307,26 @@
         setGlobal("gridEngineJobID",              "LSB_JOBID");
     }
 
+    ### BEGIN ___ Brett Whitty <brett@gnomatix.com> SLURM support patch - block 1/2 ___
+    if (($var eq "gridEngine") && ($val eq "SLURM")) {
+        setGlobal("gridEngineSubmitCommand",      "sbatch");                                        
+        setGlobal("gridEngineHoldOption",         "--depend=afterany:\"WAIT_TAG\"");                
+        setGlobal("gridEngineHoldOptionNoArray",  "--depend=afterany:\"WAIT_TAG\"");                
+        setGlobal("gridEngineSyncOption",         "");                                          ## TODO: SLURM may not support w/out wrapper; See LSF bsub manpage to compare
+        setGlobal("gridEngineNameOption",         "-D `pwd` -J");                                   
+        setGlobal("gridEngineArrayOption",        "-a ARRAY_JOBS");                                 
+        setGlobal("gridEngineArrayName",          "ARRAY_NAME\[ARRAY_JOBS\]");                      
+        setGlobal("gridEngineOutputOption",       "-o");                                        ## NB: SLURM default joins STDERR & STDOUT if no -e specified
+        setGlobal("gridEnginePropagateCommand",   "scontrol update job=\"WAIT_TAG\"");          ## TODO: manually verify this in all cases
+        setGlobal("gridEngineNameToJobIDCommand", "squeue -h -o\%F_* -n \"WAIT_TAG\" | uniq");  ## TODO: manually verify this in all cases
+        setGlobal("gridEngineNameToJobIDCommandNoArray", "squeue -h -o\%i -n \"WAIT_TAG\"");    ## TODO: manually verify this in all cases
+        setGlobal("gridEngineTaskID",             "SLURM_ARRAY_TASK_ID");                         
+        setGlobal("gridEngineArraySubmitID",      "%A_%a");                                     
+        setGlobal("gridEngineJobID",              "SLURM_JOB_ID");                               
+    }
+    ### END ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+
     #  Update obsolete usage.
 
     if ($var eq "doOverlapTrimming") {
@@ -1526,7 +1546,9 @@
 
     if (defined($waitTag)) {
         my $hold = $holdOption;
-        if (getGlobal("gridEngine") eq "LSF" || getGlobal("gridEngine") eq "PBS"){
+    ### BEGIN ___ Brett Whitty <brett@gnomatix.com> SLURM support patch - block 2/2 ___
+        if (getGlobal("gridEngine") eq "LSF" || getGlobal("gridEngine") eq "PBS" || getGlobal("gridEngine") eq "SLURM"){
+    ### END ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
            my $tcmd = getGlobal("gridEngineNameToJobIDCommand");
            $tcmd =~ s/WAIT_TAG/$waitTag/g;
            my $propJobCount = `$tcmd |wc -l`;
SLURM_PATCH

fi

## final lazy check
if [ $? -eq 0 ]; then
    printf "${GREEN}Patching seems OK.${CLEAR}\n\n"
    printf "${YELLOW}The patched Celera Assembler 'runCA[.pl]' script now supports option 'gridEngine = SLURM'${CLEAR}.\n\n"
    printf "For more details, see:\n${GREEN}https://github.com/brettwhitty/bw-ca-tools/runCA-slurm-patch/README.md${CLEAR}\n\n"
    printf "${YELLOW}You can now either build and install Celera Assembler from the source code in the working directory,\n"
    printf "or copy 'runCA.pl' over top of 'runCA' in your existing CA install 'bin' dir.${CLEAR}\n\n"
    printf "Patched script is here:\n${GREEN}${RUNCA}\n${CLEAR}\n"
    exit 0
else 
    printf "${RED}Patching appears to have failed.${CLEAR}\n"
    exit 1
fi
