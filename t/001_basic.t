#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use File::Spec::Functions;

use Test::More tests => 10;

BEGIN {
    use_ok('Excel::Template::Plus');
    use_ok('Excel::Template::Plus::TT');
}

=pod

This test primarily tests the creation of the 
template based on the engine parameter.

=cut

my %CONFIG = (INCLUDE_PATH => catdir($FindBin::Bin, 'templates'));
my %PARAMS   = (
    title    => 'Canonical Example',
    greeting => 'Hello'
);

my $template = Excel::Template::Plus->new(
    engine   => 'TT',
    filename => 'basic.tmpl',
    config   => \%CONFIG,
    params   => \%PARAMS
);
isa_ok($template, 'Excel::Template::Plus::TT');

is_deeply 
[qw/greeting title/],
[ sort $template->param ],
"... got the list of template params";

is 'basic.tmpl', $template->filename, '... got the filename from the template';
is_deeply \%CONFIG, $template->config, '... got the config from the template';
is_deeply \%PARAMS, $template->params, '... got the params from the template';

$template->param(location => 'World');

is_deeply 
[qw/greeting location title/],
[ sort $template->param ],
"... got the list of template params";

is 'World', $template->param('location'), '... got the location param from the template params';

#$template->write_file("t/xls/test.xls");

