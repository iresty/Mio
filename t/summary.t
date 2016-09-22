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
GET /hello
--- response_body
hello! this is Mio.
--- error_code: 200



=== TEST 2: summary
--- http_config
include ../../../conf/http.conf;
--- config
include ../../../conf/server.conf;
--- request eval
["GET /summary", "GET /tt","GET /sleep", "GET /summary"]
--- response_body eval
["{}\n","{\"msg\":\"404! sorry, not found.\",\"success\":false}\n","", "{}\n"]
--- error_code eval
["200", "404","200", "200"]
--- ONLY
