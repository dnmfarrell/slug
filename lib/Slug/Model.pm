package Slug::Model;
use strict;
use warnings;
use Role::Tiny;

requires qw/article_headers article/;

=head1 NAME

Slug::Model - the blog backend for Slug blogging app

=head1 DESCRIPTION

Slug::Model is just a role that defines the interface that any Slug::Model should provide. It requires two methods:

=over 4

=item * article ($article_id)

Returns a L<Slug::Article> object

=item * article_headers

Returns an arrayref of all L<Slug::Article::Header> objects

=back

=head1 AUTHOR

David Farrell (C) 2015

=cut

1;
