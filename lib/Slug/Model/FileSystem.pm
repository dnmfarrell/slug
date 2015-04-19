package Slug::Model::FileSystem;
use strict;
use warnings;
use 5.20.0;
use feature qw/postderef signatures/;
no warnings 'experimental';
use Pod::PseudoPod::PerlTricks::ToHTML;
use Role::Tiny::With;
use Slug::Article;
use Slug::Author;
use Time::Piece;
use List::Util 'first';
use Digest::MD5 'md5_base64';

with 'Slug::Model';

sub new  ($class, $dir_filepath)
{
  die "Slug::Model::FilePath->new() requires a readable and executable directory path\n"
    unless -d $dir_filepath && -x $dir_filepath;

  return bless { dir_filepath => $dir_filepath }, $class;
}

sub articles ($self)
{
  return $self->{articles} if exists $self->{articles};


  # articles not yet pulled so read them now
  opendir my $articles_fh, $self->{dir_filepath} or die $!;
  while (my $article_filename = readdir($articles_fh))
  {
    if ($article_filename =~ /\.pod$/)
    {
      my $article_body;
      my $pod_parser = Pod::PseudoPod::PerlTricks::ToHTML->new;
      $pod_parser->no_whining( ! ( $ENV{DEBUG} || 0 ) );
      $pod_parser->complain_stderr( 1 );
      $pod_parser->output_string( $article_body );
      $pod_parser->parse_file( "$self->{dir_filepath}/$article_filename");

      my @stat = stat("$self->{dir_filepath}/$article_filename");

      # create author objects
      my @author_objects = ();
      for ($pod_parser->get_stash('authors')->@*)
      {
        push @author_objects, Slug::Author->new($_);
      }

      push @{$self->{articles}}, Slug::Article->new({
          id            => md5_base64($article_filename),
          title         => $pod_parser->get_stash('title'),
          body          => $article_body,
          publish_date  => $pod_parser->get_stash('publish_date'),
          updated       => Time::Piece->strptime($stat[9], '%s')->datetime,
          subtitle      => $pod_parser->get_stash('subtitle'),
          abstract      => $pod_parser->get_stash('abstract'),
          authors       => \@author_objects,
        });
    }
  }
  closedir $articles_fh;
  return $self->{articles} || [];
}

sub article ($self, $article_id='R6u1mv2lya+MYM12iYAGQg')
{
  first { $_->id eq $article_id } $self->articles->@*;
}

=head1 NAME

Slug::Model::FileSystem - a filesystem based model that creates L<Slug::Article> objects from pod files

=cut

=head1 AUTHOR

David Farrell (C) 2015

=cut

1;
