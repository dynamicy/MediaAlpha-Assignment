#!/usr/bin/perl

use strict;
use warnings;
use lib qw(lib);
use PasswordValidator;
use Test::More tests => 18;

# Test loading the module
BEGIN { use_ok('PasswordValidator') }

# If password is less than 8 characters long, it should return 0
is(PasswordValidator::is_valid_password("Passw1!"), 0, 'Passwords must be at least 8 characters long.');

# If password is 8-11 characters long, it should require mixed case letters, numbers and symbols
is(PasswordValidator::is_valid_password("Passwo1!"), 1, 'Valid password (8-11, mixed case, numbers, symbols)');
is(PasswordValidator::is_valid_password("Passwor1"), 0, 'Invalid password (8-11, missing symbol)');
is(PasswordValidator::is_valid_password("Password"), 0, 'Invalid password (8-11, missing number)');
is(PasswordValidator::is_valid_password("passwo1!"), 0, 'Invalid password (8-11, missing uppercase)');
is(PasswordValidator::is_valid_password("PASSWO1!"), 0, 'Invalid password (8-11, missing lowercase)');

# If password is 12-15 characters long, it should require mixed case letters and numbers
is(PasswordValidator::is_valid_password("Password1234"), 1, 'Valid password (12-15, mixed case, numbers)');
is(PasswordValidator::is_valid_password("password1234"), 0, 'Invalid password (12-15, missing uppercase)');
is(PasswordValidator::is_valid_password("PASSWORD1234"), 0, 'Invalid password (12-15, missing lowercase)');
is(PasswordValidator::is_valid_password("Passwordpass"), 0, 'Invalid password (12-15, missing number)');

# If password is 16-19 characters long, it should require mixed case letters
is(PasswordValidator::is_valid_password("Passwordpassword"), 1, 'Valid password (16-19, mixed case)');
is(PasswordValidator::is_valid_password("passwordpassword"), 0, 'Invalid password (16-19, missing uppercase)');
is(PasswordValidator::is_valid_password("PASSWORDPASSWORD"), 0, 'Invalid password (16-19, missing lowercase)');

# If password is 20+ characters long, it should allow any characters
is(PasswordValidator::is_valid_password("Passwordpasswordpass"), 1, 'Valid password (20+, any characters)');
is(PasswordValidator::is_valid_password("passwordpasswordpass"), 1, 'Valid password (20+, any characters)');
is(PasswordValidator::is_valid_password("PASSWORDPASSWORDPASS"), 1, 'Valid password (20+, any characters)');
is(PasswordValidator::is_valid_password("####################"), 1, 'Valid password (20+, any characters)');