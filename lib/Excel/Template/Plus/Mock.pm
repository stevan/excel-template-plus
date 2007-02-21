
package Excel::Template::Plus::Mock;

use strict;
use warnings;

our $VERSION = '0.01';

sub new {
    my ($class, %options) = @_;
    
    # allowed options:
    # - FILE / FILENAME
    # - RENDERER
    # - USE UNICODE
    
    bless {
        params => { map { uc($_) => $options{$_} } keys %options },
    } => $class;
}

sub param {
    my $self = shift;
    return keys %{$self->{params}} unless @_;
    return $self->{params}->{+(shift)} if (scalar(@_) == 1);
    my %params = @_;
    $self->{params}->{$_} = $params{$_} foreach keys %params;
    $self;    
}

sub parse_xml {
    my ($self, $file) = @_;
    $self->{options}->{parse_xml_file} = $file;
}

*parse = \&parse_xml;

sub write_file { 0 }
sub output     { 0 }
sub register   { 0 }


1;

__END__

=pod

=head1 NAME 

Excel::Template::Plus::Mock - 

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 BUGS

All complex software has bugs lurking in it, and this module is no 
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 CODE COVERAGE

I use L<Devel::Cover> to test the code coverage of my tests, below 
is the L<Devel::Cover> report on this module's test suite.

=head1 AUTHOR

Stevan Little E<lt>stevan@iinteractive.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2007 by Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut