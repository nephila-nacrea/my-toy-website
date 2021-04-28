use Mojolicious::Lite -signatures;

get '/' => sub($c) {
    $c->redirect_to('/form');
};

get '/form' => 'form';

post '/form' => sub($c) {
    $c->redirect_to('/form');
};

app->start;
