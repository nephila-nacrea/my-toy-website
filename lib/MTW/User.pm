package MTW::User;

use strict;
use warnings;

use DBI;
use Moo;

use feature 'signatures';
use namespace::clean;

has dbh => (
    is      => 'ro',
    default => sub {
        DBI->connect(
            'dbi:SQLite:dbname=/home/vmihell-hale/my-toy-website/my_toy_db');
    },
);

# sub _build_dbh ($self) {
#     $self->dbh(
#         DBI->connect(
#             'dbi:SQLite:dbname=/home/vmihell-hale/my-toy-website/my_toy_db')
#     );
# }

sub add ( $self, $username, $email, $password ) {
    $self->dbh->do(
        'INSERT INTO users
                ( username, email, created )
         VALUES ( ?,        ?,     ?       )',
        undef,
        $username,
        $email,
        time,
    );
}

sub get ( $self, $email, $password ) {
    my $res = $self->dbh->selectrow_arrayref(
        'SELECT username, password
           FROM users
          WHERE email = ?',
        { Slice => {} },
        $email,
    );

    if ( $res->{password} ne $password ) {
        return { error => 'error_mismatched_passwords' };
    }

    return {
        email    => $email,
        username =>
    };
}

1;
