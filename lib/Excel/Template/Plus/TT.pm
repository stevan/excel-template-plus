
package Excel::Template::Plus::TT;

use strict;
use warnings;

use Template    ();
use File::Temp  ();
use File::Slurp ();

our $VERSION = '0.01';

use base 'Excel::Template';

sub parse_xml {
    my($self, $file) = @_;

    my($fh, $tempfile) = File::Temp::tempfile;

    my $tt = Template->new($self->{CONFIG} || {});
    $tt->process(
        $file,
        $self->{VARS} || {},
        $fh,
    );
    close $fh;

    $self->{tempfile} = $tempfile;

    die "Template creation failed because : " . $tt->error()
        if $tt->error();    

    die "Template failed to produce any output"
        unless -s $tempfile;    

    eval { $self->Excel::Template::parse_xml($tempfile) };
    if ($@) {
        warn File::Slurp::slurp($tempfile);
        die $@;        
    }
}

sub DESTROY {
    my $self = shift;

    unlink $self->{tempfile};
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