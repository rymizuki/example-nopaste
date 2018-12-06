use lib qw(lib);
use Mojolicious::Lite -signatures;
use Try::Lite;

use NoPaste::DIContainer;

NoPaste::DIContainer->load(
  namespace => 'NoPaste',
  config_file => './dependency-injection.yml',
);

get '/posts' => sub ($c) {
  my $page = $c->param('page');
  my $posts = container->get('scenario.retrieve')->run($page);

  $c->render(json => $posts->to_json());
};

app->start();