#!/usr/bin/perl

use strict;
use warnings;
use lib qw(lib);
use ParenthesesRemoval;
use Test::More tests => 6;

# Test loading the module
BEGIN { use_ok('ParenthesesRemoval') }

# Test the remove_parentheses function, case 1: "1*(2+(3*(4+5)))"
is(ParenthesesRemoval::remove_parentheses("1*(2+(3*(4+5)))"), "1*(2+3*(4+5))", 'Test case 1 failed.');
# Test the remove_parentheses function, case 2: "2 + (3 / -5)"
is(ParenthesesRemoval::remove_parentheses("2 + (3 / -5)"), "2 + 3 / -5", 'Test case 2 failed.');
# Test the remove_parentheses function, case 3: "x+(y+z)+(t+(v+w))"
is(ParenthesesRemoval::remove_parentheses("x+(y+z)+(t+(v+w))"), "x+y+z+t+v+w", 'Test case 3 failed.');
# Test the remove_parentheses function, case 4: "a +  (b * c)"
is(ParenthesesRemoval::remove_parentheses("a +  (b * c)"), "a +  b * c", 'Test case 4 failed.');
# Test the remove_parentheses function, case 5: "-d-e+(f/(g/h))"
is(ParenthesesRemoval::remove_parentheses("-d-e+(f/(g/h))"), "-d-e+f/(g/h)", 'Test case 5 failed.');
