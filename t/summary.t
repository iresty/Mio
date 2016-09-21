use Test::Nginx::Socket 'no_plan';

no_root_location;

run_tests();

__DATA__

=== TEST 1: hello, world

--- http_config
include ../../../conf/http.conf;
--- config
include ../../../conf/server.conf;

--- request
GET /t
--- response_body
hello! this is Mio.
--- error_code: 200
