#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use File::Spec::Functions;

use Test::More tests => 10;

BEGIN {
    use_ok('Excel::Template::Plus');
    use_ok('Excel::Template::Plus::Mock');
}

=pod

This test primarily tests the creation of the 
template based on the engine parameter.

=cut

my %CONFIG = (INCLUDE_PATH => catdir($FindBin::Bin, 'templates'));
my %VARS   = (greeting => 'Hello');

my $template = Excel::Template::Plus->new(
    engine   => 'Mock',
    filename => 'test.tmpl',
    config   => \%CONFIG,
    vars     => \%VARS
);
isa_ok($template, 'Excel::Template::Plus::Mock');

is_deeply 
[qw/CONFIG ENGINE FILENAME VARS/],
[ sort $template->param ],
"... got the list of template params";

is 'Mock', $template->param('ENGINE'), '... got the engine from the template params';
is 'test.tmpl', $template->param('FILENAME'), '... got the filename from the template params';
is_deeply \%CONFIG, $template->param('CONFIG'), '... got the config from the template params';
is_deeply \%VARS, $template->param('VARS'), '... got the vars from the template params';

$template->param(location => 'World');

is_deeply 
[qw/CONFIG ENGINE FILENAME VARS location/],
[ sort $template->param ],
"... got the list of template params";

is 'World', $template->param('location'), '... got the location param from the template params';



