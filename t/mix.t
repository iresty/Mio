use Test::Nginx::Socket 'no_plan';
use JSON;

no_root_location;

run_tests();

sub j {
	my @keys = @_;

	return sub {
		my ($resp) = @_;
		my $result = decode_json( $resp );

		my @values = ();
		foreach my $key (@keys) {
			push @values, eval '$result->' . $key;
		}

		return join("|", @values);
	}
}

__DATA__

=== TEST 1: mix summary
--- http_config
include ../../../conf/http.conf;
--- config
include ../../../conf/server.conf;
--- request eval
["GET /summary", "GET /tt","GET /sleep", "GET /summary"]
--- response_body eval
["{}\n","{\"msg\":\"404! sorry, not found.\",\"success\":false}\n","", "{}\n"]
--- error_code eval
[200, 404, 200, 200]
--- SKIP
