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
  $config{class} ||= 'Net::RebuildTCP';
  my $version;

  GetOptions(
    "h|help"      => sub { pod2usage(1); },
    "v|version"   => sub { $version = 1 },
#    "l|local=s"   => \$config{local},
#    "r|remote=s"  => \$config{remote},
#    "d|dirmode=s" => \$config{dirmode},
#    "qq"          => sub { $config{quiet} = 2; $config{errors} = 0; },
#    'offline'     => \$config{offline},
#    "q+" => \$config{quiet},
#    "f+" => \$config{force},
#    "p+" => \$config{perl},
#    "x+" => \$config{exact_mirror},
  ) or pod2usage(2);

  eval "require $config{class}";
  die $@ if $@;

  _display_version($config{class}) if $version;
  pod2usage(2) unless $config{local} and $config{remote};

  $|++;

#  $config{class}->update_mirror(
#    remote  => $config{remote},
#    local   => $config{local},
#    trace   => (not $config{quiet}),
#    force   => $config{force},
#    offline => $config{offline},
#    also_mirror    => $config{also_mirror},
#    exact_mirror   => $config{exact_mirror},
#    module_filters => $config{module_filters},
#    path_filters   => $config{path_filters},
#    skip_cleanup   => $config{skip_cleanup},
#    skip_perl      => (not $config{perl}),
#    (defined $config{dirmode} ? (dirmode => $config{dirmode}) : ()),
#    (defined $config{errors}  ? (errors  => $config{errors})  : ()),
#  );
}

=head1 SEE ALSO 

=head1 AUTHORS

David Cannings, <F<david at edeca.net>>

Copyright 2010, released under the same terms as Perl itself.

=cut

1;

