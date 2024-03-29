# snakemake-bismark-methyldackel

![Reproduction Status](https://img.shields.io/endpoint.svg?url=https://gist.githubusercontent.com/dohlee/39755d8246a88cea530fa72706397478/raw/bismark-methyldackel.json)

Bismark-MethylDackel pipeline in snakemake.

## Reproducible pipeline

This pipeline guarantees reproducible results, which means that it guarantees same output (DNA methylation levels) with same input (Bisulfite sequencing reads). The reproducibility is continuously being tested and the result is shown as a badge above.

## Quickstart

1. Clone the repo.

```
$ git clone https://github.com/dohlee/snakemake-bismark-methyldackel.git
$ cd snakemake-bismark-methyldackel
```

2. Generate manifest file automatically by running `getmanifest` script.
```
./getmanifest -i [SRP_ID] -d [PATH_TO_SRAmetadb.sqlite]
```

3. Modify the configurations manifest file as you want.

4. Run the pipeline.

If you already have snakemake installed, it might be useful to just use `--use-conda` option. Tweak `-j` parameter according to the number of available cores on your system. Also adjust `network` resource to limit the number of concurrent downloads of SRA files.

```
$ snakemake --use-conda -p -j 32 --resources network=2
```

Or you can create separate environment for this pipeline and run it.

```
$ conda env create -f environment.yaml
$ snakemake -p -j 32 --resources network=2
```
