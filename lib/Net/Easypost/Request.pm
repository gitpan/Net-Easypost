package Net::Easypost::Request;
{
  $Net::Easypost::Request::VERSION = '0.04';
}

use 5.014;

use Moo::Role;
use Mojo::UserAgent;
use Carp qw(croak);

# ABSTRACT: Request role for Net::Easypost


has ua => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my $ua = Mojo::UserAgent->new();
        $ua->name('Net::Easypost (Perl)/' . $Net::Easypost::VERSION);
    },
);


has endpoint => (
    is => 'ro',
    lazy => 1,
    default => sub { 'www.geteasypost.com/api' }
);


sub post {
    my $self = shift;
    my $operation = shift;
    my $params = shift;

    my $tx = $self->ua->post_form(
        $self->_build_url($operation), 
        $params, 
    );

    if ( ! $tx->success ) {
        my ($err, $code) = $tx->error;
        croak "FATAL: " . $self->endpoint . $operation . " returned $code: $err";
    }

    return $tx->res->json;
}

sub _build_url {
    my $self = shift;
    my $operation = shift;

    return "https://" . $self->access_code . ":@" . $self->endpoint . $operation;
}


sub get {
    my $self = shift;
    my $endpoint = shift;

    my $tx = $self->ua->get($endpoint);

    return $tx->res;
}

1;

__END__
=pod

=head1 NAME

Net::Easypost::Request - Request role for Net::Easypost

=head1 VERSION

version 0.04

=head1 ATTRIBUTES

=head2 ua

A user agent attribute. Defaults to L<Mojo::UserAgent>. 

=head2 endpoint

The Easypost service endpoint. Defaults to 'https://www.geteasypost.com/api'

=head1 METHODS

=head2 post

This method uses the C<ua> attribute to generate a form post request. It takes
an endpoint URI fragment and the parameters to be sent.  It returns JSON deserialized
into Perl structures.

=head2 get

This method uses the C<ua> attribute to generate a GET request to an endpoint. It
takes a complete endpoint URI as its input and returns a L<Mojo::Message::Response>
object.

=head1 AUTHOR

Mark Allen <mrallen1@yahoo.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Mark Allen.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

