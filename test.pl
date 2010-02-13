#!/usr/bin/perl

use strict;
use warnings;
use Net::RebuildTCP;

my $rebuilder = Net::RebuildTCP->new(header => 1);
$rebuilder->rebuild('foo2.pcap');
