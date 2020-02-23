c = config['multiqc']
rule multiqc:
    input:
        expand(str(DATA_DIR / '{sample}_fastqc.zip'), sample=SE_SAMPLES),
        expand(str(DATA_DIR / '{sample}.read1_fastqc.zip'), sample=PE_SAMPLES),
        expand(str(RESULT_DIR / '01_trim-galore' / '{sample}.trimmed_fastqc.zip'), sample=SE_SAMPLES),
        expand(str(RESULT_DIR / '01_trim-galore' / '{sample}.read1.trimmed_fastqc.zip'), sample=PE_SAMPLES),
    output:
        RESULT_DIR / '00_multiqc' / 'multiqc_report.html'
    params:
        extra = c['extra'],
        # Overwrite any existing reports.
        # Default: True
        force = c['force'],
        # Prepend directory to sample names.
        # Default: False
        dirs = c['dirs'],
        # Prepend [INT] directories to sample names.
        # Negative number to take from start of path.
        # Default: False
        dirs_depth = c['dirs_depth'],
        # Do not clean the sample names (leave as full file name).
        # Default: False
        fullnames = c['fullnames'],
        # Report title. Printed as page header, used for filename
        # if not otherwise specified.
        # Default: False,
        title = c['title'],
        # Custom comment, will be printed at the top of the report.
        # Default: False
        comment = c['comment'],
        # Create report in the specified output directory.
        # Default: False
        outdir = c['outdir'],
        # Report template to use.
        # Options: [default|default_dev|geo|sections|simple]
        # Default: False
        template = c['template'],
        # Use only modules which tagged with this keyword, eg. RNA.
        # Default: False
        tag = c['tag'],
        # Ignore analysis files (glob expression).
        # Default: False
        ignore = c['ignore'], # Ignore symlink directories and files.
        # Default: False
        ignore_symlinks = c['ignore_symlinks'],
        # File containing alternative sample names.
        # Default: False
        sample_names = c['sample_names'],
        # Supply a file containing a list of file paths to be searched,
        # one per row.
        # Default: False
        file_list = c['file_list'],
        # Do not use this module. Can specify multiple times.
        # Default: False
        exclude = c['exclude'],
        # Use only this module. Can specify multiple times.
        # Default: False
        module = c['module'],
        # Force the parsed data directory from being created.
        # Default: False
        data_dir = c['data_dir'],
        # Prevent the parsed data directory from being created.
        # Default: False
        no_data_dir = c['no_data_dir'],
        # Output parsed data in a different format.
        # Options: [tsv|json|yaml]
        # Default: tsv
        data_format = c['data_format'],
        # Compress the data directory.
        # Default: False
        zip_data_dir = c['zip_data_dir'],
        # Export plots as static images in addition to the report.
        # Default: False
        export = c['export'],
        # Use only flat plots (static images)
        # Default: False
        flat = c['flat'],
        # Use only interactive plots (HighCharts Javascript).
        # Default: False
        interactive = c['interactive'],
        # Use strict linting (validation) to help code development.
        # Default: False
        lint = c['lint'],
        # Creates PDF report with 'simple' template.
        # Requires Pandoc to be installed.
        # Default: False
        pdf = c['pdf'],
        # Don't upload generated report to MegaQC, even if MegaQC options are found.
        # Default: False
        no_megaqc_upload = c['no_megaqc_upload'],
        # Specific config file to load, after those in MultiQC dir / home dir / working dir.
        # Default: False
        config = c['config'],
        # Specify MultiQC config YAML on the commandline.
        # Default: False
        cl_config = c['cl_config'],
        # Increase output verbosity.
        # Default: False
        verbose = c['verbose'],
        # Only show log warnings.
        # Default: False
        quiet = c['quiet'],
    threads: 1
    log: 'logs/multiqc.log'
    wrapper:
        'http://dohlee-bio.info:9193/multiqc'
