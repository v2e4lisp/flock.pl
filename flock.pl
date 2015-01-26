#!/usr/bin/env perl

use warnings;
use strict;
use Fcntl qw(:flock);

my ($lock_file, $command, @args) = @ARGV;

open(my $fd, ">", $lock_file) or
    die "Failed to open $lock_file";

flock($fd, LOCK_NB | LOCK_EX) or
    die "Cannot hold the lock $lock_file";

my $pid = fork;
if ($pid == -1) {
    die "Failed to fork a child process";
}

if ($pid) {
    wait;
} else {
    close $fd;
    exec $command, @args;
}

END {
    if ($fd) {
        close $fd;
    }
}


