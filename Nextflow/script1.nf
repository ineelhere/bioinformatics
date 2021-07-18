/*define parameters*/
params.reads = "$baseDir/data/*_{1,2}.fq"
params.transcriptome = "$baseDir/data/ggal_1_48850000_49020000.Ggal71.500bpflank.fa"
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
/*did you realise we just wrote a multiline string! */
println "reads: $params.reads" 
