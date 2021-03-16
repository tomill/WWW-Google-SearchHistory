package Plagger::Plugin::CustomFeed::GoogleSearchHistory;
use strict;
use base qw( Plagger::Plugin );

use WWW::Google::SearchHistory; 

sub register {
    my($self, $context) = @_;
    $context->register_hook(
        $self,
        'subscription.load' => $self->can('load'),
    );
}

sub load {
    my ($self, $context) = @_;
    $self->init_google_search_history();
    
    my $feed = Plagger::Feed->new;
    $feed->aggregator(sub { $self->aggregate(@_) });
    $context->subscription->add($feed);
}

sub init_google_search_history {
    my $self = shift;
    $self->{google_search_history} = new WWW::Google::SearchHistory(
        username => $self->conf->{username},
        password => $self->conf->{password},
    );
}

sub aggregate {
    my($self, $context) = @_;
    
    my $feed = Plagger::Feed->new;
    $feed->link('http://www.google.com/searchhistory/');
    $feed->title('Google - Search History');
    
    my @query = $self->{google_search_history}->recent_items(category => 'web query');
    for my $item (@query) {
        my $entry = Plagger::Entry->new;
        $entry->$_($item->{$_}) for qw(link title);
        $feed->add_entry($entry);
    }
    
    $context->update->add($feed);
}

1;

__END__

=head1 NAME

Plagger::Plugin::CustomFeed::GoogleSearchHistory - Custom feed for Google Search History

=head1 SYNOPSIS

    - module: CustomFeed::GoogleSearchHistory
      config:
        username: username 
        password: p4ssw0rd

=head1 DESCRIPTION

This plugin fetches your Google Search History log. 

=head1 CONFIG

=over 4

=item username, password

Your Google ID and password.

=back

=head1 AUTHOR

Naoki Tomita E<lt>tomita@cpan.orgE<gt>

=head1 SEE ALSO

L<Plagger>, L<WWW::Google::SearchHistory>

=cut
