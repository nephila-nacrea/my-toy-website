use lib 'lib';

use Mojolicious::Lite -signatures;
use MTW::User;

get '/login' => sub ($c) {
    if ( $c->user_creds->{username} ) {
        $c->redirect_to('/home');
    }

    $c->render( template => 'login', errors => {} );
};

post '/login' => sub ($c) {
    my $user
        = MTW::User->new->get( $c->param('email'), $c->param('password') );

    if ( my $err = $user->{error} ) {
        $c->render( template => 'login', errors => { $err => 1 } );
        return;
    }

    # Set cookies
    # TODO Make more secure
    $c->cookie( username => $user->{username} );
    $c->cookie( email    => $user->{email} );

    $c->redirect_to('/home');
};

get '/logout' => sub ($c) {
    $c->cookie( username => undef );
    $c->cookie( email    => undef );

    $c->redirect_to('/login');
};

get '/home' => sub ($c) {
    if ( !$c->user_creds->{username} ) {
        $c->redirect_to('/login');
    }

    $c->render( template => 'home', errors => {} );
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

    MTW::User->new->add(
        $c->param('username'),
        $c->param('email'), $c->param('password'),
    );

    # Set cookies
    # TODO Make more secure
    $c->cookie( username => $c->param('username') );
    $c->cookie( email    => $c->param('email') );

    $c->redirect_to('/home');
};

helper user_creds => sub ($c) {
    return {
        username => $c->cookie('username'),
        email    => $c->cookie('email'),
    };
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

    $errors{'error_mismatched_passwords'} = 1
        if $c->param('password') ne $c->param('password_confirm');

    return \%errors;
};

app->start;
