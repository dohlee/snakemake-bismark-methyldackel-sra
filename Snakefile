import sys
import time
import pandas as pd

from pathlib import Path

wildcard_constraints:
    sample = 'SRR[0-9]+'

configfile: 'config.yaml'

manifest = pd.read_csv(config['manifest'])
DATA_DIR = Path(config['data_dir'])
RESULT_DIR = Path(config['result_dir'])

include: 'rules/download.smk'
include: 'rules/trim-galore.smk'
include: 'rules/bismark.smk'
include: 'rules/methyldackel.smk'
include: 'rules/sambamba.smk'

SE_MASK = manifest.library_layout.str.upper().str.contains('SINGLE')
PE_MASK = manifest.library_layout.str.upper().str.contains('PAIRED')
SE_SAMPLES = manifest[SE_MASK].run_accession.values
PE_SAMPLES = manifest[PE_MASK].run_accession.values

print(f'There are {len(SE_SAMPLES)} single-read and {len(PE_SAMPLES)} paired-end samples.')
print(f'Single-read sample examples: {SE_SAMPLES[:3]}')
print(f'Paired-end sample examples: {PE_SAMPLES[:3]}')
proc = input('Proceed? [y/n]: ')
if proc != 'y':
    sys.exit(1)

SE_BEDGRAPHS = expand(str(RESULT_DIR / '03_methyldackel' / 'se' / '{sample}_CpG.bedGraph'), sample=SE_SAMPLES)
PE_BEDGRAPHS = expand(str(RESULT_DIR / '03_methyldackel' / 'pe' / '{sample}_CpG.bedGraph'), sample=PE_SAMPLES)

ALL = []
ALL.append(SE_BEDGRAPHS)
ALL.append(PE_BEDGRAPHS)

rule all:
    input: ALL

rule clean:
    shell:
        "if [ -d {RESULT_DIR} ]; then rm -r {RESULT_DIR}; fi; "
        "if [ -d {DATA_DIR} ]; then rm -r {DATA_DIR}; fi; "
        "if [ -d logs ]; then rm -r logs; fi; "
        "if [ -d benchmarks ]; then rm -r benchmarks; fi; "
