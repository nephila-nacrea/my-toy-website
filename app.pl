use lib 'lib';

use Mojolicious::Lite -signatures;
use MTW::User;

get '/' => sub($c) {
    $c->redirect_to('/form');
};

get '/form' => sub($c) {
    $c->render( template => 'form', errors => {} );
};

post '/form' => sub($c) {
    my $errors = $c->validate;

    if ( keys %$errors ) {
        warn "ERRORS";
        $c->stash( errors => $errors );
        $c->render( template => 'form' );
        return;
    }

    MTW::User::add( $c->param('username'), $c->param('email') );

    $c->redirect_to('/form');
};

helper validate => sub ($c) {
    my %errors;
    my %params = $c->req->body_params->to_hash->%*;

    for my $param_key ( keys %params ) {
        my $param_value = $params{$param_key};

        warn "$param_key: $param_value";

        $param_value =~ s/^\s+//;
        $param_value =~ s/\s+$//;

        $errors{"error_empty_$param_key"} = 1 unless $param_value;
    }
    use Data::Dumper;
    $Data::Dumper::Indent   = 2;
    $Data::Dumper::Maxdepth = 3;
    $Data::Dumper::Sortkeys = 1;
    warn Dumper \%errors;

    return \%errors;
};

app->start;
