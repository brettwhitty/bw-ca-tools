Patch for Adding 'SLURM' Grid Engine Support to Celera Assembler 'runCA' Script
===============================================================================

Just run 'do_runCA_slurm_patch.sh' to get the dirty business going.

After that, you should have a shiny "new" 'runCA.pl' that will allow you to "Enjoy Slurm!"

There's a "test suite" under 'test-ca-slurm-patch' that should satisfy your concerns, or enhance them. Be forewarned that I picked a real world CA test dataset very quickly, and so it's larger than it needs to be for practical purposes. There's a README.md there with run details.

I worked off a vanilla install of both CA and SLURM for development and testing, so some tweaks may be required for your particular install environment. For an example of a working application that's out in the wild, check out Charlene Yang's version here: https://github.com/PawseySupercomputing/Celera-Assembler-Users

See the following CA ticket for discussion:
https://sourceforge.net/p/wgs-assembler/feature-requests/139/#ac40

Brett Whitty <brett@gnomatix.com>
