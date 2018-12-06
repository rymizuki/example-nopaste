package NoPaste::DIContainer;
use Exporter::Lite;
use DDP;

our @EXPORT = qw(
  container
);

my $_instance_cache;
sub load {
  my ($class, %args) = @_; 
  if ($_instance_cache) {
    die sprintf('"%s" already loaded.', __PACKAGE__);
  }
  $_instance_cache //= __PACKAGE__->new(namespace => $args{namespace});
  $_instance_cache->_load_yaml($args{config_file});
}

sub container {
  return $_instance_cache;
}

use Mojo::Base -base;
use Mojo::Loader ();
use YAML::Tiny;
use Scalar::Util;

has 'namespace';
has 'services';

sub get {
  my ($self, $key) = @_;
  my $cache_key = $self->_gen_cache_key($key);
  return $self->{$cache_key} //= $self->build($key);
}

sub build {
  my ($self, $key) = @_;
  my $definition = $self->{services}{$key};
  my ($name, $method, $args) = @$definition{qw(class method args)};
  die "dependency name undefined!" unless $name;

  my $class = $self->_load_class($name);
  $method ||= 'new';
  my @args = map { $_ =~ m{^@(.+)$} ? $self->get($1) : $_ } @$args;

  p(@args);
  my $instance = $class->$method(@args);
  p($instance);

  return $instance;
}

sub _gen_cache_key {
  my ($self, $key) = @_;
  return "__cache_${key}";
}

sub _load_class {
  my ($self, $name) = @_;
  my $class = $name =~ m{^\+(.+)$} ? $1 :
              $name =~ m{^@(.+)$} ? $self->get($1) :
              sprintf('%s::%s', $self->namespace, $name);
  if (!Scalar::Util::blessed($class)) {
    if (my $e = Mojo::Loader::load_class($class)) {
      die ref $e ? "Exception: $e" : "'${class}' class not found.";
    }
  }
  return $class;
}

sub _load_yaml {
  my ($self, $filepath) = @_;
  my $config = YAML::Tiny->new->read($filepath);
  my $services = $config->[0]{services};
  foreach my $key (keys %$services) {
    $self->{services}{$key} = $services->{$key};
  }
}

1;