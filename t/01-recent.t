use strict;
use Test::More;
use WWW::Google::SearchHistory;

unless ($ENV{GOOGLE_USERNAME}) {
    plan skip_all => 'Test need $ENV{GOOGLE_USERNAME}';
    exit;
}

plan 'no_plan';

my $history = new WWW::Google::SearchHistory(
    username => $ENV{GOOGLE_USERNAME},
    password => $ENV{GOOGLE_PASSWORD},
);

my @all = $history->recent_items;
for my $item (@all) {
    ok $item->{link} and 
       $item->{title} and
       $item->{category};
}

my @query = $history->recent_items(category => 'web query');
for my $item (@query) {
    is $item->{category}, 'web query';
}

my $latest = $history->recent_items(category => 'web query');
ok $latest->{link} and 
   $latest->{title} and
   $latest->{category} eq 'web query';
