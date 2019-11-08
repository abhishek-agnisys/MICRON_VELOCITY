#!/usr/bin/perl

use strict;
use warnings;
use File::Spec::Functions;

my $source = shift or &usage();
my $outdir = shift or &usage();

open( my $file, "<$source") or die "Could not open source file. $!";;
open( my $output, ">curr.svh" ) or die $!;

while ( my $line = <$file> ) {
    if ( $line =~ m/START INSTNAME:/g ) {
		my(@output_name) = split(':',$line);
        close($output);
		my $FHNEW = $output_name[1] . "_svheader.svh";
		mkdir($outdir) unless(-d $outdir);
		my $outpath = catfile($outdir,$FHNEW);
		open( $output, ">$outpath" ) or die $!;
		next;
    }
    print {$output} $line;
}
close($output);
system("rm curr.svh");

sub usage() {
print <<EOF;

	PROGRAM NAME: Partition Chip level SV header file into Block level files
	
	DESCRIPTION:
	Takes a Chip level SV header file and creates individual Block level files from it.
	
	EXAMPLE USAGE: BlockSVHeader.pl chip_svheader.svh ids
	
	PARAMETERS:
	1. Source File: File name of the source file (Chip level SV header file) to partition.
	2. Out Directory: Directory where partitioned Block level SV header are generated.

EOF
exit;
}
