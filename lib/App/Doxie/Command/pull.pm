package App::Doxie::Command::pull;
use Mojo::Base 'Mojolicious::Command';

use Mojo::Util 'getopt';
use Mojo::IOLoop;

has description => 'Pull stored scans from a Doxie scanner and remove from scanner after transfer';
has usage => sub { shift->extract_usage };

sub run {
  my ($self, @args) = @_;

  say $self->app->dumper($self->app->doxie->status) if $self->app->doxie->is_connected;

  Mojo::IOLoop->timer(0 => sub { $self->pull });
  Mojo::IOLoop->recurring(5 => sub { $self->pull });

  # Start event loop if necessary
  Mojo::IOLoop->start unless Mojo::IOLoop->is_running;
}

sub pull {
  my $self = shift;
  $self->app->log->debug('Not connected') and return unless my $doxie = $self->app->doxie->is_connected;
  $self->app->log->debug(sprintf "Checking for scans to pull from %s to local store %s", $doxie->doxie, $doxie->store);
  $self->app->doxie->pull;
}

1;

=encoding utf8

=head1 NAME

App::Doxie::Command::pull - Pull command

=head1 SYNOPSIS

  Usage: APPLICATION pull

    ./myapp.pl pull

  Options:
    -h, --help          Show this summary of available options
        --home <path>   Path to home directory of your application, defaults to
                        the value of MOJO_HOME or auto-detection
    -m, --mode <name>   Operating mode for your application, defaults to the
                        value of MOJO_MODE/PLACK_ENV or "development"
    -v, --verbose       Print return value to STDOUT
    -V                  Print returned data structure to STDOUT

=head1 DESCRIPTION

L<App::Doxie::Command::pull> stored scans from a Doxie scanner and remove from scanner after transfer.

=head1 ATTRIBUTES

L<App::Doxie::Command::pull> inherits all attributes from
L<Mojolicious::Command> and implements the following new ones.

=head2 description

  my $description = $pull->description;
  $pull           = $pull->description('Foo');

Short description of this command, used for the command list.

=head2 usage

  my $usage = $pull->usage;
  $pull     = $pull->usage('Foo');

Usage information for this command, used for the help screen.

=head1 METHODS

L<App::Doxie::Command::pull> inherits all methods from L<Mojolicious::Command>
and implements the following new ones.

=head2 run

  $pull->run(@ARGV);

Run this command.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicious.org>.

=cut
