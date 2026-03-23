#!/usr/bin/env perl
use strict;
use warnings;
use Getopt::Long;

my $verbose = 0;
GetOptions("verbose|v" => \$verbose);

sub logmsg {
    print STDERR "[DEBUG] $_[0]\n" if $verbose;
}

my @block;
my $has_response = 0;
my $entry_id = '';

while (my $line = <STDIN>) {

    # Normalize line endings
    $line =~ s/\r//;

    # Flexible entry detection
    if ($line =~ /^\s*(\d+)\.\s+.*ZIP.*\d+/i) {

        if (@block) {
            if ($has_response) {
                logmsg("PRINT entry $entry_id");
                print @block;
                print "\n";
            } else {
                logmsg("SKIP entry $entry_id");
            }
        }

        $entry_id = $1;
        logmsg("NEW entry $entry_id");

        @block = ($line);
        $has_response = 0;
    }
    else {
        push @block, $line;

        if ($line =~ /\S/) {
            $has_response = 1;
            logmsg("Entry $entry_id: response detected");
        }
    }
}

# Final block
if (@block) {
    if ($has_response) {
        logmsg("PRINT final entry $entry_id");
        print @block;
    } else {
        logmsg("SKIP final entry $entry_id");
    }
}
