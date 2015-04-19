package Slug::Controller::Article;
use Mojo::Base 'Mojolicious::Controller';

sub articles {
  my $self = shift;
  $self->render(json => $self->app->model->articles);
}

sub article {
  my ($self) = @_;
  $self->render(json => $self->app->model->article($self->stash('id')));
}

1;
