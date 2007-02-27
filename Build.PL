use Module::Build;

use strict;

my $build = Module::Build->new(
    module_name => 'Excel::Template::Plus',
    license => 'perl',
    requires => {
        'Excel::Template'         => '0',
        'Template'                => '0',
        'File::Temp'              => '0',        
        'File::Slurp'             => '0',
        'Moose'                   => '0.17',           
        # for Test::Excel::Template::Plus
        'Test::Deep'              => '0',
        'Spreadsheet::ParseExcel' => '0',                     
    },
    optional => {
    },
    build_requires => {
        'Test::More'      => '0.47',
        'Test::Exception' => '0.21',
        'File::Spec'      => '0',
        'FindBin'         => '0',
    },
    create_makefile_pl => 'traditional',
    recursive_test_files => 1,
    add_to_cleanup => [
        'META.yml', '*.bak', '*.gz', 'Makefile.PL',
    ],
);

$build->create_build_script;

