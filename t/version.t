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
    print $fh pack( 'N n n', 0xCAFEBABE, $minor, $major );
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

like java_info( class_file( 0, 52 ) ), qr/\bJava 8\b/, 'major 52 => Java 8';
like java_info( class_file( 0, 61 ) ), qr/\bJava 17\b/, 'major 61 => Java 17';
like java_info( class_file( 0, 45 ) ), qr/\bJava 1\.0\.2\b/,
  'major 45 minor 0 => Java 1.0.2';

done_testing;
