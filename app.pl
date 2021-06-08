use lib 'lib';

use Mojolicious::Lite -signatures;
use MTW::User;

get '/login' => sub ($c) {
    # TODO
    # Redirect if logged in
    # Show template if not logged in
};

post '/login' => sub ($c) {
    # TODO
};

get '/home' => sub ($c) {
    # TODO
    # Redirect if not logged in
    # Show template if logged in
};

get '/register' => sub($c) {
    $c->render( template => 'register', errors => {} );
};

post '/register' => sub($c) {
    my $errors = $c->validate;

    if ( keys %$errors ) {
        $c->stash( errors => $errors );
        $c->render( template => 'register' );
        return;
    }

    MTW::User::add(
        $c->param('username'),
        $c->param('email'), $c->param('password'),
    );

    # Set cookies
    # TODO Make more secure
    $c->cookie( username => $c->param('username') );
    $c->cookie( email    => $c->param('email') );

    $c->redirect_to('/user');
};

helper validate => sub ($c) {
    my %errors;
    my %params = $c->req->body_params->to_hash->%*;

    for my $param_key ( keys %params ) {
        my $param_value = $params{$param_key};

        $param_value =~ s/^\s+//;
        $param_value =~ s/\s+$//;

        $errors{"error_empty_$param_key"} = 1 unless $param_value;
    }

    $errors{"error_mismatched_passwords"} = 1
        if $c->param('password') ne $c->param('password_confirm');

    return \%errors;
};

app->start;
