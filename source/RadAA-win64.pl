#!/usr/bin/env perl
#@ use strict ;
#@ use warnings ;
#@ use Term::ANSIColor ; 
no warnings ('uninitialized', 'substr'); # to avoid a silly error message http://www.perlmonks.org/?node_id=572129

use Getopt::Std ;
use Getopt::Long ;
# check if installed: perl -e "use Getopt::Long"
# or its path: perldoc -l Getopt::Long

################################################################################################################################################################
# RadAA.pl 
# By Inge Seim
# 4/2018
################################################################################################################################################################
# usage perl RadAA.pl NM_001112706.fa.fa 1 
# RadAA.pl <FASTA> species1 species2 species3 

#@ system("rm ./tmp/*.txt") ;
#@ system("rm ./tmp/transposed/") ;
#@ system("rm -r ./tmp") ;
system("cls") ;
print "\nPlease use the -h (help) option to get usage information.\n" ;


# **********************************************
# declare the perl command line flags/options we want to allow
my %options=();
getopts("ihvj:ln:s:", \%options);
#

# use later to check if -i sequence has been allocated targets
my $inputFASTAtest ="" ;



#
#
foreach (@ARGV)
{
#  print "$_\n";
}	


# 000000000000000000000000000000000000
# 000000000000000000000000000000000000
# HELP
if ($options{h})
{
  do_help();
}

sub do_help {
  system("cls") ;
  print "usage: RadAA.pl <FASTA> species1 .. (species)n\nSynopsis: identify radical amino-acid changes unique to one or more sequences in a multiple-sequence alignment\nOptions:\n-i\t<FASTA> input file\n-h\thelp\n-v\tversion\n";
}
# 000000000000000000000000000000000000
# 000000000000000000000000000000000000




# 000000000000000000000000000000000000
# 000000000000000000000000000000000000
# VERSION
if ($options{v})
{
  do_version();
}

sub do_version {
  system("cls") ;
  print "RadAA v2.0 (April 2018) by Inge Seim (inge.seim@gmail.com)\n";
}
# 000000000000000000000000000000000000
# 000000000000000000000000000000000000






