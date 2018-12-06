package NoPaste::Config;
use feature 'state';
use Mouse;
use Data::Validator;

{
  use File::Slurp ();
  use Mojo::Template;
  use YAML::Tiny;

  sub load {
    state $v = Data::Validator->new(
      config_file => 'Str',
    )->with(qw(Method StrictSequenced));
    my ($class, $args) = $v->validate(@_);
    my ($filepath) = $args->{config_file};

    my $template = File::Slurp::read_file($filepath, binmode => ':utf8');
    my $raw = Mojo::Template->new->render($template, +{
      ENV => $ENV,
    });

    my $config = YAML::Tiny->new->read_string($raw);
    my $services = $config->[0]{services};

    return __PACKAGE__->new(services => $services);
  }
}

has services => (
  is => 'ro',
  isa => 'HashRef',
  required => 1,
);

sub get {
  my ($self, $namespace) = @_;
  my @keys = split(/\./, $namespace);

  my $value = $self->services;
  foreach my $key (@keys) {
    $value = $value->{$key};
  }

  return $value;
}

1;
