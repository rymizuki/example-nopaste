package NoPaste::Domain::Repository::Post;
use Mouse::Role;

requires qw(
    txn_do
    get_next_id
    register
);

1;