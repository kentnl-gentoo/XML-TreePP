# ----------------------------------------------------------------
    use strict;
    use Test::More tests => 5;
# ----------------------------------------------------------------
SKIP: {
    local $@;
    eval { require HTTP::Lite; } unless defined $HTTP::Lite::VERSION;
    if ( ! defined $HTTP::Lite::VERSION ) {
        skip( "HTTP::Lite is not loaded.", 5 );
    }
    if ( ! defined $ENV{MORE_TESTS} ) {
        skip( "\$MORE_TESTS is not defined.", 5 );
    }
    use_ok('XML::TreePP');
    &parsehttp_get();
    &parsehttp_post();
}
# ----------------------------------------------------------------
sub parsehttp_get {
    my $tpp = XML::TreePP->new();
    my $url = "http://use.perl.org/index.rss";
    my $tree = $tpp->parsehttp( GET => $url );
    ok( ref $tree, $url );
    like( $tree->{"rdf:RDF"}->{channel}->{link}, qr{^http://}, "$url link" );
}
# ----------------------------------------------------------------
sub parsehttp_post {
    my $tpp = XML::TreePP->new( force_array => [qw( item )] );
    my $url = "http://search.hatena.ne.jp/keyword";
    my $query = "ajax";
    my $body = "mode=rss2&word=".$query;
    my $tree = $tpp->parsehttp( POST => $url, $body );
    ok( ref $tree, $url );
    like( $tree->{rss}->{channel}->{item}->[0]->{link}, qr{^http://}, "$url link" );
}
# ----------------------------------------------------------------
;1;
# ----------------------------------------------------------------
