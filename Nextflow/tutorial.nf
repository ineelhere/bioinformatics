#!/usr/bin/env nextflow
params.str = 'Hello elucidata!'
process splitLetters {

    output:
    file 'chunk_*' into letters

    """
    printf '${params.str}' | split -b 5 - chunk_
    """
}
process convertToUpper {

    input:
    file x from letters.flatten()

    output:
    stdout result

    """
    cat $x | tr '[a-z]' '[A-Z]'
    """
}
result.view { it.trim() }
