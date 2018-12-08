use lib qw(lib);
use Mojolicious::Lite -signatures;
use Try::Lite;

use NoPaste::DIContainer;

NoPaste::DIContainer->load(
  namespace => 'NoPaste',
  config_file => './dependency-injection.yml',
);

post '/posts' => sub ($c) {
  my $title = $c->param('title');
  my $content = $c->param('content');
  my $post = container->get('scenario.register')->run($title, $content);

  $c->render(json => +{ post => $post->to_json() });
};

get '/posts' => sub ($c) {
  my $page = $c->param('page');
  my $posts = container->get('scenario.retrieve')->run($page);

  $c->render(json => $posts->to_json());
};

app->start();