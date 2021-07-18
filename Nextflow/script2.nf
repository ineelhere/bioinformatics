/* pipeline input parameters */
params.reads = "$baseDir/data/ggal/*_{1,2}.fq"
params.transcriptome = "$baseDir/data/ggal/ggal_1_48850000_49020000.Ggal71.500bpflank.fa"
params.multiqc = "$baseDir/multiqc"
params.outdir = "results"
/*pass parameters | Notice the difference between $var and ${var} variable placeholders */
log.info """\
         R N A S E Q - N F   P I P E L I N E    
         ===================================
         transcriptome: ${params.transcriptome}
         reads        : ${params.reads}
         multiqc      : ${params.multiqc}
         outdir       : ${params.outdir}
         """
         .stripIndent()
/* define the `index` process that create a binary index given the transcriptome file */
process index {

    input:
    path transcriptome from params.transcriptome
/*Note how the input declaration defines a transcriptome variable in the process context 
 *that it is used in the command script to reference that file in the Salmon command line.*/
    output:
    path 'index' into index_ch

    script:
    """
    salmon index --threads $task.cpus -t $transcriptome -i index
    """ /*It takes the transcriptome params file as input and creates the transcriptome index by using the salmon tool.*/
}
index_ch.println()
