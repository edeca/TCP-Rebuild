#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Net::RebuildTCP' ) || print "Bail out!
";
}

diag( "Testing Net::RebuildTCP $Net::RebuildTCP::VERSION, Perl $], $^X" );
