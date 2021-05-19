use Mojo::File 'curfile';
use Test::Mojo;
use Test2::V0;

my $script = curfile->dirname->sibling('app.pl');

my $t = Test::Mojo->new($script);

$t->get_ok('/');

$t->get_ok('/form');

$t->post_ok('/form');

done_testing;

# TODO Test utf8
# test validation of each param
# test redirect for successful post, re-render for failure
