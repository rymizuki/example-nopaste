package NoPaste::Domain::Entity::Retrieve;
use feature 'state';
use Mouse;
use NoPaste::Domain::Entity::Posts;
use NoPaste::Domain::Entity::Pager;

has fetcher => (
    is => 'ro',
    does => 'NoPaste::Domain::Fetcher::Posts',
    required => 1,
);

has limit => (
    is => 'ro',
    isa => 'Int',
    default => 10,
);

around BUILDARGS => sub {
    my ($orig, $class, @args) = @_;
    my ($fetcher) = @args;
    return $class->$orig(fetcher => $fetcher);
};

sub retrieve {
    state $v = Data::Validator->new(
        page => 'Maybe[Int]',
    )->with(qw(Method));
    my ($self, $args) = $v->validate(@_);

    my $page = $args->{page} || 1;
    my $limit = $self->limit;

    # リストを取得する
    my $posts = $self->fetcher->retrieve(
        page => $page,
        limit => $limit,
    );
    return $posts;
}

1;