package NoPaste::Infra::Fetcher::Posts;
use feature 'state';
use Mouse;

use Data::Validator;

use NoPaste::Domain::Entity::Posts;
use NoPaste::Domain::Entity::Post;
use NoPaste::Domain::Entity::Pager;

with 'NoPaste::Domain::Fetcher::Posts';

has db => (
    is => 'ro',
    isa => 'NoPaste::Infra::DB::Select::Post',
    required => 1,
);

around BUILDARGS => sub {
    my ($orig, $class, @args) = @_;
    my ($db) = @args;
    return $class->$orig(db => $db);
};

sub retrieve {
    state $v = Data::Validator->new(
        page => 'Int',
        limit => 'Int',
    )->with(qw(Method));
    my ($self, $args) = $v->validate(@_);
    my ($page, $limit) = @$args{qw(page limit)};

    my $rows = $self->db->retrieve(
        _deleted_fg => 0,
        limit => ($limit + 1),
        offset => ($limit * ($page - 1)),
    );

    my $has_next = scalar(@$rows) > $limit;
    pop(@$rows) if $has_next;

    my $posts = NoPaste::Domain::Entity::Posts->new(
        rows => [ map {
            NoPaste::Domain::Entity::Post->new(
                id => $_->{id},
                title => $_->{title},
                content => $_->{content},
            )
        } @$rows ],
        pager =>  NoPaste::Domain::Entity::Pager->new(
            current_page => $page,
            has_next => $has_next,
            entries_per_page => $limit,
            entries_on_this_page => scalar(@$rows),
        )
    );

    return $posts;
}

1;