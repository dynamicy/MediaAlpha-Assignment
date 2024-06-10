#!/usr/bin/perl

use strict;
use warnings;
use lib qw(lib);
use PasswordValidator;

if (PasswordValidator::is_valid_password('Password123!')) {
    print "Password is valid\n";
} else {
    print "Password is invalid\n";
}