use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Web::Blogalia',
    AUTHOR              => 'JJ Merelo <jj@merelo.net>',
    VERSION_FROM        => 'lib/Web/Blogalia.pm',
    ABSTRACT_FROM       => 'lib/Web/Blogalia.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'version'    => 0,
	'YAML'       => 0  
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Web-Blogalia-*' },
);
