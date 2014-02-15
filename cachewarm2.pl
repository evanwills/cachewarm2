#! /usr/bin/perl

use strict;
use warnings;

use WWW::Mechanize;
use Getopt::Long;
 
my $url;
my $output;
my $mode;
my $file;
my %opt;

my $loopInterval = 5;

GetOptions(
	\%opt,
	"url|u=s",
	"log|l=s",
	"seconds|s=i",
	"minutes|m=i",
	"hours|h=i"
);
  
my $mech = WWW::Mechanize->new( 'autocheck' => 0 );
#my $mech = WWW::Mechanize->new;


if( exists $opt{url} && $opt{url} =~ /https?:\/\//i )
{
	print "Using ".$opt{url}."\n";
}
else
{
	die "you must supply a valid URL\n'".$opt{url}."'\n";
}
print "\n\n\n";


$mode = 'file';

if( exists $opt{file} )
{
#	open $output ,'<' $opt{file} or die "Couldn't open $opt{file}: $!\n"
	print "using file\n";
}
else
{
	$mode = 'screen';
	$output = \*STDOUT;
	print "using screen\n";
}

print "Using $mode to output\n";


#todo  setup handling of script expiry time based on $opt{seconds}, $opt{minutes} or $opt{hours}

#print {$output} "what ever";

print "\n\n\n";

# login to website
$mech->agent_alias('Linux Mozilla');

$mech->get( 'http://www.acu.edu.au/_login' );
$mech->field( 'SQ_LOGIN_USERNAME','evan_admin' );
$mech->field( 'SQ_LOGIN_PASSWORD','T0ri@94' );
$mech->field( 'SQ_LOGIN_REFERRER' , $opt{url} );
$mech->submit();

# get the list of URLs
$mech->get($opt{url});
#print "\nStatus: ".$mech->status()."\n";

my @content = split /^/ , $mech->content();

#while ( $nowtime < $endtime )
#	my $loopstart = $nowtime;
#	my $interval = 0;
	foreach my $line (@content)
	{
		#
		$line =~ s/^\s+|\s+$//g;
		if( $line =~ /^https?:\/\// )
		{
			print "line = '$line'\n";
			$mech->get($line);
			if( $mech->status() == 200 )
			{

				my $xCache = $mech->response->header('X-Cache');
				my $xCacheLookup = $mech->response->header('X-Cache-Lookup');

				my $cache = 0;
				if( $xCache =~ /^MISS/i )
				{
					$cache = 1;
					$xCache = 1;
					print "\nX-Cache was missed\n";
				}
				else
				{
					$xCache = 0;
					print "\nX-Cache was hit\n";
				}
				if( $xCacheLookup =~ /^MISS/i )
				{
					$cache = ( $cache + 1 );
					$xCacheLookup = 1;
					print "\nX-Cache-Lookup was missed\n";
				}
				else
				{
					$xCacheLookup = 0;
					print "\nX-Cache-Lookup was hit\n";
				}
				print "\n\nCache count = $cache \n";
				if( $cache == 2 )
				{
					print "cache was fully warmed\n";
				}
				else
				{
					if( $cache == 1 )
					{
						print "cache was only partially warmed:\n\t";
						if( $xCache == 1 )
						{
							print "only xCache was warmed.\n"
						}
						else
						{
							if( $xCacheLookup == 1 )
							{
								print "only X-Cache-Lookup was warmed\n"
							}
						}
					}
					else
					{
						print "cache was already warmed\n";
					}
				}
			} else {
				print $mech->status()." - dud -	'$line'\n";
			}
			exit;
		}
		# todo setup throttle on process time so only 1 URL is processed every 5 seconds
		# todo exit script after expiry time
		# $nowtime = timestamp();
		# $interval = ( $nowtime - $looptime );
		# if( $interval < $loopInterval )
		# {
		#	$interval = ( $loopinternval - $interval );
		# 	sleep $interval;
		# }
		# $nowtime = timestamp();
		# if ( $nowtime > $endtime )
		# {
		# 	# Time to go. Break out of the foreach loop and the while loop.
		# 	break 2;
		# }
		# $looptime = $nowtime;
	}
#}

