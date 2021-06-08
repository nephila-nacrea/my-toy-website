package MTW::User;

use strict;
use warnings;

use DBI;
use Moo;

use feature 'signatures';
use namespace::clean;

sub add ( $username, $email, $password ) {
    my $dbh = DBI->connect(
        'dbi:SQLite:dbname=/home/vmihell-hale/my-toy-website/my_toy_db');

    $dbh->do(
        'INSERT INTO users
                ( username, email, created )
         VALUES ( ?,        ?,     ?       )',
        undef,
        $username,
        $email,
        time,
    );
}

1;
