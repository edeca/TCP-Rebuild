use strict;
use warnings;

package Net::RebuildTCP::App;

=head1 NAME

Net::RebuildTCP::App - the guts of the tcprebuild command

=head1 SYNOPSIS

  #!/usr/bin/perl
  use Net::RebuildTCP::App;
  Net::RebuildTCP::App->run;

=cut

use File::Spec;
use Getopt::Long qw(GetOptions);
use Pod::Usage;

sub _display_version {
  my $class = shift;
  no strict 'refs';
  print "tcprebuild",
    ($class ne 'Net::RebuildTCP' ? ' (from Net::RebuildTCP)' : q{}),
    ", powered by $class ", $class->VERSION, "\n\n";
  exit;
}

=head2 run

This method is called by F<tcprebuild> to do all the work.  Relying on it doing
something sensible is plain silly.

=cut

sub run {
  my %config;
  $config{class} = 'Net::RebuildTCP';
  my $version;

  $config{filter} = '';
  $config{separator} = 0;

  GetOptions(
    "h|help"      => sub { pod2usage(1); },
    "v|version"   => sub { $version = 1 },
    "i|infile=s"  => \$config{infile},
    "f|filter=s"  => \$config{filter},
    "s|separator" => \$config{separator}
  ) or pod2usage(2);

  eval "require $config{class}";
  die $@ if $@;

  _display_version($config{class}) if $version;
  pod2usage(2) unless $config{infile};

  # Flush output after writes
  $|++;

  my $o = $config{class}->new(
    separator	=> $config{separator},
    filter	=> $config{filter}
  );

  $o->rebuild($config{infile});
}

=head1 SEE ALSO 

=head1 AUTHORS

David Cannings, <F<david at edeca.net>>

Copyright 2010, released under the same terms as Perl itself.

=cut

1;

