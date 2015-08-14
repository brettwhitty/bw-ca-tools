#!/bin/bash

##
## Prepare test datasets for CA SLURM support patch.
##
## Brett Whitty <brett@gnomatix.com>
##
## See Celera Assembler wiki page here:
##   http://wgs-assembler.sourceforge.net/wiki/index.php/Escherichia_coli_K12_MG1655,_using_uncorrected_PacBio_reads,_with_CA8.2
##

## Download a set of PacBio fastq files from the wgs-assembler sourceforge site 
curl -L -o escherichia_coli_k12_mg1655.m130404_014004_sidney_c100506902550000001823076808221337_s1_p0.1.fastq.xz http://sourceforge.net/projects/wgs-assembler/files/wgs-assembler/wgs-8.0/datasets/escherichia_coli_k12_mg1655.m130404_014004_sidney_c100506902550000001823076808221337_s1_p0.1.fastq.xz/download

curl -L -o escherichia_coli_k12_mg1655.m130404_014004_sidney_c100506902550000001823076808221337_s1_p0.2.fastq.xz http://sourceforge.net/projects/wgs-assembler/files/wgs-assembler/wgs-8.0/datasets/escherichia_coli_k12_mg1655.m130404_014004_sidney_c100506902550000001823076808221337_s1_p0.2.fastq.xz/download

curl -L -o escherichia_coli_k12_mg1655.m130404_014004_sidney_c100506902550000001823076808221337_s1_p0.3.fastq.xz http://sourceforge.net/projects/wgs-assembler/files/wgs-assembler/wgs-8.0/datasets/escherichia_coli_k12_mg1655.m130404_014004_sidney_c100506902550000001823076808221337_s1_p0.3.fastq.xz/download

## CA bin dir needs to be in your path

## create .frg file
fastqToCA   -libraryname ecoli   -technology pacbio-raw   -reads *1.fastq.xz   -reads *2.fastq.xz   -reads *3.fastq.xz > ecoli-untrimmed.frg

## making some working directories for step 2
mkdir ecoli-trim
