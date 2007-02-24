
package Excel::Template::Plus;
use Moose;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

sub new {
    shift;
    my %options = @_;
    $options{engine} ||= 'TT';
    
    my $engine_class = 'Excel::Template::Plus::' . $options{engine};
    eval "use $engine_class";
    if ($@) {
        confess "Could not load engine class ($engine_class) because " . $@;
    }
    
    my $template = eval { $engine_class->new(%options) };
    if ($@) {
        confess "Could not create template from engine class ($engine_class) because " . $@;
    }    
    
    return $template;
}

1;

__END__

=pod

=head1 NAME 

Excel::Template::Plus - An extension to the Excel::Template module

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