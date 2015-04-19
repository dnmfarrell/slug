package Slug::Article;
use strict;
use warnings;
use base qw(Class::Accessor);

Slug::Article->mk_accessors(qw/id title publish_date updated cover_image_url body authors subtitle abstract tags/);

use Data::Structure::Util 'unbless';
use Mojo::JSON 'encode_json';

sub TO_JSON
{
  my $self = shift;
  encode_json(unbless($self));
}

=head1 NAME

Slug::Article - the article class for the Slug blogging app

=head1 AUTHOR

David Farrell (C) 2015

=cut

1;
