nextflow.enable.dsl=2

params.outputDir = "${launchDir}/output"

// Download the combined FASTA file with a link
process downloadFile {
    publishDir params.outputDir, mode: "copy", overwrite: true

    output:
        path "hepatitis_combined.fasta"

    script:
    """
    wget "https://gitlab.com/dabrowskiw/cq-examples/-/raw/master/data/hepatitis_combined.fasta?inli ne=false as an example input" -O hepatitis_combined.fasta
    """
}

process runMafft {
    publishDir params.outputDir, mode: "copy", overwrite: true

    input:
        path fasta_file

    output:
        path "hepatitis_aligned.fasta"

    script:
    """
    mafft --auto ${fasta_file} > hepatitis_aligned.fasta
    """
}

process runTrimal {
    publishDir params.outputDir, mode: "copy", overwrite: true

    input:
        path aligned_file

    output:
        path "hepatitis_cleaned.fasta"
        path "trimal_report.html"

    script:
    """
    trimal -in ${aligned_file} -out hepatitis_cleaned.fasta -htmlout trimal_report.html -automated1
    """
}

workflow {
    downloadFile | runMafft | runTrimal
}

