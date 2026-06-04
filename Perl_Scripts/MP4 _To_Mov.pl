#!/usr/bin/perl
use strict;
use warnings;
use File::Find;
use Cwd;

my $dir = $ARGV[0] || getcwd();

unless (-d $dir) {
    print "Error: Directory '$dir' does not exist.\n";
    exit 1;
}

find(
    sub {
        return unless /\.mp4$/i;
        
        my $mp4_file = $_;
        my $mov_file = $mp4_file;
        $mov_file =~ s/\.mp4$/.mov/i;
        
        my $mp4_path = $File::Find::name;
        my $mov_path = $mp4_path;
        $mov_path =~ s/\.mp4$/.mov/i;
        
        print "Converting: $mp4_file -> $mov_file\n";
        
        my $cmd = "ffmpeg -i \"$mp4_path\" -c:v libx264 -c:a aac \"$mov_path\"";
        system($cmd);
        
        if ($? == 0) {
            print "  ✓ Conversion successful\n";
        } else {
            print "  ✗ Conversion failed\n";
        }
    },
    $dir
);

print "Conversion complete.\n";
