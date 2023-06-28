/*
 * Defines some parameters in order to specify the refence genomes
 * and read pairs by using the command line options
 */
params.genome = "$baseDir/data/16s/*.fastq"
params.outdir = 'results'

/* 
 * prints user convenience 
 */
println "M I N I O N - MICROBIAL GENOME ASSEMBLY    "
println "================================="
println "genome             : ${params.genome}"

/*
 * get a file object for the given param string
 */
genome_file = file(params.genome)

/*
 * Step 1. Assembly genomes
 */
process buildIndex {
    tag "$genome_file.baseName"
    
    input:
    file genome from genome_file
     
    output:
    file 'genome.index*' into genome_index
       
    """
    porechop --threads 50 -i ${genome} -o genome.index
    NanoFilt -q 8 -l 1000 genome.index > genome.index.2.fastq
    flye --nano-raw genome.index.2.fastq --out-dir assembly --threads 50
    """
}

