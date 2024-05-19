#!/usr/bin/perl

use strict;
use warnings;

my $STORAGE_PATH = "/var/www";

my %repos = (
    "ftp.us.debian.org/debian" => "$STORAGE_PATH/debian",
    "ftp.us.debian.org/ubuntu/" => "$STORAGE_PATH/ubuntu",
    "ftp.us.debian.org/tails/" => "$STORAGE_PATH/tails",
);

foreach my $repo (keys %repos) {
    my $dir = $repos{$repo};
    sync_repo($repo, $dir);
}

sub sync_repo {
    my ($repo, $dir) = @_;

    my $rsync_cmd = "rsync " .
                    "--recursive " .
                    "--links " .
                    "--perms " .
                    "--times " .
                    "--compress " .
                    "--progress " .
                    "--delete " .
                    "rsync://$repo $dir";

    print "Syncing $repo to $dir...\n";
    system($rsync_cmd);

    if ($? == -1) {
        print "Failed to execute: $!\n";
    } elsif ($? & 127) {
        printf "Child died with signal %d, %s coredump\n", ($? & 127), ($? & 128) ? 'with' : 'without';
    } else {
        printf "Child exited with value %d\n", $? >> 8;
    }
}
