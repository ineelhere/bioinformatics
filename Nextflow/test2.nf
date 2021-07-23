#!/usr/bin/env nextflow

// parameters

params.reads = "$baseDir/data/new/*_R{1,2}_001.fq"
// params.reads = "$baseDir/data/*_R{1,2}_001.fastq.gz"
// params.reads = "$baseDir/data/33_S134_R1_001.fastq.gz"
params.fasta = "$baseDir/data/dummy_for_star.fa"
params.download_fasta = false
params.aligner = 'star'
params.star_index = "$baseDir/data/dummy_for_star.fa"
params.genome = "$baseDir/star/"
params.gtf = "$baseDir/data/dummy_gtf.gtf"
params.download_gtf =false
// http://ftp.ensembl.org/pub/release-104/gtf/homo_sapiens/Homo_sapiens.GRCh38.104.gtf.gz
params.saveReference = true
params.cutadapt = true
params.outdir = "results"

println """\
         R N A S E Q - N F   P I P E L I N E    
         ===================================
         reads        : ${params.reads}
         aligner      : ${params.aligner}
         gtf          : ${params.gtf}
         star_index   : ${params.star_index}
         saveReference: ${params.saveReference}
         outdir       : ${params.outdir}
         """
         .stripIndent()

if( params.gtf ){
    Channel
        .fromPath(params.gtf)
        .ifEmpty { exit 1, "GTF annotation file not found: ${params.gtf}" }
        .into { gtf_makeSTARindex; gtf_makeHisatSplicesites; gtf_makeHISATindex; gtf_makeBED12;
              gtf_star; gtf_dupradar; gtf_featureCounts; gtf_stringtieFPKM }
}

// star indexing
fasta = params.fasta
process makeSTARindex{
    tag fasta
    publishDir path: {params.saveReference ? "${params.outdir}/reference_genome" : params.outdir },
               saveAs: {params.saveReference ? it : null}, mode: 'copy'
    input:
    file fasta from fasta
    file gtf from gtf_makeSTARindex
    output:
    file "star" into star_index
    script:
    """
    mkdir star
    STAR --runThreadN 16 \
         --runMode genomeGenerate \
         --genomeDir ${params.genome} \
         --genomeFastaFiles ${params.star_index} \
         --genomeSAindexNbases 3

    """
}

Channel 
    .fromFilePairs( params.reads )
    .ifEmpty { error "Cannot find any reads matching: ${params.reads}"  }
    .set { read_pairs_ch } 

process cutadapt {
    tag "cutadapt on $sample_id"
    publishDir path: {params.cutadapt ? "${params.outdir}/cutadapt" : params.outdir },
               saveAs: {params.cutadapt ? it : null}, mode: 'copy'

    input:
    set sample_id, file(reads) from read_pairs_ch

    output:
    file("cutadapt_${sample_id}_out") into cutadapt_ch

    script:
    """
    mkdir cutadapt_${sample_id}_out
    ~/.local/bin/cutadapt -a CTGTCTCTTATACACATCT -A CTGTCTCTTATACACATCT \
    --minimum-length 30 --pair-filter=any --cores=0 \
    -o "${sample_id}.AT.R2.fq" -p "${sample_id}.AT.R1.fq" ${reads}
    
    """  
}

Channel 
    .fromFilePairs( params.reads )
    .ifEmpty { error "Cannot find any reads matching: ${params.reads}"  }
    .set { read_pairs2_ch} 

process fastqc {
    tag "FASTQC on $sample_id"

    input:
    set sample_id, file(reads) from read_pairs2_ch

    output:
    file("fastqc_${sample_id}_logs") into fastqc_ch


    script:
    """
    mkdir fastqc_${sample_id}_logs
    fastqc -o fastqc_${sample_id}_logs -f fastq -q ${reads}
    """  
}  
process multiqc {
    publishDir params.outdir, mode:'copy'
       
    input:
    file('*') from (fastqc_ch).collect()
    
    output:
    file('multiqc_report.html')  
     
    script:
    """
    multiqc . 
    """
} 

workflow.onComplete { 
	println ( workflow.success ? "\nDone! Open the following report in your browser --> $params.outdir/multiqc_report.html\n" : "Oops .. something went wrong" )
}
