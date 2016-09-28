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
--- no_error_log
[error]



=== TEST 2: NGINX and ngx_lua version
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
--- no_error_log
[error]



=== TEST 3: simple requests
the status datas ingore the first /status access,
because the status datas record in log_by_lua phase
--- http_config
	include ../../../conf/http.conf;
--- config
	include ../../../conf/server.conf;
--- request
GET /status
--- response_body_filters eval
::j("{requests}->{current}","{requests}->{total}","{requests}->{success}")
--- response_body: 0|0|0
--- no_error_log
[error]



=== TEST 4:  '200' and '404' pipeline requests
--- http_config
	include ../../../conf/http.conf;
--- config
	include ../../../conf/server.conf;
	location = /test {
	        content_by_lua '
	            local status = ngx.shared.status
	            ngx.say(status:get("total_count"))
				ngx.say(status:get("total_success_count"))
	        ';
	    }
--- request eval
["GET /test", "GET /hello", "GET /not_exist", "GET /test"]
--- error_code eval
[200, 200, 404, 200]
--- response_body eval
["0\n0\n",
 "hello! this is Mio.\n",
"{\"msg\":\"404! sorry, not found.\",\"success\":false}\n",
"3\n2\n"]



=== TEST 5:  proxy requests
one proxy_pass request should be treated as two requests
--- http_config
	include ../../../conf/http.conf;
	server{
		listen 1900;
		server_name  'test_domain';
		location = /hello {
			echo 'hello';
		}
	}
--- config
	include ../../../conf/server.conf;
	location = /test_proxy {
	        proxy_pass http://127.0.0.1:1900/hello;
	    }
	location = /test {
	        content_by_lua '
	            local status = ngx.shared.status
	            ngx.say(status:get("total_count"))
				ngx.say(status:get("total_success_count"))
	        ';
	    }
--- request eval
["GET /test", "GET /hello", "GET /test_proxy", "GET /test"]
--- error_code eval
[200, 200, 200, 200]
--- response_body eval
["0\n0\n",
 "hello! this is Mio.\n",
"hello\n",
"4\n4\n"]
--- no_error_log
[error]
