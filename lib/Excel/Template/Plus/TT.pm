
package Excel::Template::Plus::TT;
use Moose;
use Moose::Util::TypeConstraints;

use FindBin;
use Template    ();
use File::Temp  ();
use File::Slurp ();

use Excel::Template;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

subtype 'IO::Handle'
    => as 'Object'
    => where { $_->isa('IO::Handle') };

has 'template' => (
    is       => 'ro',
    # can either be a:
    # - filename
    # - scalar ref to string
    # - open filehandle
    # - an IO::Handle instance
    # (basically anything TT takes)
    isa      => 'Str | ScalarRef | FileHandle | IO::Handle',
    required => 1,
);

has 'config' => (
    is       => 'ro',
    isa      => 'HashRef',
    default  => sub {{}},
);

has 'params' => (
    is       => 'ro',
    isa      => 'HashRef',
    default  => sub {{}},
);

## private attributes

has '_tempfile' => (is => 'rw');

has '_excel_template' => (
    is      => 'ro',
    isa     => 'Excel::Template',
    handles => [qw[
        output
        write_file
    ]],
    lazy    => 1,
    default => sub {
        my $self = shift;
        $self->_prepare_excel_template;
    }
);

sub param {
    my $self = shift;
    
    # if they want the list of keys ...
    return keys %{$self->params}  if scalar @_ == 0;
    
    # if they want to fetch a key ...    
    return $self->params->{$_[0]} if scalar @_ == 1;
    
    # otherwise they are assigning params ...
    ((scalar @_ % 2) == 0)
        || confess "parameter assignment must be an even numbered list";
    my %new = @_;
    while (my ($key, $value) = each %new) {
        $self->params->{$key} = $value;
    }
    return;
}

sub _prepare_excel_template {
    my $self = shift;

    my($fh, $tempfile) = File::Temp::tempfile;

    my $tt = Template->new($self->config);
    $tt->process(
        $self->template,
        $self->params,
        $fh,
    );
    close $fh;
    
    $self->_tempfile($tempfile);

    confess "Template creation failed because : " . $tt->error()
        if $tt->error();    

    confess "Template failed to produce any output"
        unless -s $tempfile;    

    my $excel_template = eval { Excel::Template->new(filename => $tempfile) };
    if ($@) {
        warn File::Slurp::slurp($tempfile);
        confess $@;        
    }
    
    return $excel_template;
}

sub DEMOLISH {
    my $self = shift;
    unlink $self->_tempfile 
        if $self->_tempfile && -e $self->_tempfile;
}

no Moose; no Moose::Util::TypeConstraints; 1;

__END__

=pod

=head1 NAME 

Excel::Template::Plus::TT - Extension of Excel::Template to use TT

=head1 SYNOPSIS

  use Excel::Template::Plus::TT;
  
  # this is most commonly used through
  # the Excel::Template::Plus factory 
  
  my $template = Excel::Template::Plus::TT->new(
      template => 'greeting.tmpl',
      config   => { INCLUDE  => [ '/templates' ] },
      params   => { greeting => 'Hello' }
  );
  
  $template->param(location => 'World');
  
  $template->write_file('greeting.xls');

=head1 DESCRIPTION

This is an engine for Excel::Template::Plus which replaces the 
standard Excel::Template template features with TT. See the 
L<Excel::Template::Plus> docs for more information.

=head1 METHODS

=head2 Accessors

=over 4

=item B<config>

=item B<template>

=item B<param>

=back

=head2 Excel::Template compat methods

=over 4

=item B<params ($name | $name => $value)>

This provides access to getting and setting the parameters, it behaves
exactly like the standard CGI.pm-style param method.

=item B<output>

Returns the generated excel file.

=item B<write_file ($filename)>

Writes the generated excel file to C<$filename>.

=back

=head2 Housekeeping

=over 4

=item B<DEMOLISH>

This will cleanup any temp files generated in the process.

=item B<meta>

Returns the metaclass.

=back

=head1 BUGS

All complex software has bugs lurking in it, and this module is no 
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 ACKNOWLEDGEMENTS

=over 4

=item This module was inspired by Excel::Template::TT.

=back

=head1 AUTHOR

Stevan Little E<lt>stevan@iinteractive.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2007 by Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut