package Slug;
use Mojo::Base 'Mojolicious';
use Slug::Model::FileSystem;

has 'model';

# This method will run once at server start
sub startup {
  my $self = shift;

  # load config
  $self->plugin(Config => {file => 'slug.conf'});

  # load model
  $self->model(Slug::Model::FileSystem->new($self->config('articles_dir')));

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('article#article_headers');
  $r->get('/article/:id')->to('article#article');
}

1;
