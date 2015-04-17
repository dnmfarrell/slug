package Slug::Model::FileSystem;
use strict;
use warnings;
use Pod::PseudoPod::PerlTricks::ToHTML;
use Role::Tiny::With;
use Slug::Article;
use Time::Piece;
use List::Util 'first';

with 'Slug::Model';

sub new
{
  my ($class, $dir_filepath) = @_;

  die "Slug::Model::FilePath->new() requires a readable and executable directory path\n"
    unless $dir_filepath && -d $dir_filepath && -x $dir_filepath;

  return bless { dir_filepath => $dir_filepath }, $class;
}

sub articles
{
  my $self = shift;
  return $self->{articles} if exists $self->{articles};

  my $pod_parser = Pod::PseudoPod::PerlTricks::ToHTML->new;
  $pod_parser->no_whining( ! ( $ENV{DEBUG} || 0 ) );
  $pod_parser->complain_stderr( 1 );

  # articles not yet pulled so read them now
  opendir my $articles_fh, $self->{dir_filepath} or die $!;
  while (my $article_filename = readdir($articles_fh))
  {
    if ($article_filename =~ /\.pod$/)
    {
      my $article_body;
      $pod_parser->output_string( $article_body );
      $pod_parser->parse_file( "$self->{dir_filepath}/$article_filename");

      my @stat = stat("$self->{dir_filepath}/$article_filename");

      push @{$self->{articles}}, Slug::Article->new({
          id            => $article_filename,
          title         => $pod_parser->{stash}{title},
          body          => $article_body,
          publish_date  => $pod_parser->{stash}{publish_date},
          updated       => Time::Piece->strptime($stat[9], '%s'),
          subtitle      => $pod_parser->{stash}{subtitle},
          abstract      => $pod_parser->{stash}{abstract},
          authors       => $pod_parser->{stash}{authors},
        });
    }
  }
  closedir $articles_fh;

  return $self->{articles} || [];
}

sub article
{
  my ($self, $article_id) = @_;
  first { $_->id eq $article_id } @{$self->articles};
}

=head1 NAME

Slug::Model::FileSystem - a filesystem based model that creates L<Slug::Article> objects from files

=cut

1;
