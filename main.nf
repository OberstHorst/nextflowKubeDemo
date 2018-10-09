#!/usr/bin/env nextflow

params.location = 's3://test_data/SP1.fq'
params.publish = 's3://test_data/results/'
Channel.fromPath(params.location).set{ch_fastqs1}

process run_fastqc {
    publishDir params.publish

    input:
    file f from ch_fastqs1

    output:
    file "*.zip" into ch_qc_reports

    script:
    """
    fastqc $f
    """

}

process run_multiqc {
    publishDir params.publish

    input:
    file f from ch_qc_reports.collect()

    output:
    file "multiqc*" into ch_multiqc_result

    script:
    """
    multiqc $f
    """
}

