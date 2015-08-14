##
## Test job spec for Celera Assembler 'runCA.pl' SLURM support patch.
## Brett Whitty <brett@gnomatix.com>
## 
## Grabbed from: 
##   http://wgs-assembler.sourceforge.net/wiki/index.php/Escherichia_coli_K12_MG1655,_using_uncorrected_PacBio_reads,_with_CA8.2
## 
## Original authors of these data are credited with all sequence data and pipeline settings.
## Please see URL above for more information.
##

## vvv SLURM grid-enabling options vvv
useGrid               = 1
scriptOnGrid          = 1  ## default in runCA is 0, but seems to work; disable if you wish
gridEngine            = SLURM
## ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

merSize               = 19
merThreshold          = 0
merDistinct           = 0.9995
merTotal              = 0.995

doOBT                 = 0
doExtendClearRanges   = 0

unitigger             = bogart

ovlErrorRate          = 0.35  #  Compute overlaps up to 35% error
utgGraphErrorRate     = 0.35  #  Unitigs at 35% error
utgMergeErrorRate     = 0.35  #  Unitigs at 35% error
cnsErrorRate          = 0.35  #  Needed to allow ovlErrorRate=0.35
cgwErrorRate          = 0.35  #  Needed to allow ovlErrorRate=0.35

ovlConcurrency        = 16
cnsConcurrency        = 16

ovlThreads            = 1
ovlHashBits           = 22
ovlHashBlockLength    = 10000000
ovlRefBlockSize       = 25000

#cnsReduceUnitigs      = 0 0   #  Always use only uncontained reads for consensus
cnsReuseUnitigs       = 1     #  With no mates, no need to redo consensus

cnsMinFrags           = 1000
cnsPartitions         = 256

cnsMaxCoverage        = 10    #  Limit consensus calling to 10x
