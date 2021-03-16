use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'WWW::Google::SearchHistory',
    AUTHOR              => 'Naoki Tomita <tomita@cpan.org>',
    VERSION_FROM        => 'lib/WWW/Google/SearchHistory.pm',
    ABSTRACT_FROM       => 'lib/WWW/Google/SearchHistory.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        Test::More => 0,
        LWP::UserAgent => 0,
        XML::RSS => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'WWW-Google-SearchHistory-*' },
);
