package NoPaste::Domain::Entity::Pager;
use parent qw(Data::Page::NoTotalEntries);

use JSON::Types;
sub to_json {
    my ($self, ) = @_;
    return +{
        current_page => number $self->current_page,
        entries_per_page => number $self->entries_per_page,
        entries_on_this_page => number $self->entries_on_this_page,
        has_next => bool $self->has_next,
    }
}

1;