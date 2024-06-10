package PasswordValidator;

use strict;
use warnings;

sub is_valid_password {
    my ($password) = @_;

    my $length = length($password);

    # Passwords must be at least 8 characters long.
    if ($length < 8) {
        return 0;  # Password too short
    } elsif ($length <= 11) { # Between 8-11: requires mixed case letters, numbers and symbols
        return ($password =~ /^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[\W_])/ ? 1 : 0);
    } elsif ($length <= 15) { # Between 12-15: requires mixed case letters and numbers
        return ($password =~ /^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])/ ? 1 : 0);
    } elsif ($length <= 19) { # Between 16-19: requires mixed case letters
        return ($password =~ /^(?=.*[A-Z])(?=.*[a-z])/ ? 1 : 0);
    } else {
        return 1;  #20+: any characters desired
    }
}

1;