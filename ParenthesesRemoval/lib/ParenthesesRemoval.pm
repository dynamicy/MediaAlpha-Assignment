package ParenthesesRemoval;

use strict;
use warnings;

# Fill the operator positions array
sub fill_operator_positions {
    my ($characters, $length, $direction) = @_;
    my @operator_positions = (-1) x ($length + 1);
    my $last_operator = -1;

    my ($start, $end, $step) = $direction eq 'start' ? (0, $length, 1) : ($length - 1, -1, -1);

    for (my $i = $start; $i != $end; $i += $step) {
        $operator_positions[$i] = $last_operator;
        if ($characters->[$i] =~ /[\+\-\*\/]/) {
            $last_operator = $characters->[$i];
        }
    }

    return @operator_positions;
}

# Check if parentheses can be removed
sub can_remove_parentheses {
    my ($start, $end, $last_operator_start, $next_operator_end, $operator_presence, $characters, $length) = @_;

    my $next_operator = $next_operator_end->[$end];
    my $last_operator = $last_operator_start->[$start];

    # Conditions to remove parentheses
    return 1 if ($start > 0 && $end + 1 < $length && $characters->[$start - 1] eq '(' && $characters->[$end + 1] eq ')');
    return 1 if (!grep { $operator_presence->{$_} } keys %$operator_presence);
    return 1 if ($last_operator eq -1 && $next_operator eq -1);
    return 0 if ($last_operator eq '/' || ($last_operator eq '-' && ($operator_presence->{'+'} || $operator_presence->{'-'})));
    return 1 if (!grep { $operator_presence->{$_} } ('+', '-'));
    return 1 if (($last_operator eq -1 || $last_operator =~ /[\+\-]/) && ($next_operator eq -1 || $next_operator =~ /[\+\-]/));

    return 0;
}

# Process parentheses in the expression
sub process_parentheses {
    my ($characters, $length, $last_operator_start, $next_operator_end) = @_;
    my @parentheses_stack;
    my @keep = (1) x ($length + 1);
    my %operator_presence;
    my @operators = ('*', '+', '-', '/');
    my @last_operator_position = (-1) x 256;

    for (my $i = 0; $i < $length; $i++) {
        foreach my $operator (@operators) {
            $operator_presence{$operator} = 0;
            if ($operator eq $characters->[$i]) {
                $last_operator_position[ord($operator)] = $i;
            }
        }

        if ($characters->[$i] eq '(') {
            push @parentheses_stack, $i;
        } elsif ($characters->[$i] eq ')') {
            my $start = pop @parentheses_stack;
            my $end = $i;

            foreach my $operator (@operators) {
                if ($last_operator_position[ord($operator)] >= $start) {
                    $operator_presence{$operator} = 1;
                }
            }

            if (can_remove_parentheses($start, $end, $last_operator_start, $next_operator_end, \%operator_presence, $characters, $length)) {
                $keep[$start] = 0;
                $keep[$end] = 0;
            }
        }
    }

    return @keep;
}

# Build the final result string without unnecessary parentheses
sub build_result_string {
    my ($characters, $keep, $length) = @_;
    my $result = '';
    for (my $i = 0; $i < $length; $i++) {
        $result .= $characters->[$i] if $keep->[$i];
    }
    return $result;
}

# Main function to remove unnecessary parentheses
sub remove_parentheses {
    my ($expression) = @_;
    my @characters = split //, $expression;
    my $length = @characters;

    my @last_operator_start = fill_operator_positions(\@characters, $length, 'start');
    my @next_operator_end = fill_operator_positions(\@characters, $length, 'end');

    my @keep = process_parentheses(\@characters, $length, \@last_operator_start, \@next_operator_end);

    return build_result_string(\@characters, \@keep, $length);
}

1;