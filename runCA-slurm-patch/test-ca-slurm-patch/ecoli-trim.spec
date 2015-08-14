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

doOBT                 = 1
stopAfter             = obt

ovlErrorRate          = 0.40  #  Compute overlaps up to 40% error
obtErrorRate          = 0.40  #  Trim reads using overlaps up to 40% error.  New in CA 8!
cnsErrorRate          = 0.40  #  Needed to allow ovlErrorRate=0.40
cgwErrorRate          = 0.40  #  Needed to allow ovlErrorRate=0.40

ovlConcurrency        = 16
cnsConcurrency        = 4

ovlThreads            = 1
ovlHashBits           = 22
ovlHashBlockLength    = 10000000
ovlRefBlockSize       = 25000
