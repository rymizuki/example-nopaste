package NoPaste::Infra::DB::Query::Post;
use parent qw(DBIx::Sunny::Schema);

# override
sub new {
    my ($class, $dbh) = @_;
    return $class->SUPER::new(dbh => $dbh, readonly => 0);
}

__PACKAGE__->query(
    add => (
        id => 'Int',
        title => 'Str',
        content => 'Str',
        _created_at => 'Str',
    ),
    'INSERT INTO post (id, title, content, _created_at) VALUES (last_insert_id(?), ?, ?, ?)',
);

 1;