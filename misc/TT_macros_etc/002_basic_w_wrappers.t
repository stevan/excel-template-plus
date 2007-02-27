#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use File::Spec::Functions;

use Test::More tests => 5;
use Test::Exception;
use Test::Excel::Template::Plus qw(cmp_excel_files);

BEGIN {
    use_ok('Excel::Template::Plus');
    use_ok('Excel::Template::Plus::TT');
}

my %CONFIG   = (
    INCLUDE_PATH => [
        catdir($FindBin::Bin, 'templates'),
        catdir($FindBin::Bin, updir, 'templates'),        
    ]
);

my %PARAMS   = (
    worksheet_name => 'Canonical Example',
    greeting       => 'Hello'
);

my $template = Excel::Template::Plus->new(
    engine   => 'TT',
    template => 'basic_w_wrappers.tmpl',
    config   => \%CONFIG,
    params   => \%PARAMS
);
isa_ok($template, 'Excel::Template::Plus::TT');

$template->param(location => 'World');

lives_ok {
    $template->write_file("temp.xls");
} '... writing the template file was successful';

cmp_excel_files "temp.xls", "t/xls/001_basic.xls", '... the generated excel file was correct';

`open temp.xls`;
#unlink 'temp.xls';


