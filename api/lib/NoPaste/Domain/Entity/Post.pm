package NoPaste::Domain::Entity::Post;
use Mouse;

has id => (
    is => 'ro',
    isa => 'Int',
);

has title => (
    is => 'ro',
    isa => 'Str',
);

has content => (
    is => 'ro',
    isa => 'Str',
);

use JSON::Types;
sub to_json {
    my ($self) = @_;
    return +{
        id => number($self->id),
        title => string($self->title),
        content => string($self->content),
    };
}

1;