package Net::RebuildTCP;

use warnings;
use strict;
use Net::LibNIDS 0.02;
use Socket qw(inet_ntoa);
use IO::File;
use Getopt::Long;
use Date::Format;

=head1 NAME

Net::RebuildTCP - Rebuild TCP streams to files on disk.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Rebuilds TCP streams to plain text files on disk, one file per connection.

  use Net::RebuildTCP;

  my $tcp = Net::RebuildTCP->new();
  $tcp->rebuild('/path/to/file.pcap');

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS

=head2 rebuild

  $tcprebuild->rebuild('/path/to/file.pcap');

This method rebuilds a specific pcap file using the currently set options.

Will die if the file is not readable or if Net::LibNIDS cannot be initialised.

=cut

sub rebuild {
  my ($self, $filename) = @_;

  # Exception if we can't read the file
  if (!-r $filename) {
    die "File $filename is not readable";
  }

  # Net::LibNIDS is not currently object oriented, so this is the best we 
  # can do
  Net::LibNIDS::param::set_pcap_filter($self->{filter});
  Net::LibNIDS::param::set_filename($filename);

  if (!Net::LibNIDS::init) {
    die "libnids failed to initialise";
  }

  # Without this closure, the collector has no idea about $self
  my $callback = sub { 
    $self->_collector(@_);
  };
  Net::LibNIDS::tcp_callback($callback);
  Net::LibNIDS::run;

  $self->_cleanup;

  return 1;
}

=head2 new

  my $tcp = Net::RebuildTCP->new;

This method constructs a new Net::RebuildTCP object.  

=cut

sub new {
  my $class    = shift;
  my %defaults = (
    header	=> 0,
    filter	=> ''
  );

  my $self = bless { %defaults, @_ } => $class;

  # Filter should have this added
  #  or (ip[6:2] & 0x1fff != 0)

  $self->{_connections} = {};

  return $self;
}

sub _collector {
  my ($self, $args) = @_;

  print $args->client_ip;
}

# Called when libnids finishes processing a file, to expunge old data and
# close any file handles
sub _cleanup {
  my $self = shift;

  my $connections = $self->{_connections};
  foreach my $key (keys %$connections) {
print "cleaning a connection up\n";
    # undef automatically closes file with IO::File
    undef $$connections{$key}{'fh'};
  }
}

=head1 AUTHOR

David Cannings, C<< <david at edeca.net> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-net-rebuildtcp at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Net-RebuildTCP>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 TODO

Things that would be nice to implement

=over 4

=item * Dump packet data to XML format

=back


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Net::RebuildTCP


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Net-RebuildTCP>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Net-RebuildTCP>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Net-RebuildTCP>

=item * Search CPAN

L<http://search.cpan.org/dist/Net-RebuildTCP/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2010 David Cannings.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Net::RebuildTCP
