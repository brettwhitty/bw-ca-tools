runCA SLURM patch Test
======================

Tested working under the following test environment:

- Ubuntu 15.04 x86_64 (3.19.0-15-generic)
- Celera Assembler 8.3 installed from source with defaults (wgs-8.3rc2)
- SLURM installed from source with defaults (slurm-15.08.0-0pre6)
  ***with patched 'runCA' script in place***
- NFSv4-mounted working directory (via autofs)

To run tests from a host that can successfully run 'sbatch':

  ## download sample ecoli sequence data and prepare for 'runCA'
  _step-1__get_ecoli_test_data.sh
  
  ## submit the test 'runCA' job to SLURM
  sbatch _step-2__sbatch_runCA_trim_job_script.sh

Any problems should be apparent in the 'step 2' job's output file.
