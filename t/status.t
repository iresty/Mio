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

=== TEST 1: simple status
--- http_config
include ../../../conf/http.conf;
--- config
include ../../../conf/server.conf;
--- request
GET /status
--- response_body_filters eval
::j("{worker_count}", "{address}", "{generation}")
--- response_body: 1|127.0.0.1:1984|0



=== TEST 1: NGINX and ngx_lua version
--- http_config
include ../../../conf/http.conf;
--- config
include ../../../conf/server.conf;
--- request
GET /status
--- response_body_filters eval
::j("{nginx_version}", "{ngx_lua_version}")
--- response_body_like
\d+\.\d+\.\d+.*|\d+\.\d+\.\d+.*
