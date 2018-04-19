################################################################################################################################################################
# FASTAheadernumber.pl 
# By Inge Seim
# 3/2016
################################################################################################################################################################
#!/usr/bin/env perl
#@ use strict ;
#@ use warnings 

use Getopt::Std ;
use Getopt::Long ;


system("cls") ;
print "\nPlease use the -h (help) option to get usage information.\n" ;



# **********************************************
# declare the perl command line flags/options we want to allow
my %options=();
getopts("ihvj:ln:s:", \%options);
#
##
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
  print "usage: FASTAheadernumber.pl <FASTA>\nSynopsis: use this tool to interrogate FASTA files for the header number for your sample of interest\nOptions:\n-i\t<FASTA> input file\n-h\thelp\n-v\tversion\n";
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
  print "FASTAheadernumber v1.0 (March 2016) by Inge Seim (inge.seim@gmail.com)\n";
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
# my $filename = $i ;
my $filename = $ARGV[0] ;
my $count = 1 ;

# open(FASTA, $filename);
open(FASTA, $filename) || die "\nERROR: Please use the -h (help) option to get usage information.\n";


while(<FASTA>) {
    chomp($_);
    if ($_ =~  m/^>/g ) {
        my $header = $_;
        $header =~ tr/\>/ / ;
#@        print $count++ . "\t" . $header . "\n" ;
        print $count++ . "\t" . $header . "\n" ;

    
# $search = "the";
# s/${search}re/xxx/;

    }
}

# $_ =~ s/<PREF>/ABCD/g;
} # END OF sub_do_input