# 000000000000000000000000000000000000
# 000000000000000000000000000000000000
# INPUT
if ($options{i})
{
  do_input();
}
# START OF sub_do_input
sub do_input{ 
system("cls") ;

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# STEP 1
################################################################################################################################################################
# removeheader.pl - this script does something awful.
# It is supposed to remove the headers of remove the headers of FASTA formatted files
################################################################################################################################################################
my $seqnum = 0;
my @seq;
my @seqheader;
# Prepare the output file name and directory here
my $filename = $ARGV[0];
system("mkdir tmp\\transposed");
system("mkdir results");

# remove file extension
$filename =~ s/(.+)\.[^.]+$/$1/;

readFasta($ARGV[0]); 
# Read each file in as somethingawful.pl "filename" . Batch this script to analyse 1000s of Clustal alignments using bash, or similar.
################################################################################################################################################################
# SUBROUTINE shamelessly stolen from Yu-Wei Wu's (Indiana University) blog 
# http://yuweibioinfo.blogspot.com/2008/10/perl-fasta-sequence-parser.html
# all sequences will be stored in seq array, and the number of sequences is stored in $seqnum.
sub readFasta
{
	my $line;
	my $first;
	my $temp;
	open(FILE, "<$_[0]") || die "\nERROR:Please use the -h (help) option to get usage information.\n";
	$seqnum = 0;
	$first = 0;
	while (defined($line = <FILE>))
	{
		chomp($line);
		$temp = substr($line, length($line) - 1, 1);
		if ($temp eq "\r" || $temp eq "\n")
		{
			chop($line);
		}
		if ($line =~ /^>/)
		{
			$seqnum = $seqnum + 1;
			if ($first == 0)
			{
				$first = 1;
			}
			next;
		}
		if ($first == 0)
		{
			die "Not a standard FASTA file. Stop.\n";
		}
		$seq[$seqnum - 1] = $seq[$seqnum - 1] .$line;
	}
	close(FILE);
}
################################################################################################################################################################
# all sequences will be stored in seq array, and the number of sequences is stored in $seqnum.
# @seq = where the sequences are …
# so, let us print out the entire sequence without those headers...
foreach my $index (0 .. $#seq) {
   open FILE, ">>./tmp/$filename.noheader.txt" ;  #open for write, append since we want to include # comparisons # from the start to the end of the #seq
	print FILE $seq[$index] . "\n" ;   
}
   close FILE ;

# print entire array
#@ print "@noheaderarray\n";
# #############################
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@






# #################################################################################################################################################
# STEP 2
# TRANSPOSE
#  This script calls a magic Perl one liner that will transpose (column to row transformation))
# MAA
# MAA
# MA-
# CCA
#
# to 
# MMMC
# AAAC
# AA-A
# etc
# #################################################################################################################################################
my @matrix;
my @transposedarray;

open (SOURCE, "./tmp/$filename.noheader.txt") ;
my $matrixwidth = -1;
my $matrixheight = 0;
foreach (<SOURCE>) {
  chomp;
  if ($matrixwidth < length $_) {$matrixwidth = length $_}
  my @row = split(//, $_);
  push @matrix, \@row;
  $matrixheight++;
}
foreach my $x (0 .. ($matrixwidth-1)) {
  foreach my $y (0 .. ($matrixheight-1)) {

open FILE, ">>./tmp/transposed/$filename.txt" ;  #open for write, append since we want to include # comparisons # from the start to the end of the #seq
#@ print(defined $matrix[$y]->[$x] ? $matrix[$y]->[$x] : ' ');  # to screen
print FILE (defined $matrix[$y]->[$x] ? $matrix[$y]->[$x] : ' ');  # to temp file


  }
#@ print "\n"; # to screen

print FILE "\n"; # to temp file
close FILE ;


}

# THE FILE IS NOW IN ./tmp/transposed/$filename.txt


# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@






################################################################################################################################################################
# AAtypesort.pl - this script does something awful.
# By Inge Seim
# 6/2012
#
# This script will only output AA residues of target species (plural) that are of a different 
# "type"
#  Groups AAs into acidic (ED), basic (KHR), cysteine (C) and other (STYNQGAVLIFPMW) 
#
#   to run, type AAtypesort.pl [filename] [#target1 [#target2] etc
#   
#    
################################################################################################################################################################
#@ system("mkdir results && cd ./results");  
#@ system("mkdir results/radical");  
# system("mkdir results/conservative");  
system("cls");

# Prepare the output file name and directory here
#@ my $filename = $ARGV[0] ;

my $inputfile = "./tmp/transposed/$filename.txt" ;

my $targetinput = $ARGV[1]-1 ;  # e.g. if 1, it is 0
my $targetinput2 = $ARGV[2]-1 ;  # e.g. if 2, it is 1
my $targetinput3 = $ARGV[3]-1 ;  
my $targetinput4 = $ARGV[4]-1 ;  
my $targetinput5 = $ARGV[5]-1 ;  
my $targetinput6 = $ARGV[6]-1 ;  
my $targetinput7 = $ARGV[7]-1 ;  
my $targetinput8 = $ARGV[8]-1 ;  
my $targetinput9 = $ARGV[9]-1 ;  
my $targetinput10 = $ARGV[10]-1 ;  

#@ print $targetinput . " is target input#1 number used to call the array here" . "\n" ;
$inputFASTAtest=$targetinput ;


my @data = "" ;
open (FILE, $inputfile) or die "usage: AAtypesort.pl [filename]  [target # in MSA] etc	 \n";
chomp (@data = (<FILE>));
close(FILE);

# print $data[0] . " is position 0 AKA element 1" . "\n" ;
# e.g. EDVVVVVVV

###########  HERE COMES THE ACTUAL PARSING

foreach my $index (0 .. $#data) { 
#  The foreach will loop until ∞
#  Start of a very large loop! 
#
my $position = $index + 1 ;  # To obtain real AA positions in the protein, since array elements start at 0, not 1 
# print $position . "index here" . "\n" ;
# Position = AA position 
# Remember, we have transposed sequences here 
# e.g. AA residue 1 of ten species is REDRRRRRKH
#
 	
	
		
# •••••••••••••••••••••••••••••••
# 240612
#
# REDRRRRRKH test input . i.e. targets are all acidic while the others are basic
# to test the script, just put the above bases in a flat file
# •••••••••••••••••••••••••••••••


####
my $length = length($data[$index]);
my $indexstring = $data[$index] ;
# print $data[0] . " first element of array data" . "\n";

#@ print "\n" ;
#@ print "The residue of interest in the species examined: " . $indexstring . "\n" . "\n" . "\n" ;

# my $first = substr($indexstring, 0, 1); #returns the first character

# chuck it into an array
my @values = split('', $data[$index]);

# print $data[0] . " is the first element of the array data" . "\n" ;
# print $values[0] . " is the first element of the array values" . "\n" ;


# remember that the array changes as you splice it!!	
# so delete targetspecies from the back!! e.g. #40

#####################  THIS SECTION CONTAINS THE GROUPING ACCORDING TO TARGET VS THE REST
#  CREATE ABOUT 50 OF THESE FOR NOW!
my $targetinputAA = "" ;
my $targetinput2AA = "" ;
my $targetinput3AA = "" ;
my $targetinput4AA = "" ;
my $targetinput5AA = "" ;
my $targetinput6AA = "" ;
my $targetinput7AA = "" ;
my $targetinput8AA = "" ;
my $targetinput9AA = "" ;
my $targetinput10AA = "" ;
my $targetinput11AA = "" ;
my $targetinput12AA = "" ;
my $targetinput13AA = "" ;
my $targetinput14AA = "" ;
my $targetinput15AA = "" ;
my $targetinput16AA = "" ;
my $targetinput17AA = "" ;
my $targetinput18AA = "" ;
my $targetinput19AA = "" ;
my $targetinput20AA = "" ;
my $targetinput21AA = "" ;
my $targetinput22AA = "" ;
my $targetinput22AA = "" ;
my $targetinput23AA = "" ;
my $targetinput24AA = "" ;
my $targetinput25AA = "" ;
my $targetinput26AA = "" ;
my $targetinput27AA = "" ;
my $targetinput28AA = "" ;
my $targetinput29AA = "" ;
my $targetinput30AA = "" ;
my $targetinput31AA = "" ;
my $targetinput32AA = "" ;
my $targetinput33AA = "" ;
my $targetinput34AA = "" ;
my $targetinput35AA = "" ;
my $targetinput36AA = "" ;
my $targetinput37AA = "" ;
my $targetinput38AA = "" ;
my $targetinput39AA = "" ;
my $targetinput40AA = "" ;
my $targetinput41AA = "" ;
my $targetinput42AA = "" ;
my $targetinput43AA = "" ;
my $targetinput44AA = "" ;
my $targetinput45AA = "" ;
my $targetinput46AA = "" ;
my $targetinput47AA = "" ;
my $targetinput48AA = "" ;
my $targetinput49AA = "" ;
my $targetinput50AA = "" ;


# print $targetinputAA . "is TARGETINPUT" . "\n" ;

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 50 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput50 >=0) { 
	$targetinput50AA = $values[$targetinput50] ;
	delete $values[$targetinput50]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 49 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput49 >=0) { 
	$targetinput49AA = $values[$targetinput49] ;
	delete $values[$targetinput49]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 48 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput48 >=0) { 
	$targetinput48AA = $values[$targetinput48] ;
	delete $values[$targetinput48]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 47 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput47 >=0) { 
	$targetinput47AA = $values[$targetinput47] ;
	delete $values[$targetinput47]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 46 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput46 >=0) { 
	$targetinput46AA = $values[$targetinput46] ;
	delete $values[$targetinput46]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 45 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput45 >=0) { 
	$targetinput45AA = $values[$targetinput45] ;
	delete $values[$targetinput45]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 44 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput44 >=0) { 
	$targetinput44AA = $values[$targetinput44] ;
	delete $values[$targetinput44]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 43 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput43 >=0) { 
	$targetinput43AA = $values[$targetinput43] ;
	delete $values[$targetinput43]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 42 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput42 >=0) { 
	$targetinput42AA = $values[$targetinput42] ;
	delete $values[$targetinput42]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 41 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput41 >=0) { 
	$targetinput41AA = $values[$targetinput41] ;
	delete $values[$targetinput41]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 40 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput40 >=0) { 
	$targetinput40AA = $values[$targetinput40] ;
	delete $values[$targetinput40]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 39 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput39 >=0) { 
	$targetinput39AA = $values[$targetinput39] ;
	delete $values[$targetinput39]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 38 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput38 >=0) { 
	$targetinput38AA = $values[$targetinput38] ;
	delete $values[$targetinput38]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 37 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput37 >=0) { 
	$targetinput37AA = $values[$targetinput37] ;
	delete $values[$targetinput37]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 36 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput36 >=0) { 
	$targetinput36AA = $values[$targetinput36] ;
	delete $values[$targetinput36]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 35 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput35 >=0) { 
	$targetinput35AA = $values[$targetinput35] ;
	delete $values[$targetinput35]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 34 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput34 >=0) { 
	$targetinput34AA = $values[$targetinput34] ;
	delete $values[$targetinput34]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 33 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput33 >=0) { 
	$targetinput33AA = $values[$targetinput33] ;
	delete $values[$targetinput33]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 32 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput32 >=0) { 
	$targetinput32AA = $values[$targetinput32] ;
	delete $values[$targetinput32]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 31 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput31 >=0) { 
	$targetinput31AA = $values[$targetinput31] ;
	delete $values[$targetinput31]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 30 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput30 >=0) { 
	$targetinput30AA = $values[$targetinput30] ;
	delete $values[$targetinput30]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 29 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput29 >=0) { 
	$targetinput29AA = $values[$targetinput29] ;
	delete $values[$targetinput29]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 28 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput28 >=0) { 
	$targetinput28AA = $values[$targetinput28] ;
	delete $values[$targetinput28]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 27 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput27 >=0) { 
	$targetinput27AA = $values[$targetinput27] ;
	delete $values[$targetinput27]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 26 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput26 >=0) { 
	$targetinput26AA = $values[$targetinput26] ;
	delete $values[$targetinput26]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 25 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput25 >=0) { 
	$targetinput25AA = $values[$targetinput25] ;
	delete $values[$targetinput25]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 24 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput24 >=0) { 
	$targetinput24AA = $values[$targetinput24] ;
	delete $values[$targetinput24]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 23 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput23 >=0) { 
	$targetinput23AA = $values[$targetinput23] ;
	delete $values[$targetinput23]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 22 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput22 >=0) { 
	$targetinput22AA = $values[$targetinput22] ;
	delete $values[$targetinput22]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 21 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput21 >=0) { 
	$targetinput21AA = $values[$targetinput21] ;
	delete $values[$targetinput21]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 20 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput20 >=0) { 
	$targetinput20AA = $values[$targetinput20] ;
	delete $values[$targetinput20]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 19 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput19 >=0) { 
	$targetinput19AA = $values[$targetinput19] ;
	delete $values[$targetinput19]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 18 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput18 >=0) { 
	$targetinput18AA = $values[$targetinput18] ;
	delete $values[$targetinput18]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 17 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput17 >=0) { 
	$targetinput17AA = $values[$targetinput17] ;
	delete $values[$targetinput17]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 16 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput16 >=0) { 
	$targetinput16AA = $values[$targetinput16] ;
	delete $values[$targetinput16]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 15 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput15 >=0) { 
	$targetinput15AA = $values[$targetinput15] ;
	delete $values[$targetinput15]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 14 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput14 >=0) { 
	$targetinput14AA = $values[$targetinput14] ;
	delete $values[$targetinput14]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 13 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput13 >=0) { 
	$targetinput13AA = $values[$targetinput13] ;
	delete $values[$targetinput13]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 12 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput12 >=0) { 
	$targetinput12AA = $values[$targetinput12] ;
	delete $values[$targetinput12]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 11 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput11 >=0) { 
	$targetinput11AA = $values[$targetinput11] ;
	delete $values[$targetinput11]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 10 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput10 >=0) { 
	$targetinput10AA = $values[$targetinput10] ;
	delete $values[$targetinput10]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 9 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput9 >=0) { 
	$targetinput9AA = $values[$targetinput9] ;
	delete $values[$targetinput9]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 8 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput8 >=0) { 
	$targetinput8AA = $values[$targetinput8] ;
	delete $values[$targetinput8]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 7 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput7 >=0) { 
	$targetinput7AA = $values[$targetinput7] ;
	delete $values[$targetinput7]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 6 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput6 >=0) { 
	$targetinput6AA = $values[$targetinput6] ;
	delete $values[$targetinput6]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 5 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput5 >=0) { 
	$targetinput5AA = $values[$targetinput5] ;
	delete $values[$targetinput5]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 4 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput4 >=0) { 
	$targetinput4AA = $values[$targetinput4] ;
	delete $values[$targetinput4]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 3 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput3 >=0) { 
	$targetinput3AA = $values[$targetinput3] ;      
	delete $values[$targetinput3]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 2 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput2 >=0) { 
	$targetinput2AA = $values[$targetinput2] ;

#	print $values[$targetinput2] . " will be removed from targetspecies 2" . "\n" ;  
# time to remove your target
	delete $values[$targetinput2]	;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETSPECIES 1 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($targetinput >=0) { 
	$targetinputAA = $values[$targetinput] ; 
#	print $targetinputAA . " is stored in a variable before you remove it from the array!" . "\n" ;  # you have now stored your target AA before removing it from the array

# time to remove your target	
#	print $values[$targetinput] . " will be removed from targetspecies 1" . "\n" ;  # 
	delete $values[$targetinput]	;
	# print $values[0] . "it is now missing!" . "\n" ;  # not there
#		print "As you can see, the \"E\" is missing:" . $values[$targetinput] . "\n" ;
# deleting array elements in the middle of an array will not shift the index of the elements after them down. Use splice for that. This is actually very useful here.	
}
#
#
#
#












#####################################################################
# Push the removed target AAs into a new array here
my @targetarray = "" ;
# delete $targetarray[0]	; # get rid of the empty, first element

if ($targetinputAA ne "") 
{
push(@targetarray, $targetinputAA); 
}
if ($targetinput2AA ne "") {
push(@targetarray, $targetinput2AA); }
if ($targetinput3AA ne "") {
push(@targetarray, $targetinput3AA); }
if ($targetinput4AA ne "") {
push(@targetarray, $targetinput4AA); }
if ($targetinput5AA ne "") {
push(@targetarray, $targetinput5AA); }
if ($targetinput6AA ne "") {
push(@targetarray, $targetinput6AA); }
if ($targetinput7AA ne "") {
push(@targetarray, $targetinput7AA); }
if ($targetinput8AA ne "") {
push(@targetarray, $targetinput8AA); }
if ($targetinput9AA ne "") {
push(@targetarray, $targetinput9AA); }
if ($targetinput10AA ne "") {
push(@targetarray, $targetinput10AA); }
if ($targetinput11AA ne "") {
push(@targetarray, $targetinput11AA); }
if ($targetinput12AA ne "") {
push(@targetarray, $targetinput12AA); }
if ($targetinput13AA ne "") {
push(@targetarray, $targetinput13AA); }
if ($targetinput14AA ne "") {
push(@targetarray, $targetinput14AA); }
if ($targetinput15AA ne "") {
push(@targetarray, $targetinput15AA); }
if ($targetinput16AA ne "") {
push(@targetarray, $targetinput16AA); }
if ($targetinput17AA ne "") {
push(@targetarray, $targetinput17AA); }
if ($targetinput18AA ne "") {
push(@targetarray, $targetinput18AA); }
if ($targetinput19AA ne "") {
push(@targetarray, $targetinput19AA); }
if ($targetinput20AA ne "") {
push(@targetarray, $targetinput20AA); }
if ($targetinput21AA ne "") {
push(@targetarray, $targetinput21AA); }
if ($targetinput22AA ne "") {
push(@targetarray, $targetinput22AA); }
if ($targetinput23AA ne "") {
push(@targetarray, $targetinput23AA); }
if ($targetinput24AA ne "") {
push(@targetarray, $targetinput24AA); }
if ($targetinput25AA ne "") {
push(@targetarray, $targetinput25AA); }
if ($targetinput26AA ne "") {
push(@targetarray, $targetinput26AA); }
if ($targetinput27AA ne "") {
push(@targetarray, $targetinput27AA); }
if ($targetinput28AA ne "") {
push(@targetarray, $targetinput28AA); }
if ($targetinput29AA ne "") {
push(@targetarray, $targetinput29AA); }
if ($targetinput30AA ne "") {
push(@targetarray, $targetinput30AA); }
if ($targetinput31AA ne "") {
push(@targetarray, $targetinput31AA); }
if ($targetinput32AA ne "") {
push(@targetarray, $targetinput32AA); }
if ($targetinput33AA ne "") {
push(@targetarray, $targetinput33AA); }
if ($targetinput34AA ne "") {
push(@targetarray, $targetinput34AA); }
if ($targetinput35AA ne "") {
push(@targetarray, $targetinput35AA); }
if ($targetinput36AA ne "") {
push(@targetarray, $targetinput36AA); }
if ($targetinput37AA ne "") {
push(@targetarray, $targetinput37AA); }
if ($targetinput38AA ne "") {
push(@targetarray, $targetinput38AA); }
if ($targetinput39AA ne "") {
push(@targetarray, $targetinput39AA); }
if ($targetinput40AA ne "") {
push(@targetarray, $targetinput40AA); }
if ($targetinput41AA ne "") {
push(@targetarray, $targetinput41AA); }
if ($targetinput42AA ne "") {
push(@targetarray, $targetinput42AA); }
if ($targetinput43AA ne "") {
push(@targetarray, $targetinput43AA); }
if ($targetinput44AA ne "") {
push(@targetarray, $targetinput44AA); }
if ($targetinput45AA ne "") {
push(@targetarray, $targetinput45AA); }
if ($targetinput46AA ne "") {
push(@targetarray, $targetinput46AA); }
if ($targetinput47AA ne "") {
push(@targetarray, $targetinput47AA); }
if ($targetinput48AA ne "") {
push(@targetarray, $targetinput48AA); }
if ($targetinput49AA ne "") {
push(@targetarray, $targetinput49AA); }
if ($targetinput50AA ne "") {
push(@targetarray, $targetinput50AA); }


# TESTING 
# print @targetarray[0] . " target" . "\n" ;
# print @targetarray[1] . " target" . "\n" ;

##################### END OF PRE-PROCESSING ####################


	
#####################  THIS SECTION CONTAINS THE COMPARISON OF GROUPS
# E.G. NON-TARGET SPECIES AND TARGETS MUST BE DE/KRH/C/STYNQGAVLIFPMW 
# BUT THEY CANNOT BE THE SAME TYPE.. (fix that later)	

###################################
# ~ list of AAs here
# ~~~~~~~~~~ acidic ~~~~~~~~~~
     my $aaE = "E" ;
     my $aaD = "D" ;

# ~~~~~~~~~~ other ~~~~~~~~~~ 
     my $aaS = "S" ;
     my $aaT = "T" ;
     my $aaY = "Y" ;
     my $aaN = "N" ;
     my $aaQ = "Q" ;
     my $aaG = "G" ;
     my $aaA = "A" ;
     my $aaV = "V" ;
     my $aaL = "L" ;
     my $aaI = "I" ;
     my $aaF = "F" ;
     my $aaP = "P" ;
     my $aaM = "M" ;
     my $aaW = "W" ;

# ~~~~~~~~~~ basic ~~~~~~~~~~ 
     my $aaK = "K" ;
     my $aaR = "R" ;
     my $aaH = "H" ;

 # ~~~~~~~~~~ Cysteine ~~~~~~~~~~ 
     my $aaC = "C" ;
###################################



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Here, check that the NON-target array elments are indeed empty 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# print $values[0] . " zero" . "\n" ;
# print $values[1] . " one" . "\n" ;
# print $values[2] . " two" . "\n" ;
# print $values[3] . " three" . "\n" ;
# so, the array element exists, but is empty.
my @valuesnotargets = grep(!/^$/, @values);
# print $valuesnotargets[0] . " zero" . "\n" ;
# print $valuesnotargets[1] . " one" . "\n" ;
# print $valuesnotargets[2] . " two" . "\n" ;
# print $valuesnotargets[3] . " three" . "\n" ;
# print $valuesnotargets[4] . " four" . "\n" ;
# print $valuesnotargets[5] . " five" . "\n" ;
# print $valuesnotargets[6] . " six" . "\n" ;
#
# Works, so it is now time to check if these are of of the same type!


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ARE TARGET AND NON-TARGET AA RESIDUES OF THE SAME TYPE?
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
my $nontargetacidaccept = "" ; 
my $nontargetbaseaccept = "" ; 
my $nontargetotheraccept = "" ; 
my $nontargetcysteineaccept = "" ;
my $targetacidaccept = "" ; 
my $targetbaseaccept = "" ; 
my $targetotheraccept = "" ; 
my $targetcysteineaccept = "" ;



# #######################################################   
     
     # count # of elements in @valuesnotargets
     my $valuesnotargetsnumber = scalar(@valuesnotargets) ;

     # count # of hits ++ to $@valuesnotargets
     my $NTacidhits = 0 ;
	 my $NTbasichits = 0 ;
     my $NTchits = 0 ;
	 my $NTotherhits = 0 ;
         
     # count # of elements in @targetarray
     my $targetarraynumber = scalar(@targetarray)-1 ; 	 
 	 
 	 # count # of hits ++ to $@targetarray
 	 my $Tacidhits = 0 ;
	 my $Tbasichits = 0 ;
     my $Tchits = 0 ;
	 my $Totherhits = 0 ;
     

# START OF NON-TARGET
# ~~~~~~~~~~ acidic ~~~~~~~~~~
foreach my $index (0 .. $#valuesnotargets) {
	
		 if ($valuesnotargets[$index] eq $aaD 
		 or $valuesnotargets[$index] eq $aaE) {  
		 # print "non-targets are all acidic" . "\n" ;
         my $finalcount = $NTacidhits++;
          
     }


} # end of this for each
# print $NTacidhits . " is the number of hits" . "\n" ;
#@ print $NTacidhits . " out of " . $valuesnotargetsnumber . " *non-targets* are acidic" . "\n" ;

if ($NTacidhits != $valuesnotargetsnumber) {
$nontargetacidaccept = "0" ;   
#@ print "not the same type of residue: " ;
#@ print color 'red' ;
#@ print " *FAIL*!" . "\n" ;
#@ print color 'reset';
}  

if ($NTacidhits == $valuesnotargetsnumber) {
$nontargetacidaccept = "1" ;   
#@ print "all the same type of residue: " ;
#@ print color 'green' ;
#@ print " *PASS*!" . "\n" ;
#@ print color 'reset';
} 

# 0 is No, 1 is Yes
# ~~~~~~~~~~ END OF acidic ~~~~~~~~~~

# ~~~~~~~~~~ basic ~~~~~~~~~~
foreach my $index (0 .. $#valuesnotargets) {
	
		 if ($valuesnotargets[$index] eq $aaK 
		 or $valuesnotargets[$index] eq $aaR 
		 or $valuesnotargets[$index] eq $aaH) {  
		 # print "non-targets are all basic" . "\n" ;
         my $finalcount = $NTbasichits++;
          
     }


} # end of this for each
# print $NTbasichits . " is the number of hits" . "\n" ;
#@  print $NTbasichits . " out of " . $valuesnotargetsnumber . " *non-targets* are basic" . "\n" ;

if ($NTbasichits != $valuesnotargetsnumber) {
$nontargetbaseaccept = "0" ;   
#@ print "not the same type of residue: " ;
#@ print color 'red' ;
#@ print " *FAIL*!" . "\n" ;
#@ print color 'reset';
}  

if ($NTbasichits == $valuesnotargetsnumber) {
$nontargetbaseaccept = "1" ;   
#@ print "all the same type of residue: " ;
#@ print color 'green' ;
#@ print " *PASS*!" . "\n" ;
#@ print color 'reset';
} 

# 0 is No, 1 is Yes
# ~~~~~~~~~~ END OF basic ~~~~~~~~~~

# ~~~~~~~~~~ other ~~~~~~~~~~ 
# STYNQGAVLIFPMW
foreach my $index (0 .. $#valuesnotargets) {
	
		 if (
		 	$valuesnotargets[$index] eq $aaS
		 or $valuesnotargets[$index] eq $aaT 
		 or $valuesnotargets[$index] eq $aaY 
		 or $valuesnotargets[$index] eq $aaN 
		 or $valuesnotargets[$index] eq $aaQ 
		 or $valuesnotargets[$index] eq $aaG 
		 or $valuesnotargets[$index] eq $aaA 
		 or $valuesnotargets[$index] eq $aaV 
		 or $valuesnotargets[$index] eq $aaL 
		 or $valuesnotargets[$index] eq $aaI
		 or $valuesnotargets[$index] eq $aaF
		 or $valuesnotargets[$index] eq $aaP
		 or $valuesnotargets[$index] eq $aaM
		 or $valuesnotargets[$index] eq $aaW
		 ) {  
		 # print "non-targets are all others" . "\n" ;
         my $finalcount = $NTotherhits++;
          
     } 


} # end of this for each
# print $NTotherhits . " is the number of hits" . "\n" ;
#@  print $NTotherhits . " out of " . $valuesnotargetsnumber . " *non-targets* are \"other\"" . "\n" ;

if ($NTotherhits != $valuesnotargetsnumber) {
$nontargetotheraccept = "0" ;   
#@ print "not the same type of residue: " ;
#@ print color 'red' ;
#@ print " *FAIL*!" . "\n" ;
#@ print color 'reset';
}  

if ($NTotherhits == $valuesnotargetsnumber) {
$nontargetotheraccept = "1" ;   
#@ print "all the same type of residue: " ;
#@ print color 'green' ;
#@ print " *PASS*!" . "\n" ;
#@ print color 'reset';
} 


# 0 is No, 1 is Yes
# ~~~~~~~~~~ END OF other ~~~~~~~~~~

# ~~~~~~~~~~ cysteine ~~~~~~~~~~
foreach my $index (0 .. $#valuesnotargets) {
	
		 if ($valuesnotargets[$index] eq $aaC ) 
		 {  
		 # print "non-targets are all cysteines" . "\n" ;
         my $finalcount = $NTchits++;
          
     }


} # end of this for each
# print $NTchits . " is the number of hits" . "\n" ;
#@  print $NTchits . " out of " . $valuesnotargetsnumber . " *non-targets* harbour cysteine" . "\n" ;

if ($NTchits != $valuesnotargetsnumber) {
$nontargetcysteineaccept = "0" ;   
#@ print "not the same type of residue: " ;
#@ print color 'red' ;
#@ print " *FAIL*!" . "\n" ;
#@ print color 'reset';
}  

if ($NTchits == $valuesnotargetsnumber) {
$nontargetcysteineaccept = "1" ;   
#@ print "all the same type of residue: " ;
#@ print color 'green' ;
#@ print " *PASS*!" . "\n" ;
#@ print color 'reset';
} 

# 0 is No, 1 is Yes
# ~~~~~~~~~~ END OF cysteine ~~~~~~~~~~
#####  END OF THE NON-TARGETS ###

# START OF TARGET

# ~~~~~~~~~~ acidic ~~~~~~~~~~
foreach my $index (0 .. $#targetarray) {
	
		 if ($targetarray[$index] eq $aaD 
		 or $targetarray[$index] eq $aaE) {  
		 # print "targets are all acidic" . "\n" ;
         my $finalcount = $Tacidhits++;
          
     }


} # end of this for each
# print $Tacidhits . " is the number of hits" . "\n" ;
#@  print $Tacidhits . " out of " . $targetarraynumber . " *targets* are acidic" . "\n" ;

if ($Tacidhits != $targetarraynumber) {
$targetacidaccept = "0" ;   
#@ print "not the same type of residue: " ;
#@ print color 'red' ;
#@ print " *FAIL*!" . "\n" ;
#@ print color 'reset';
}  

if ($Tacidhits == $targetarraynumber) {
$targetacidaccept = "1" ;   
#@ print "all the same type of residue: " ;
#@ print color 'green' ;
#@ print " *PASS*!" . "\n" ;
#@ print color 'reset';
} 

# 0 is No, 1 is Yes
# ~~~~~~~~~~ END OF acidic ~~~~~~~~~~

# ~~~~~~~~~~ basic ~~~~~~~~~~
foreach my $index (0 .. $#targetarray) {
	
		 if ($targetarray[$index] eq $aaK 
		 or $targetarray[$index] eq $aaR 
		 or $targetarray[$index] eq $aaH) {  
		 # print "targets are all basic" . "\n" ;
         my $finalcount = $Tbasichits++;
          
     }


} # end of this for each
# print $Tbasichits . " is the number of hits" . "\n" ;
#@  print $Tbasichits . " out of " . $targetarraynumber . " *targets* are basic" . "\n" ;

if ($Tbasichits != $targetarraynumber) {
$targetbaseaccept = "0" ;   
#@ print "not the same type of residue: " ;
#@ print color 'red' ;
#@ print " *FAIL*!" . "\n" ;
#@ print color 'reset';
}  

if ($Tbasichits == $targetarraynumber) {
$targetbaseaccept = "1" ;   
#@ print "all the same type of residue: " ;
#@ print color 'green' ;
#@ print " *PASS*!" . "\n" ;
#@ print color 'reset';
} 



# 0 is No, 1 is Yes
# ~~~~~~~~~~ END OF basic ~~~~~~~~~~

# ~~~~~~~~~~ other ~~~~~~~~~~ 
# STYNQGAVLIFPMW
foreach my $index (0 .. $#targetarray) {
	
		 if (
		 	$targetarray[$index] eq $aaS
		 or $targetarray[$index] eq $aaT 
		 or $targetarray[$index] eq $aaY 
		 or $targetarray[$index] eq $aaN 
		 or $targetarray[$index] eq $aaQ 
		 or $targetarray[$index] eq $aaG 
		 or $targetarray[$index] eq $aaA 
		 or $targetarray[$index] eq $aaV 
		 or $targetarray[$index] eq $aaL 
		 or $targetarray[$index] eq $aaI
		 or $targetarray[$index] eq $aaF
		 or $targetarray[$index] eq $aaP
		 or $targetarray[$index] eq $aaM
		 or $targetarray[$index] eq $aaW
		 ) {  
		 # print "targets are all others" . "\n" ;
         my $finalcount = $Totherhits++;
          
     } 


} # end of this for each
# print $Totherhits . " is the number of hits" . "\n" ;
#@  print $Totherhits . " out of " . $targetarraynumber . " *targets* are \"other\"" . "\n" ;

if ($Totherhits != $targetarraynumber) {
$targetotheraccept = "0" ;   
#@ print "not the same type of residue: " ;
#@ print color 'red' ;
#@ print " *FAIL*!" . "\n" ;
#@ print color 'reset';
}  

if ($Totherhits == $targetarraynumber) {
$targetotheraccept = "1" ;   
#@ print "all the same type of residue: " ;
#@ print color 'green' ;
#@ print " *PASS*!" . "\n" ;
#@ print color 'reset';
} 

# 0 is No, 1 is Yes
# ~~~~~~~~~~ END OF other ~~~~~~~~~~

# ~~~~~~~~~~ cysteine ~~~~~~~~~~
foreach my $index (0 .. $#targetarray) {
	
		 if ($targetarray[$index] eq $aaC ) 
		 {  
		 # print "targets are all cysteines" . "\n" ;
         my $finalcount = $Tchits++;
          
     }


} # end of this for each
# print $Tchits . " is the number of hits" . "\n" ;
#@  print $Tchits . " out of " . $targetarraynumber . " *targets* harbour cysteine" . "\n" ;

if ($Tchits != $targetarraynumber) {
$targetcysteineaccept = "0" ;   
#@ print "not the same type of residue: " ;
#@ print color 'red' ;
#@ print " *FAIL*!" . "\n" ;
#@ print color 'reset';
}  

if ($Tchits == $targetarraynumber) {
$targetcysteineaccept = "1" ;   
#@ print "all the same type of residue: " ;
#@ print color 'green' ;
#@ print " *PASS*!" . "\n" ;
#@ print color 'reset';
} 

# 0 is No, 1 is Yes
# ~~~~~~~~~~ END OF cysteine ~~~~~~~~~~
#####  END OF THE targets ###




    
    
    
    
    
    
    
    
    
    
    
    
# Comparison time
    
    
    
################################################
# ~NT Base~
################################################
# NT basic, T acidic 
if ($nontargetbaseaccept == 1              # NON-TARGET  
   && $targetacidaccept >= 1             # TARGET
   )
   {
#@    	print "\n" . "this residue type is unique to your target species:" ;
#@    	print "NT basic, T acidic!" . "\n" ; 
#@    	print color 'reset';
 # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# added April 2018       
# only keep unique AAs (so R, not RRRRR)
# fix April 2018
# white spaces sometime resulted in blank residues...       
      my $AAtarget = "@targetarray" ;
      # remove white-space in the string
      $AAtarget =~ s/\s//g;
      # keep unique residues
      $AAtarget =~ s[(.)(?=.*?\1)][]g;

      my $AAnotarget = "@valuesnotargets" ;
      # remove white-space in the string
      $AAnotarget =~ s/\s//g;
      # keep unique residues
      $AAnotarget =~ s[(.)(?=.*?\1)][]g; # remove all duplicate residues, not just adjacent ones!
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~         
          open FILE, ">>./results/$filename.txt" ;  #open for write, append since we want to include # comparisons from the start to the end of the @data
          # ORIGINAL: print FILE "NT basic" . "\t" . $position . "\t" . "T acidic" . "\n";   
        print FILE "NT basic" . "\t" . $position . "\t" . "T acidic" . "\t" . $AAnotarget . $position . $AAtarget . "\n";
        close FILE
  
   }


    # ########################################################################################################################
    # ########################################################################################################################

# NT basic, T other
elsif ($nontargetbaseaccept == 1              # NON-TARGET  
   && $targetotheraccept >= 1             # TARGET
   )
   {
#@    	print "\n" . "this residue type is unique to your target species:" ;
#@    	print "NT basic, T other!" . "\n" ; 
#@    	print color 'reset';
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# added April 2018       
# only keep unique AAs (so R, not RRRRR)
# fix April 2018
# white spaces sometime resulted in blank residues...       
      my $AAtarget = "@targetarray" ;
      # remove white-space in the string
      $AAtarget =~ s/\s//g;
      # keep unique residues
      $AAtarget =~ s[(.)(?=.*?\1)][]g;

      my $AAnotarget = "@valuesnotargets" ;
      # remove white-space in the string
      $AAnotarget =~ s/\s//g;
      # keep unique residues
      $AAnotarget =~ s[(.)(?=.*?\1)][]g; # remove all duplicate residues, not just adjacent ones!
# basic	187	other	RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR187SS
# basic	197	other	RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRKRRRRRRRRRRRRRRRRRR197GG
# ok, so 197 has one K-event, 187 only Rs       

       # print "the target is:" . "\t" . $AAtarget . "\n" ;
       # basic    187    other    R     S
       # basic    197    other    K    G
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            open FILE, ">>./results/$filename.txt" ;  #open for write, append since we want to include # comparisons from the start to the end of the @data
        # ORIGINAL: print FILE "NT basic" . "\t" . $position . "\t" . "T other" . "\n";   
       print FILE "basic" . "\t" . $position . "\t" . "other" . "\t" . $AAnotarget . $position . $AAtarget . "\n";
                close FILE
   }
    # ########################################################################################################################
    # ########################################################################################################################

    
    
    # ########################################################################################################################
    # ########################################################################################################################
    
# NT basic, T cysteine 
elsif ($nontargetbaseaccept == 1              # NON-TARGET  
   && $targetcysteineaccept == 1             # TARGET
   )
   {
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# added April 2018       
# only keep unique AAs (so R, not RRRRR)
# fix April 2018
# white spaces sometime resulted in blank residues...       
      my $AAtarget = "@targetarray" ;
      # remove white-space in the string
      $AAtarget =~ s/\s//g;
      # keep unique residues
      $AAtarget =~ s[(.)(?=.*?\1)][]g;

      my $AAnotarget = "@valuesnotargets" ;
      # remove white-space in the string
      $AAnotarget =~ s/\s//g;
      # keep unique residues
      $AAnotarget =~ s[(.)(?=.*?\1)][]g; # remove all duplicate residues, not just adjacent ones!
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~             open FILE, ">>./results/$filename.txt" ;  #open for write, append since we want to include # comparisons from the start to the end of the @data
         print FILE "NT basic" . "\t" . $position . "\t" . "T cysteine" . "\t" . $AAnotarget . $position . $AAtarget . "\n";

         close FILE
      }
# ########################################################################################################################
# ########################################################################################################################

    

    
    
    
    
    
    
    
################################################
# ~NT Acid~
################################################

# NT acidic, T basic 
elsif ($nontargetacidaccept == 1              # NON-TARGET  
   && $targetbaseaccept == 1             # TARGET
   )
   {
#@    	print "\n" . "this residue type is unique to your target species:" ;
#@    	print "NT acidic, T basic!" . "\n" ; 
#@    	print color 'reset';
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# added April 2018       
# only keep unique AAs (so R, not RRRRR)
# fix April 2018
# white spaces sometime resulted in blank residues...       
      my $AAtarget = "@targetarray" ;
      # remove white-space in the string
      $AAtarget =~ s/\s//g;
      # keep unique residues
      $AAtarget =~ s[(.)(?=.*?\1)][]g;

      my $AAnotarget = "@valuesnotargets" ;
      # remove white-space in the string
      $AAnotarget =~ s/\s//g;
      # keep unique residues
      $AAnotarget =~ s[(.)(?=.*?\1)][]g; # remove all duplicate residues, not just adjacent ones!
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                open FILE, ">>./results/$filename.txt" ;  #open for write, append since we want to include # comparisons from the start to the end of the @data
         # ORIGINAL print FILE "NT acidic" . "\t" . $position . "\t" . "T basic" . "\n";   
         print FILE "NT acidic" . "\t" . $position . "\t" . "T basic" . "\t" . $AAnotarget . $position . $AAtarget . "\n";

         close FILE
   
   }
    # ########################################################################################################################
    # ########################################################################################################################


# NT acidic, T other 
elsif ($nontargetacidaccept == 1              # NON-TARGET  
   && $targetotheraccept == 1             # TARGET
   )
   {
#@    	print "\n" . "this residue type is unique to your target species:" ;
#@    	print "NT acidic, T other!" . "\n" ; 
#@    	print color 'reset';
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# added April 2018       
# only keep unique AAs (so R, not RRRRR)
# fix April 2018
# white spaces sometime resulted in blank residues...       
      my $AAtarget = "@targetarray" ;
      # remove white-space in the string
      $AAtarget =~ s/\s//g;
      # keep unique residues
      $AAtarget =~ s[(.)(?=.*?\1)][]g;

      my $AAnotarget = "@valuesnotargets" ;
      # remove white-space in the string
      $AAnotarget =~ s/\s//g;
      # keep unique residues
      $AAnotarget =~ s[(.)(?=.*?\1)][]g; # remove all duplicate residues, not just adjacent ones!
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                open FILE, ">>./results/$filename.txt" ;  #open for write, append since we want to include # comparisons from the start to the end of the @data
         # ORIGINAL print FILE "NT acidic" . "\t" . $position . "\t" . "T other" . "\n";
         print FILE "NT acidic" . "\t" . $position . "\t" . "T other" . "\t" . $AAnotarget . $position . $AAtarget . "\n";
         close FILE
   
   }
    # ########################################################################################################################
    # ########################################################################################################################

    
# NT acidic, T cysteine 
elsif ($nontargetacidaccept == 1              # NON-TARGET  
   && $targetcysteineaccept == 1             # TARGET
   )
   {
   	print "\n" . "this residue type is unique to your target species:" ;
   	print "NT acidic, T cysteine!" . "\n" ; 
   	print color 'reset';
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# added April 2018       
# only keep unique AAs (so R, not RRRRR)
# fix April 2018
# white spaces sometime resulted in blank residues...       
      my $AAtarget = "@targetarray" ;
      # remove white-space in the string
      $AAtarget =~ s/\s//g;
      # keep unique residues
      $AAtarget =~ s[(.)(?=.*?\1)][]g;

      my $AAnotarget = "@valuesnotargets" ;
      # remove white-space in the string
      $AAnotarget =~ s/\s//g;
      # keep unique residues
      $AAnotarget =~ s[(.)(?=.*?\1)][]g; # remove all duplicate residues, not just adjacent ones!
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                open FILE, ">>./results/$filename.txt" ;  #open for write, append since we want to include # comparisons from the start to the end of the @data
         # ORIGINAL:  print FILE "NT acidic" . "\t" . $position . "\t" . "T cysteine" . "\n";   
         print FILE "NT acidic" . "\t" . $position . "\t" . "T cysteine" . "\t" . $AAnotarget . $position . $AAtarget . "\n";

         close FILE
   
   }
    # ########################################################################################################################
    # ########################################################################################################################

    
    
    
    
    
    
    
    
    
    
    
################################################
# ~NT Cysteine~
################################################   

# NT cysteine, T acidic 
elsif ($nontargetcysteineaccept == 1              # NON-TARGET  
   && $targetacidaccept == 1             # TARGET
   )
   {
#@    	print "\n" . "this residue type is unique to your target species:" ;
#@    	print color 'bold blue' ;
#@    	print "NT cysteine, T acidic!" . "\n" ; 
#@    	print color 'reset';
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# added April 2018       
# only keep unique AAs (so R, not RRRRR)
# fix April 2018
# white spaces sometime resulted in blank residues...       
      my $AAtarget = "@targetarray" ;
      # remove white-space in the string
      $AAtarget =~ s/\s//g;
      # keep unique residues
      $AAtarget =~ s[(.)(?=.*?\1)][]g;

      my $AAnotarget = "@valuesnotargets" ;
      # remove white-space in the string
      $AAnotarget =~ s/\s//g;
      # keep unique residues
      $AAnotarget =~ s[(.)(?=.*?\1)][]g; # remove all duplicate residues, not just adjacent ones!
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                   open FILE, ">>./results/$filename.txt" ;  #open for write, append since we want to include # comparisons from the start to the end of the @data
         # ORIGINAL print FILE "NT cysteine" . "\t" . $position . "\t" . "T acidic" . "\n"; 
         print FILE "NT cysteine" . "\t" . $position . "\t" . "T acidic" . "\t" . $AAnotarget . $position . $AAtarget . "\n";
        
         close FILE
   
   }

    # ########################################################################################################################
    # ########################################################################################################################

    
# NT cysteine, T basic 
elsif ($nontargetcysteineaccept == 1              # NON-TARGET  
   && $targetbaseaccept == 1             # TARGET
   )
   {
#@    	print "\n" . "this residue type is unique to your target species:" ;
#@    	print color 'bold blue' ;
#@    	print "cysteine, T basic!" . "\n" ; 
#@    	print color 'reset';
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# added April 2018       
# only keep unique AAs (so R, not RRRRR)
# fix April 2018
# white spaces sometime resulted in blank residues...       
      my $AAtarget = "@targetarray" ;
      # remove white-space in the string
      $AAtarget =~ s/\s//g;
      # keep unique residues
      $AAtarget =~ s[(.)(?=.*?\1)][]g;

      my $AAnotarget = "@valuesnotargets" ;
      # remove white-space in the string
      $AAnotarget =~ s/\s//g;
      # keep unique residues
      $AAnotarget =~ s[(.)(?=.*?\1)][]g; # remove all duplicate residues, not just adjacent ones!
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                   open FILE, ">>./results/$filename.txt" ;  #open for write, append since we want to include # comparisons from the start to the end of the @data
        # ORIGINAL print FILE "NT cysteine" . "\t" . $position . "\t" . "T basic" . "\n"; 
         print FILE "NT cysteine" . "\t" . $position . "\t" . "T basic" . "\t" . $AAnotarget . $position . $AAtarget . "\n";

         close FILE
   
   
   }

# NT cysteine, T other 
elsif ($nontargetcysteineaccept == 1              # NON-TARGET  
   && $targetotheraccept == 1             # TARGET
   )
   {
#@   	print "\n" . "this residue type is unique to your target species:" ;
#@   	print color 'bold blue' ;
#@   	print "NT cysteine, T other!" . "\n" ; 
#@   	print color 'reset';
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# added April 2018       
# only keep unique AAs (so R, not RRRRR)
# fix April 2018
# white spaces sometime resulted in blank residues...       
      my $AAtarget = "@targetarray" ;
      # remove white-space in the string
      $AAtarget =~ s/\s//g;
      # keep unique residues
      $AAtarget =~ s[(.)(?=.*?\1)][]g;

      my $AAnotarget = "@valuesnotargets" ;
      # remove white-space in the string
      $AAnotarget =~ s/\s//g;
      # keep unique residues
      $AAnotarget =~ s[(.)(?=.*?\1)][]g; # remove all duplicate residues, not just adjacent ones!
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                   open FILE, ">>./results/$filename.txt" ;  #open for write, append since we want to include # comparisons from the start to the end of the @data
         # ORIGINAL print FILE "NT cysteine" . "\t" . $position . "\t" . "T other" . "\n";   
          print FILE "NT cysteine" . "\t" . $position . "\t" . "T other" . "\t" . $AAnotarget . $position . $AAtarget . "\n";
         
         close FILE
        
   }

    # ########################################################################################################################
    # ########################################################################################################################

    
    
    
    
    
    
    
    
################################################
# ~NT Other~
################################################   

# NT other, T acidic 
elsif ($nontargetotheraccept == 1              # NON-TARGET  
   && $targetacidaccept == 1             # TARGET
   )
   {
#@    	print "\n" . "this residue type is unique to your target species:" ;
#@    	print color 'bold blue' ;
#@    	print "NT other, T acidic!" . "\n" ; 
#@    	print color 'reset';
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# added April 2018       
# only keep unique AAs (so R, not RRRRR)
# fix April 2018
# white spaces sometime resulted in blank residues...       
      my $AAtarget = "@targetarray" ;
      # remove white-space in the string
      $AAtarget =~ s/\s//g;
      # keep unique residues
      $AAtarget =~ s[(.)(?=.*?\1)][]g;

      my $AAnotarget = "@valuesnotargets" ;
      # remove white-space in the string
      $AAnotarget =~ s/\s//g;
      # keep unique residues
      $AAnotarget =~ s[(.)(?=.*?\1)][]g; # remove all duplicate residues, not just adjacent ones!
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                   open FILE, ">>./results/$filename.txt" ;  #open for write, append since we want to include # comparisons from the start to the end of the @data

          # ORIGINAL:          print FILE "NT other" . "\t" . $position . "\t" . "T acidic" . "\n";   
          print FILE "NT other" . "\t" . $position . "\t" . "T acidic" . "\t" . $AAnotarget . $position . $AAtarget . "\n";


         close FILE
   
   }
    # ########################################################################################################################
    # ########################################################################################################################


# NT other, T basic 
elsif ($nontargetotheraccept == 1              # NON-TARGET  
   && $targetbaseaccept == 1             # TARGET
   )
   {
#@    	print "\n" . "this residue type is unique to your target species:" ;
#@         print color 'bold blue' ;
#@         print "NT other, T basic!" . "\n" ; 
#@         print color 'reset';
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# added April 2018       
# only keep unique AAs (so R, not RRRRR)
# fix April 2018
# white spaces sometime resulted in blank residues...       
      my $AAtarget = "@targetarray" ;
      # remove white-space in the string
      $AAtarget =~ s/\s//g;
      # keep unique residues
      $AAtarget =~ s[(.)(?=.*?\1)][]g;

      my $AAnotarget = "@valuesnotargets" ;
      # remove white-space in the string
      $AAnotarget =~ s/\s//g;
      # keep unique residues
      $AAnotarget =~ s[(.)(?=.*?\1)][]g; # remove all duplicate residues, not just adjacent ones!
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                   open FILE, ">>./results/$filename.txt" ;  #open for write, append since we want to include # comparisons from the start to the end of the @data
        # ORIGINAL: print FILE "NT other" . "\t" . $position . "\t" . "T basic" . "\n";   
                 print FILE "NT other" . "\t" . $position . "\t" . "T basic" . "\t" . $AAnotarget . $position . $AAtarget . "\n";

         close FILE
   
   }
    # ########################################################################################################################
    # ########################################################################################################################

# NT other, T cysteine 
elsif ($nontargetotheraccept == 1              # NON-TARGET  
   && $targetcysteineaccept == 1             # TARGET
   )
   {
   
#@         print "\n" . "this residue type is unique to your target species:" ;
#@         print color 'bold blue' ;
#@    	print "NT other, T other!" . "\n" ; 
#@    	print color 'reset';
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# added April 2018       
# only keep unique AAs (so R, not RRRRR)
# fix April 2018
# white spaces sometime resulted in blank residues...       
      my $AAtarget = "@targetarray" ;
      # remove white-space in the string
      $AAtarget =~ s/\s//g;
      # keep unique residues
      $AAtarget =~ s[(.)(?=.*?\1)][]g;

      my $AAnotarget = "@valuesnotargets" ;
      # remove white-space in the string
      $AAnotarget =~ s/\s//g;
      # keep unique residues
      $AAnotarget =~ s[(.)(?=.*?\1)][]g; # remove all duplicate residues, not just adjacent ones!
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                   open FILE, ">>./results/$filename.txt" ;  #open for write, append since we want to include # comparisons from the start to the end of the @data
         # ORIGINAL: print FILE "NT other" . "\t" . $position . "\t" . "T cysteine" . "\n";   
        print FILE "NT other" . "\t" . $position . "\t" . "T cysteine" . "\t" . $AAnotarget . $position . $AAtarget . "\n";


         close FILE
   
   }
# need position information! 
#@ print "\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#" . "\n" ;

# END OF THE BIG LOOP!
}






system("cd ../") ;
#@ system("rm ./tmp/*.noheader.txt") ;
#@ system("rm ./tmp/transposed/*.txt") ;
#@ system("rm ./tmp/transposed/") ;
system("rmdir \/S\/Q tmp") ;
#@ system("rm *fa.txt") ;
#@ system("rm *fa.noheader.txt") ;

# CLEAR AT THE END
system("cls") ;

# OUTPUT AN ERROR IF NO INPUT SPECIES
# print $inputFASTAtest . "\n" ;
if ($inputFASTAtest == -1) 
{print "\nERROR: No input species given\n" ;}



} # END OF sub_do_input
