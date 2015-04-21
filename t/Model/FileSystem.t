use Test::More;
use Test::Exception;
use strict;
use warnings;

use_ok 'Slug::Model::FileSystem';
dies_ok { Slug::Model::FileSystem->new('test-cous') } 'dies on false dir path';
ok my $model = Slug::Model::FileSystem->new('test-corpus'), 'constructor';
ok my $article_headers = $model->article_headers(), 'get article headers';

for (@$article_headers)
{
  ok $_->isa('Slug::Article::Header'), 'Should be a Slug::Article::Header object';
  ok my $article = $model->article($_->{id}), 'get random article';
  ok $article->isa('Slug::Article'), 'article Should be a Slug::Article object';
}

done_testing;
