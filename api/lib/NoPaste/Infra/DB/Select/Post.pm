package NoPaste::Infra::DB::Select::Post;
use parent qw(DBIx::Sunny::Schema);

# override
sub new {
    my ($class, $dbh) = @_;
    return $class->SUPER::new(dbh => $dbh, readonly => 1);
}

__PACKAGE__->select_all(
    'retrieve' => (
        _deleted_fg => 'Bool',
        offset => 'Int',
        limit => 'Int',
    ),
    'SELECT * FROM post WHERE _deleted_fg = ? ORDER BY _created_at DESC LIMIT ?, ?'
);

1;