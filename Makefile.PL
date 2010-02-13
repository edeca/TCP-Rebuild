use 5.006;
use strict;
use warnings;

use inc::Module::Install;

name          ('Net-RebuildTCP');
author        ('David Cannings <david@edeca.net>');
license       ('perl');
all_from      ('lib/Net/RebuildTCP.pm');

requires('Net::LibNIDS'	=> '0.02'); # bugfixes
requires('Pod::Usage'	=> '1.00');

#extra_tests;

install_script('bin/tcprebuild');

repository('http://github.com/edeca/HTTP-Sessioniser');
auto_manifest;

WriteAll();
