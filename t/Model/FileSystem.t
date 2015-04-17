use Test::More;
use Test::Exception;
use strict;
use warnings;

use_ok 'Slug::Model::FileSystem';
dies_ok { Slug::Model::FileSystem->new('test-cous') } 'dies on false dir path';
ok my $model = Slug::Model::FileSystem->new('test-corpus'), 'constructor';
ok my $articles = $model->articles(), 'get articles';

for (@$articles)
{
  ok $_->isa('Slug::Article'), 'Should be a Slug::Article object';
}

ok my $article = $model->article('guard.pod'), 'get guard.pod article';
ok $article->isa('Slug::Article'), 'article Should be a Slug::Article object';


done_testing;
