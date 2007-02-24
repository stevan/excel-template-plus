
package Excel::Template::Plus::TT;
use Moose;

use Template    ();
use File::Temp  ();
use File::Slurp ();

use Excel::Template;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

has 'filename' => (
    is       => 'ro',
    isa      => 'Str | GlobRef',
    required => 1,
);

has 'config' => (
    is      => 'ro',
    isa     => 'HashRef',
    default => sub {{}},
);

has 'params' => (
    is      => 'rw',
    isa     => 'HashRef',
    default => sub {{}},
);

sub param {
    my $self = shift;
    # if they want the list of keys ...
    return keys %{$self->params}  if scalar @_ == 0;
    # if they want to fetch a key ...    
    return $self->params->{$_[0]} if scalar @_ == 1;
    
    ((scalar @_ % 2) == 0)
        || confess "parameter assignment must be an even numbered list";
    
    my %new = @_;
    while (my ($key, $value) = each %new) {
        $self->params->{$key} = $value;
    }
    return;
}

1;

__END__

=pod

=head1 NAME 

Excel::Template::Plus::TT - An extension to the Excel::Template module

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 BUGS

All complex software has bugs lurking in it, and this module is no 
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 CODE COVERAGE

I use L<Devel::Cover> to test the code coverage of my tests, below 
is the L<Devel::Cover> report on this module's test suite.

=head1 ACKNOWLEDGEMENTS

=over 4

=item This module was inspired by Excel::Template::TT

=back

=head1 AUTHOR

Stevan Little E<lt>stevan@iinteractive.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2007 by Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut