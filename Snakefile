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
include: 'rules/fastqc.smk'
include: 'rules/methyldackel.smk'
include: 'rules/sambamba.smk'

SAMPLE2LIB = {r.run_accession:r.library_layout for r in manifest.to_records()}
SE_MASK = manifest.library_layout.str.upper().str.contains('SINGLE')
PE_MASK = manifest.library_layout.str.upper().str.contains('PAIRED')
SAMPLES = manifest.run_accession.values
SE_SAMPLES = manifest[SE_MASK].run_accession.values
PE_SAMPLES = manifest[PE_MASK].run_accession.values
RAW_QC_SE = expand(str(DATA_DIR / '{sample}_fastqc.zip'), sample=SE_SAMPLES)
RAW_QC_PE = expand(str(DATA_DIR / '{sample}.read1_fastqc.zip'), sample=PE_SAMPLES)
TRIMMED_QC_SE = expand(str(RESULT_DIR / '01_trim-galore' / '{sample}.trimmed_fastqc.zip'), sample=SE_SAMPLES)
TRIMMED_QC_PE = expand(str(RESULT_DIR / '01_trim-galore' / '{sample}.read1.trimmed_fastqc.zip'), sample=PE_SAMPLES)

print(f'There are {len(SE_SAMPLES)} single-read and {len(PE_SAMPLES)} paired-end samples.')
print(f'Single-read sample examples: {SE_SAMPLES[:3]}')
print(f'Paired-end sample examples: {PE_SAMPLES[:3]}')
proc = input('Proceed? [y/n]: ')
if proc != 'y':
    sys.exit(1)

BEDGRAPHS = expand(str(RESULT_DIR / '03_methyldackel' / '{sample}_CpG.bedGraph'), sample=SAMPLES)

ALL = []
ALL.append(BEDGRAPHS)
ALL.append(RAW_QC_SE)
ALL.append(RAW_QC_PE)
ALL.append(TRIMMED_QC_SE)
ALL.append(TRIMMED_QC_PE)

rule all:
    input: ALL

rule clean:
    shell:
        "if [ -d {RESULT_DIR} ]; then rm -r {RESULT_DIR}; fi; "
        "if [ -d {DATA_DIR} ]; then rm -r {DATA_DIR}; fi; "
        "if [ -d logs ]; then rm -r logs; fi; "
        "if [ -d benchmarks ]; then rm -r benchmarks; fi; "
