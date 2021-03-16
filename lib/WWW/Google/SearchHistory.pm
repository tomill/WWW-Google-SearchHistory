package WWW::Google::SearchHistory;
use strict;
our $VERSION = '0.01';

use Carp;
use LWP::UserAgent;
use XML::RSS;

sub new {
    my ($class, %opt) = @_;
    my $self = bless {
        username => '',
        password => '',
        ua => LWP::UserAgent->new,
        %opt,
    }, $class;
    
    $self->{ua}->agent('Mozilla/5.0'); # google need this.
    $self;
}

our $recent_rss = 'https://www.google.com/searchhistory/?output=rss';

sub recent_items {
    my ($self, %cond) = @_;
    
    my $req = HTTP::Request->new(GET => $recent_rss);
       $req->headers->authorization_basic($self->{username}, $self->{password});
    my $res = $self->{ua}->request($req); 
    if ($res->is_error) {
        carp 'Item fetching failed: ' . $res->status_line;
        return;
    }
    
    my $rss = new XML::RSS;
    $rss->parse($res->content);
    
    my @item;
    for my $item (@{$rss->{items} || []}) {
        next if $cond{category} and 
                $cond{category} ne $item->{category};
        
        push @item, $item; 
    }
    return wantarray ? @item : shift @item;
}

1;
__END__

=head1 NAME

WWW::Google::SearchHistory - Perl interface for Google Search History

=head1 SYNOPSIS

    use WWW::Google::SearchHistory;

    my $history = new WWW::Google::SearchHistory(
        username => 'example', 
        password => 'p4ssw0rd',
    );
    
    my @item = $history->recent_items;
    my $item = $history->recent_items(category => 'web query');

=head1 DESCRIPTION 

This module provides Google Search History Services. (Google Search History is 
a part of Google Personalized Search Services)

=head1 METHODS

=over

=item new

    $history = WWW::Google::SearchHistory->new(username => $user, password => $pass);

Creates a new instance. Set your Google ID and password.

=item recent_items

    @item = $history->recent_items();
    $item = $history->recent_items(); # latest one

Returns recently items, up to about 20 items. 
If it's called in a scalar context, returns the first one.

Item sample:

    {
       'category' => 'web query',
       'description' => '0 result(s)',
       'guid' => 'abCDEFg12Hij345K67',
       'link' => 'http://www.google.com/search?q=what+is+the+matrix',
       'pubDate' => 'Sat, 22 Jul 2006 23:11:41 GMT',
       'title' => 'what is the matrix',
    }

I<category> takes:  (to my knowledge)

    category          link is..             title is...
    ================  --------------------  -------------------- 
    "web query"       web query url         query keyword
    "web result"      clicked page url      page title
    "images query"     .                     .
    "images result"    .                     .
    "news query"       .                     .
    "news results"     .                     .
    "froogle query"    .                     .
    "froogle result"   .                     .
    "video query"      .                     .
    "video result"     .                     .

If you want to get search history only:
    
    @query = $history->recent_items(category => 'web query'); 
    $query = $history->recent_items(category => 'web query'); # your last query.

=back

=head1 TODO

Support more Google Search History feature such as Search History Trends.

=head1 AUTHOR

Naoki Tomita E<lt>tomita@cpan.orgE<gt>

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 SEE ALSO

http://www.google.co.jp/searchhistory/

=cut
