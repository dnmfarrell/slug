package Slug::Author;
use strict;
use warnings;
use base qw(Class::Accessor);

Slug::Author->mk_accessors(qw/name bio picture/);

use Data::Structure::Util 'unbless';
use Mojo::JSON 'encode_json';

sub TO_JSON
{
  my $self = shift;
  encode_json(unbless($self));
}

=head1 NAME

Slug::Author - the author class for the Slug blogging app

=head1 AUTHOR

David Farrell (C) 2015

=cut

1;
