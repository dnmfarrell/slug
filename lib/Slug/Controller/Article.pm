package Slug::Controller::Article;
use Mojo::Base 'Mojolicious::Controller';
use Slug::Model::FileSystem;


sub articles {
  my $self = shift;
  my $model = Slug::Model::FileSystem->new('test-corpus');

  $self->stash(articles => $model->articles);
  $self->render(template => 'articles', format => 'html', handler => 'ep');
}

1;
