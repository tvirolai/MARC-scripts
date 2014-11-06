#!/usr/bin/perl -w

# Given files with Melinda ids, grep corresponding sequential data from alina dumps

use strict;
use warnings;
use IO::Handle;
use open qw(:std :utf8);

STDERR->autoflush(1);
die "Usage: $0 file_melinda_ids.bib .. fileN\n" unless(@ARGV);
sub debug { printf STDERR shift, @_; }

my $stat = {};
my $type = "seq";
my $files = {};

# Scan files
foreach my $file (@ARGV) {
    my $count;
    if(-s "$file.$type") {
        debug("- Skipping source, target already exists : $file.$type\n");
        next;
    }
    $files->{$file}++;
    open(IN, "<", $file) || die "Failed to read from <$file> : $!\n";
    while(<IN>) {
        if(m|^\s*([0-9]+)|) {
            push(@{ $stat->{sprintf("%09d", $1)}}, $file);
            $count++;
        } else {
            debug("PARSER $file : $_\n");
        }
    }
    close(IN);
    debug("- Parsed %6d ids for target %s.%s\n", $count, $file, $type);
}

exit debug("- Finished : no targets, nothing to scan\n") unless(scalar(keys %$files) >= 1);

my $handle = {};
foreach my $file (keys %$files) {
    open($handle->{$file}, ">", "$file.$type") or die "Failed to open for writing <$file> : $!\n";
}


my $out = {};
foreach my $index (00..06) {
    my $count = 0;
    my $seen  = {};
    my $line  = 0;

    my $dump = sprintf("/home/lamyyry/alina%02d.seq", $index);
    debug("- Scanning %s : ", $dump);
    open(FH, "<", $dump) || die "Failed top read from <$dump> : $!\n";
    while(<FH>) {
        $line++;
        if(m|^([0-9]+)| && $stat->{$1}) {
            $count++;
            foreach my $file (@{ $stat->{$1} }) {
                print { $handle->{$file} } $_;
                $seen->{$file}++;
            }
        }
    }
    #$_->flush() foreach(values %$handles);
    debug("%8d unique lines to %2d of %2d files\n", $count, scalar(keys %$seen), scalar(keys %$files));;
    close(FH);
}
debug("- Finished\n");


# Local Variables:
# tab-width: 4
# cperl-indent-level: 4
# perl-indent-level: 4
# indent-tabs-mode: nil
# End:
