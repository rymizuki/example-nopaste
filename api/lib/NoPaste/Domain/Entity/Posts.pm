package NoPaste::Domain::Entity::Posts;
use Mouse;

has rows => (
  is => 'ro',
  isa => 'ArrayRef[NoPaste::Domain::Entity::Post]',
  default => sub { [] },
);

has pager => (
  is => 'ro',
  isa => 'Maybe[Data::Page::NoTotalEntries]',
);

use JSON::Types;
sub to_json {
    my ($self) = @_;
    return +{
        rows => [ map { $_->to_json() } @{ $self->rows } ],
        pager => $self->pager ? $self->pager->to_json() : undef,
    };
}

1;