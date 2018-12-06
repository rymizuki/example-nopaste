package NoPaste::Domain::Scenario::Retrieve;
use feature 'state';
use Mouse;

has retrieve_entity => (
    is => 'ro',
    isa => 'NoPaste::Domain::Entity::Retrieve',
    required => 1,
);

around BUILDARGS => sub {
    my ($orig, $class, @args) = @_;
    my ($retrieve_entity) = @args;
    $class->$orig(
        retrieve_entity => $retrieve_entity,
    );
};

sub run {
    state $v = Data::Validator->new(
        page => 'Maybe[Int]',
    )->with(qw(Method StrictSequenced));
    my ($self, $args) = $v->validate(@_);
    my $page = $args->{page};

    my $posts = $self->retrieve_entity->retrieve(
        page => $page,
    );

    return $posts;
}

1;