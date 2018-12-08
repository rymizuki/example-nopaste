package NoPaste::Domain::Scenario::Register;
use feature 'state';
use Mouse;
use Data::Validator;

has register_entity => (
  is => 'ro',
  isa => 'NoPaste::Domain::Entity::Register',
  required => 1,
);

around BUILDARGS => sub {
    my ($orig, $class, @args) = @_;
    my ($register_entity) = @args;
    $class->$orig(
        register_entity => $register_entity,
    );
};

sub run {
    state $v = Data::Validator->new(
        title => 'Str',
        content => 'Str',
    )->with(qw(Method StrictSequenced));
    my ($self, $args) = $v->validate(@_);
    my ($title, $content) = @$args{qw(title content)};

    my $post = $self->register_entity->register(
        title => $title,
        content => $content,
    );

    return $post;
}

1;