use Test::More;
use Time::Piece;
use_ok 'Slug::Article';

ok my $article =  Slug::Article->new({
    id              => '123.pod',
    title           => 'A new blog post',
    body            => 'The body of an article is the main text of an article',
    author_name     => 'John Smith',
    author_bio      => 'John Smith is a veteran blogger who lives in New San Francisco with his family',
    tags            => [ qw/lifestyle design living eco/ ],
    created         => gmtime,
    updated         => gmtime,
    published       => gmtime,
    cover_image_url => 'http://www.imager.com/123.png',
    author_image_url=> 'http://galleo.io/j_smith.jpg',
  }), 'Constructor';

done_testing;
