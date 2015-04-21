package Slug::Controller::Article;
use Mojo::Base 'Mojolicious::Controller';

sub article_headers {
  my $self = shift;
  $self->render(json => $self->app->model->article_headers);
}

sub article {
  my ($self) = @_;
  $self->render(json => $self->app->model->article($self->stash('id')));
}

1;
