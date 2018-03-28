################################################################################################################################################################
# FASTAheadernumber.pl 
# By Inge Seim
# 3/2016
################################################################################################################################################################
#!/usr/bin/env perl
#@ use strict ;
#@ use warnings 

use Getopt::Long ;
my $v = '';	# option variable with default value (false)
$v = print("FASTAheadernumber v1.0 (March 2016) by Inge Seim; inge.seim@gmail.com" . "\n") ;



my $filename = $ARGV[0] ;
my $count = 1 ;
print "#########################################################################################################" . "\n" ; 
print "use this tool to interrogate FASTA files for the header number for your sample of interest" . "\n" ; 
print "usage FASTAheadernumber <FASTA FILE>" . "\n" ; 
print "#########################################################################################################" . "\n" ; 




open(FASTA, $filename);
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