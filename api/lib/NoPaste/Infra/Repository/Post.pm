package NoPaste::Infra::Repository::Post;
use Mouse;
use DateTimeX::Moment;
use Try::Lite;

with 'NoPaste::Domain::Repository::Post';

has db => (
    is => 'ro',
    isa => 'NoPaste::Infra::DB::Query::Post',
    required => 1,
);

around BUILDARGS => sub {
    my ($orig, $class, @args) = @_;
    my ($db) = @args;
    return $class->$orig(db => $db);
};

sub txn_do {
    my ($self, $code) = @_;
    my $txn = $self->db->txn_scope();
    try {
        $code->();
        $txn->commit();
    } '*' => sub {
        my $e = shift;
        $txn->rollback();
        die $e; # rethrow
    };
}

sub get_next_id {
    my $self = shift;
    return (($self->db->last_insert_id || 0) + 1);
}

sub register {
    my ($self, $entity) = @_;
    $self->db->add(
        id => $entity->id,
        title => $entity->title,
        content => $entity->content,
        _created_at => DateTimeX::Moment->now()->iso8601(),
    );
}

1;