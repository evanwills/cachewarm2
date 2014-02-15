#! /usr/bin/perl

use strict
use warnings
use WWW::Mechanize;
use Getopt::Long;
 
my $url;
my $output;
my $mode;
my $file;
my %opt;
GetOptions(
	\%opt,
	"url|u=s",
	"file|f=s",
);
  
my $mech = WWW::Mechanize->new;
if( exists $opt{url} && $opt{url} =~ /https?:\/\//i ) {
	print "Using $url\n";
}
else {
	print "you must supply a valid URL\n";
}

$mech->get($opt{url});

if ($mech->respnse->headers->{interesting_header}) {
	# do stuff
}

$mode = 'file';
if( defined @ARGV[1] && @ARGV[1] eq 'screen' ) {
	$mode = 'screen';
	$output = \*STDOUT;
}
else {
	open $output ,'<' $opt{file} or die "Couldn't open $opt{file}: $!\n"
}

print "Using $mode to output\n";

print {$output} "what ever";
