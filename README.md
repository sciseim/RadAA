# RadAA
Code and data for the MS: 
Inge Seim, Andrew M. Baker, Lisa K. Chopin. *RadAA: a command-line tool for identification of radical amino acid changes in multiple sequence alignments*.

**Summary**:

*`RadAA`*: 
- Use this tool to identify radical amino-acid changes unique to one or more sequences in a multiple-sequence alignment
- Usage: ```RadAA -i <FASTA> <INPUTSPECIES>```, in which ‘-i’ is the input file argument and ‘\<FASTA>’ specifies a target multiple-sequence alignment flat file (FASTA format).
‘\<INPUTSPECIES>’ refers to the FASTA header number of the species examined (one or more species of interest), which can be determined using the companion tool FASTAheadernumber
- Three stand-alone versions exist:
1. `RadAA` - Linux version (tested on Debian-based distributions)
2. `RadAA-darwin` - MacOS (Darwin) version (built on MacOS High Sierra)
3. `RadAA-win64.exe` - Windows (64 bit) version (built on Windows 10)
- Source code (in Perl), can be found in ./source

*`FASTAheadernumber`*:
- Use this tool to interrogate FASTA files for the header number for your sample of interest
- Usage: ```FASTAheadnumber <FASTA>```, where '\<FASTA>' specifies a target multiple-sequence alignment flat file (FASTA format).
- Three stand-alone versions exist:
1. `FASTAheadernumber` - Linux version (tested on Debian-based distributions)
2. `FASTAheadernumber-darwin` - MacOS (Darwin) version (built on MacOS High Sierra)
3. `FASTAheadernumber-win64.exe` - Windows (64 bit) version (built on Windows 10)
- Source code (in Perl), can be found in ./source
