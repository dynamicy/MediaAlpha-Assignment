package ParenthesesRemoval;

use strict;
use warnings;

# Define operators
my @operators = ('*', '+', '-', '/');

# Update the position of the last seen operator
sub set_last_operator_position {
    my ($expression_chars, $index, $operator_positions, $last_operator_ref) = @_;
    $operator_positions->[$index] = $$last_operator_ref;

    if (grep { $_ eq $expression_chars->[$index] } @operators) {
        $$last_operator_ref = $expression_chars->[$index];
    }
}

# Fill the operator positions array for last and next operators
sub fill_operator_positions {
    my ($expression_chars) = @_;
    my $length = scalar @$expression_chars;
    my @last_operator_positions = (-1) x ($length + 1);
    my @next_operator_positions = (-1) x ($length + 1);
    my ($last_seen_operator, $next_seen_operator) = (-1, -1);

    for my $i (0 .. $length - 1) {
        set_last_operator_position($expression_chars, $i, \@last_operator_positions, \$last_seen_operator);
        set_last_operator_position($expression_chars, $length - 1 - $i, \@next_operator_positions, \$next_seen_operator);
    }

    return (\@last_operator_positions, \@next_operator_positions);
}

# Process parentheses in the expression
sub process_parentheses {
    my ($expression_chars, $last_operator_positions_ref, $next_operator_positions_ref) = @_;

    my $length = scalar @$expression_chars;
    my @stack;
    my @operator_positions = (-1) x 256;
    my @operator_map = (0) x 256;
    my @last_operator_positions = @$last_operator_positions_ref;
    my @next_operator_positions = @$next_operator_positions_ref;
    my @keep_parentheses = (1) x $length;

    for my $pos (0 .. $length - 1) {
        update_operator_positions(\@operator_map, \@operator_positions, $expression_chars->[$pos], $pos);

        if ($expression_chars->[$pos] eq '(') {
            push @stack, $pos;
        }
        elsif ($expression_chars->[$pos] eq ')') {
            my $start = pop @stack;
            if (can_remove_parentheses(\@operator_map, \@operator_positions, $expression_chars, $start, $pos, \@last_operator_positions, \@next_operator_positions)) {
                $keep_parentheses[$start] = 0;
                $keep_parentheses[$pos] = 0;
            }
        }
    }
    return \@keep_parentheses;
}

# Update operator positions based on the current character
sub update_operator_positions {
    my ($operator_map, $operator_positions, $char, $pos) = @_;
    for my $operator (@operators) {
        $operator_map->[ord($operator)] = 0;
        $operator_positions->[ord($operator)] = $pos if $operator eq $char;
    }
}

# Determine if parentheses can be removed
sub can_remove_parentheses {
    my ($operator_map, $operator_positions, $expression_chars, $start, $end, $last_operator_positions, $next_operator_positions) = @_;

    for my $operator (@operators) {
        if ($operator_positions->[ord($operator)] >= $start) {
            $operator_map->[ord($operator)] = 1;
        }
    }

    my $next_operator = $next_operator_positions->[$end];
    my $last_operator = $last_operator_positions->[$start];

    # Conditions to remove parentheses
    return 1 if ($start > 0 && $end + 1 < scalar @$expression_chars &&
        $expression_chars->[$start - 1] eq '(' && $expression_chars->[$end + 1] eq ')');
    return 1 if (!$operator_map->[ord('+')] && !$operator_map->[ord('*')] &&
        !$operator_map->[ord('-')] && !$operator_map->[ord('/')]);
    return 1 if ($last_operator eq '-1' && $next_operator eq '-1');
    return 1 if ($last_operator eq '-1' && $next_operator eq '/');
    return 0 if ($start - 1 > 0 && $expression_chars->[$start - 1] eq '+' && $expression_chars->[$start + 1] eq '-');
    return 1 if ((grep { $_ eq '+' || $_ eq '*' } @$expression_chars[$start .. $end]) &&
        $expression_chars->[$start - 1] eq '(' && !(grep { $_ eq '-' } @$expression_chars[$start .. $end]));

    if ($last_operator eq '/') {
        return 0;
    }
    elsif ($last_operator eq '-' && ($operator_map->[ord('+')] || $operator_map->[ord('-')])) {
        return 0;
    }
    elsif (!$operator_map->[ord('+')]) {
        return 1;
    }
    elsif (($last_operator eq '-1' || $last_operator eq '+' || $last_operator eq '-') &&
        ($next_operator eq '-1' || $next_operator eq '+' || $next_operator eq '-')) {
        return 1;
    }
    return 0;
}

# Build the final result string without unnecessary parentheses
sub build_result_string {
    my ($characters, $keep_parentheses_ref) = @_;
    my $result = '';
    my $length = scalar @$characters;
    for (my $i = 0; $i < $length; $i++) {
        $result .= $characters->[$i] if $keep_parentheses_ref->[$i];
    }
    return $result;
}

# Main function to remove unnecessary parentheses
sub remove_parentheses {
    my @expression_chars = split //, $_[0];

    # Initialize arrays to track parentheses and operators
    my ($last_operator_positions_ref, $next_operator_positions_ref) = fill_operator_positions(\@expression_chars);

    # Process each character in the expression
    my $keep_parentheses_ref = process_parentheses(\@expression_chars, $last_operator_positions_ref, $next_operator_positions_ref);

    # Build and return the result string without unnecessary parentheses
    return build_result_string(\@expression_chars, $keep_parentheses_ref);
}

1;