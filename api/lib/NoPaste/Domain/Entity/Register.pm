package NoPaste::Domain::Entity::Register;
use feature 'state';
use Mouse;
use Data::Validator;

use NoPaste::Domain::Entity::Post;

has repository => (
    is => 'ro',
    does => 'NoPaste::Domain::Repository::Post',
    required => 1,
);

around BUILDARGS => sub {
    my ($orig, $class, @args) = @_;
    my ($repository) = @args;
    return $class->$orig(repository => $repository);
};

sub register {
    state $v = Data::Validator->new(
        title => 'Str',
        content => 'Str',
    )->with(qw(Method));
    my ($self, $args) = $v->validate(@_);
    my ($title, $content) = @$args{qw(title content)};

    my $post;
    $self->repository->txn_do(sub {
        my $id = $self->repository->get_next_id();
        $post = NoPaste::Domain::Entity::Post->new(
            id => $id,
            title => $title,
            content => $content,
        );
        $self->repository->register($post);
    });

    return $post;
}


1;