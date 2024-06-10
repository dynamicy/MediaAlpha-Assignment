#!/usr/bin/perl

use strict;
use warnings;
use lib qw(lib);
use ParenthesesRemoval;

# f("1*(2+(3*(4+5)))") ===> "1*(2+3*(4+5))"
print ParenthesesRemoval::remove_parentheses('1*(2+(3*(4+5)))'), "\n";
# f("2 + (3 / -5)") ===> "2 + 3 / -5"
print ParenthesesRemoval::remove_parentheses('2 + (3 / -5)'), "\n";
# f("x+(y+z)+(t+(v+w))") ===> "x+y+z+t+v+w"
print ParenthesesRemoval::remove_parentheses('x+(y+z)+(t+(v+w))'), "\n";
