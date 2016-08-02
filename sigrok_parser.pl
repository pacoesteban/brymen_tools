#!/usr/bin/env perl

use v5.24;
use Getopt::Long;
use Pod::Usage qw(pod2usage);

my $count = 1;
my ( $format, $time_format );
my $header_format = "Id,Date,Value,Unit,Current,Info";
my ( $file, $pretty_time, $headers, $help, $verbose );
GetOptions(
    'file=s'      => \$file,
    'csv_headers' => \$headers,
    'time'        => \$pretty_time,
    'help|?'      => \$help,
    'verbose'     => \$verbose
) or pod2usage(2);

pod2usage( -verbose => 0, -exitval => 1 ) if ($help);

my $filename = $file || 'brymen_reading_' . time . '.csv';
say "Writing to $filename\n" if ($verbose);
open( my $fh, '>', $filename )
  or die "Could not open file $filename : $!";

if ($headers) {
    say $header_format if ($verbose);
    say $fh $header_format;
}

while (<>) {
m/P1: (?<value>[-+]?[0-9]*\.?[0-9]*|inf|nan) (?<unit>V|F|A|Ω|°C|°F) ?(?<current>DC|AC)? ?(?<info>AUTO|DIODE)?/;
    if ($pretty_time) {
        $time_format = localtime;
    }
    else {
        $time_format = time;
    }
    $format =
        $count . ","
      . $time_format . ","
      . $+{value} . ","
      . $+{unit} . ","
      . $+{current} . ","
      . $+{info};
    say $format if ($verbose);
    say $fh $format;
    $count++;
}
close $fh;

__END__
 
=encoding utf8

=head1 NAME
 
sigrok_parser.pl - A simple parser for the Brymen data collected by sigrok. Turns data into CSV.
 
=head1 SYNOPSIS
 
sigrok_parser.pl [options] [filename]
 
 Options:
   -h --help -?         brief help message. perldoc sigrok_parser.pl for more info
   -f --file FILENAME   filename to write CSV data to (defaults to brymen_reading_$TIMESTAMP.csv)
   -t --time            pretty date/time (it prints seconds since EPOCH if not present)
   -c --csv_headers     Also prints Headers on the CSV file.
   -v --verbose         Verbose, it prints the content of the csv file to STDOUT too.
 
=head1 OPTIONS
 
=over 4
 
=item B<-h --help -?>
 
Print a brief help message and exits.
 
=item B<-f --file FILENAME>
 
Name of the file the CSV data will be written to.

=item B<-t --time>

Prints Date and Time in a human readable format. By default it prints seconds since Epoch.

=item B<-c --csv_headers>

Prints headers on the csv output.

=item B<-v --verbose>

More verbose. It prints the parsed content to STDOUT in real time. By default is silent.
 
=back
 
=head1 DESCRIPTION
 
B<This program> will read the given input file(s) (or STDIN) of sigrok output format 
for Brymen BM257s, parse it, and write it into a CSV file.

Example of real usage:

 $ sigrok-cli --driver=brymen-bm25x:conn=/dev/ttyUSB0 --continuous \ 
    | ./sigrok_parser.p

Known formats are:

  P1: 0.000000 V DC AUTO
  P1: 0.020000 V AC AUTO
  P1: inf Ω AUTO
  P1: 908000.000000 Ω AUTO
  P1: 0.000000 F AUTO
  P1: inf V DIODE
  P1: 0.659000 V DIODE
 
=cut
