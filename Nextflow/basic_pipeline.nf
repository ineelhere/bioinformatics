#!/usr/bin/env nextflow /*The script starts with a shebang declaration. This allows you to launch your pipeline, as any other BASH script.*/
 
params.in = "$baseDir/data/sequence.fasta" /*Declares a pipeline parameter named params.in that is initialized with the value $HOME/sample.fa.This value can be overridden when launching the pipeline, by simply adding the option --in <value> to the script command line.*/
 
/*
 * split a fasta file in multiple files
 */
process splitSequences {
 
    input: /*Opens the input declaration block. The lines following this clause are interpreted as input definitions.*/
    path 'input.fa' from params.in  /*Declares the process input file. This file is taken from the params.in parameter and named input.fa.*/
 
    output: /*Opens the output declaration block. Lines following this clause are interpreted as output declarations.*/
    path 'seq_*' into records /*Defines that the process outputs files whose names match the pattern seq_*. These files are sent over the channel records.*/
 
    """
    awk '/^>/{f="seq_"++d} {print > f}' < input.fa 
    """ 
    /*The actual script executed by the process to split the provided file.*/
} /*The process that splits the provided file.*/
 
/*
 * Simple reverse the sequences
 */
process reverse {
 
    input: /*Opens the input declaration block. Lines following this clause are interpreted as input declarations.*/
    path x from records /*Defines the process input file. This file is received through the channel records.*/
     
    output: /*Opens the output declaration block. Lines following this clause are interpreted as output declarations*/
    stdout into result /*The standard output of the executed script is declared as the process output. This output is sent over the channel result.*/
 
    """
    cat $x | rev 
    """
    /*The actual script executed by the process to reverse the content of the received files*/
} /*Defines the second process, that receives the splits produced by the previous process and reverses their content.*/
 
/*
 * print the channel content
 */
result.subscribe { println it }
/*Prints a result each time a new item is received on the result channel.*/
