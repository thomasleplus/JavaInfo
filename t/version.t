#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use File::Temp qw(tempfile);

# JavaInfo is run from the repository root (where `prove -lr t` executes).
my $script = 'JavaInfo';

# Build a minimal Java .class file: 4-byte magic 0xCAFEBABE, then the 2-byte
# minor and 2-byte major version (big-endian), which is all JavaInfo reads.
sub class_file {
    my ( $minor, $major ) = @_;
    my ( $fh, $name ) = tempfile( UNLINK => 1 );
    binmode $fh;
    print $fh pack( 'N N', 0xCAFEBABE, ( $minor << 16 ) | $major );
    close $fh;
    return $name;
}

# Run JavaInfo on a file and return its stdout (stderr discarded).
sub java_info {
    my ($file) = @_;
    my $out = `$^X $script "$file" 2>/dev/null`;
    chomp $out if defined $out;
    return defined $out ? $out : q{};
}

# KNOWN BUGS -- these tests assert the CORRECT expected output and are left
# FAILING on purpose (do not fix the code):
#   1. process_file() reads from the unopened bareword handle FILE
#      (`read(FILE, ...)`, line ~121) instead of the lexical $FILE it opened,
#      so JavaInfo dies with "could not read file" on every input and prints
#      nothing. process_dir() has the same bug (`readdir(DIR)`).
#   2. Once (1) is fixed, the minor version is still wrong:
#      `($fields[1] & 0xFF00) >> 16` is always 0 (should be `>> 16` of the high
#      16 bits, i.e. `$fields[1] >> 16`).

like java_info( class_file( 0, 52 ) ), qr/\bJava 8\b/, 'major 52 => Java 8';
like java_info( class_file( 0, 61 ) ), qr/\bJava 17\b/, 'major 61 => Java 17';
like java_info( class_file( 0, 45 ) ), qr/\bJava 1\.0\.2\b/,
  'major 45 minor 0 => Java 1.0.2';

done_testing;
