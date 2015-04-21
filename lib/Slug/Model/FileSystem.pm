package Slug::Model::FileSystem;
use strict;
use warnings;
use 5.20.0;
use feature qw/postderef signatures/;
no warnings 'experimental';
use Pod::PseudoPod::PerlTricks::ToHTML;
use Role::Tiny::With;
use Slug::Article;
use Slug::Article::Header;
use Slug::Author;
use Time::Piece;
use List::Util 'first';
use Digest::MD5 'md5_base64';

with 'Slug::Model';

sub new ($class, $dir_filepath)
{
  die "Slug::Model::FilePath->new() requires a readable and executable directory path\n"
    unless -d $dir_filepath && -x $dir_filepath;

  return bless { dir_filepath => $dir_filepath }, $class;
}

sub article_headers ($self)
{
  # lazy, "immutable"
  return $self->{article_headers} if exists $self->{article_headers};

  my @article_headers = ();

  # article headers not yet pulled so read them now
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

      push @article_headers, Slug::Article::Header->new({
          id            => md5_base64($article_filename),
          title         => $pod_parser->get_stash('title'),
          publish_date  => $pod_parser->get_stash('publish_date'),
          updated       => Time::Piece->strptime($stat[9], '%s')->datetime,
          subtitle      => $pod_parser->get_stash('subtitle'),
          abstract      => $pod_parser->get_stash('abstract'),
          authors       => \@author_objects,
        });
    }
  }
  closedir $articles_fh;
  $self->{article_headers} = \@article_headers;
  return $self->{article_headers};
}

sub article ($self, $article_id)
{
  my $header = first { $_->{id} eq $article_id } $self->{article_headers}->@*;

  opendir my $articles_fh, $self->{dir_filepath} or die $!;
  while (my $article_filename = readdir($articles_fh))
  {
    if (md5_base64($article_filename) eq $article_id)
    {
      my $article_body;
      my $pod_parser = Pod::PseudoPod::PerlTricks::ToHTML->new;
      $pod_parser->no_whining( ! ( $ENV{DEBUG} || 0 ) );
      $pod_parser->complain_stderr( 1 );
      $pod_parser->output_string( $article_body );
      $pod_parser->parse_file( "$self->{dir_filepath}/$article_filename");

      return Slug::Article->new({
        header  => $header,
        body    => $article_body,
      });
    }
  }
  die "Article with id $article_id does not exist!";
}

=head1 NAME

Slug::Model::FileSystem - a filesystem based model that creates articles from pod files

=cut

=head1 AUTHOR

David Farrell (C) 2015

=cut

1;
