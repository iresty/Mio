Nginx Plus status Object:

```
{
    "version": 6,
    "nginx_version": "1.9.13",
    "address": "206.251.255.64",
    "generation": 17,
    "load_timestamp": 1469872800422,
    "timestamp": 1470380827740,
    "pid": 12122,
    "processes": {
        "respawned": 0
    },
    "connections": {
        "accepted": 42992311,
        "dropped": 0,
        "active": 10,
        "idle": 32
    },
    "ssl": {
        "handshakes": 87718,
        "handshakes_failed": 12796,
        "session_reuses": 15639
    },
    "requests": {
        "total": 89071732,
        "current": 10
    },
    "server_zones": {
        "hg.nginx.org": {
            "processing": 0,
            "requests": 117699,
            "responses": {
                "1xx": 0,
                "2xx": 94585,
                "3xx": 7270,
                "4xx": 6380,
                "5xx": 4294,
                "total": 112529
            },
            "discarded": 5170,
            "received": 37638786,
            "sent": 3903089710
        },
        "trac.nginx.org": {
            "processing": 2,
            "requests": 265634,
            "responses": {
                "1xx": 0,
                "2xx": 176229,
                "3xx": 53194,
                "4xx": 26537,
                "5xx": 2063,
                "total": 258023
            },
            "discarded": 7609,
            "received": 78895477,
            "sent": 6317876854
        },
        "lxr.nginx.org": {
            "processing": 0,
            "requests": 20087,
            "responses": {
                "1xx": 0,
                "2xx": 13236,
                "3xx": 435,
                "4xx": 5537,
                "5xx": 586,
                "total": 19794
            },
            "discarded": 293,
            "received": 7001476,
            "sent": 530325233
        }
    },
    "upstreams": {
        "trac-backend": {
            "peers": [
                {
                    "id": 0,
                    "server": "10.0.0.1:8080",
                    "backup": false,
                    "weight": 1,
                    "state": "up",
                    "active": 0,
                    "requests": 100514,
                    "responses": {
                        "1xx": 0,
                        "2xx": 98250,
                        "3xx": 712,
                        "4xx": 1533,
                        "5xx": 19,
                        "total": 100514
                    },
                    "sent": 44212450,
                    "received": 5612134468,
                    "fails": 0,
                    "unavail": 0,
                    "health_checks": {
                        "checks": 50709,
                        "fails": 0,
                        "unhealthy": 0,
                        "last_passed": true
                    },
                    "downtime": 0,
                    "downstart": 0,
                    "selected": 1470380825000
                },
                {
                    "id": 1,
                    "server": "10.0.0.1:8081",
                    "backup": true,
                    "weight": 1,
                    "state": "unhealthy",
                    "active": 0,
                    "requests": 0,
                    "responses": {
                        "1xx": 0,
                        "2xx": 0,
                        "3xx": 0,
                        "4xx": 0,
                        "5xx": 0,
                        "total": 0
                    },
                    "sent": 0,
                    "received": 0,
                    "fails": 0,
                    "unavail": 0,
                    "health_checks": {
                        "checks": 50784,
                        "fails": 50784,
                        "unhealthy": 1,
                        "last_passed": false
                    },
                    "downtime": 508026469,
                    "downstart": 1469872801271,
                    "selected": 0
                }
            ],
            "keepalive": 0
        },
        "hg-backend": {
            "peers": [
                {
                    "id": 0,
                    "server": "10.0.0.1:8088",
                    "backup": false,
                    "weight": 5,
                    "state": "up",
                    "active": 0,
                    "requests": 96373,
                    "responses": {
                        "1xx": 0,
                        "2xx": 89990,
                        "3xx": 0,
                        "4xx": 6378,
                        "5xx": 5,
                        "total": 96373
                    },
                    "sent": 31227723,
                    "received": 3941567139,
                    "fails": 0,
                    "unavail": 0,
                    "health_checks": {
                        "checks": 50603,
                        "fails": 0,
                        "unhealthy": 0,
                        "last_passed": true
                    },
                    "downtime": 0,
                    "downstart": 0,
                    "selected": 1470380812000
                },
                {
                    "id": 1,
                    "server": "10.0.0.1:8089",
                    "backup": true,
                    "weight": 1,
                    "state": "unhealthy",
                    "active": 0,
                    "requests": 0,
                    "responses": {
                        "1xx": 0,
                        "2xx": 0,
                        "3xx": 0,
                        "4xx": 0,
                        "5xx": 0,
                        "total": 0
                    },
                    "sent": 0,
                    "received": 0,
                    "fails": 0,
                    "unavail": 0,
                    "health_checks": {
                        "checks": 50784,
                        "fails": 50784,
                        "unhealthy": 1,
                        "last_passed": false
                    },
                    "downtime": 508026477,
                    "downstart": 1469872801263,
                    "selected": 0
                }
            ],
            "keepalive": 0
        },
        "lxr-backend": {
            "peers": [
                {
                    "id": 0,
                    "server": "unix:/tmp/cgi.sock",
                    "backup": false,
                    "weight": 1,
                    "state": "up",
                    "active": 0,
                    "requests": 10012,
                    "responses": {
                        "1xx": 0,
                        "2xx": 10007,
                        "3xx": 0,
                        "4xx": 0,
                        "5xx": 0,
                        "total": 10007
                    },
                    "sent": 9067176,
                    "received": 526505136,
                    "fails": 0,
                    "unavail": 0,
                    "health_checks": {
                        "checks": 0,
                        "fails": 0,
                        "unhealthy": 0
                    },
                    "downtime": 0,
                    "downstart": 0,
                    "selected": 1470380783000
                },
                {
                    "id": 1,
                    "server": "unix:/tmp/cgib.sock",
                    "backup": true,
                    "weight": 1,
                    "state": "up",
                    "active": 0,
                    "max_conns": 42,
                    "requests": 0,
                    "responses": {
                        "1xx": 0,
                        "2xx": 0,
                        "3xx": 0,
                        "4xx": 0,
                        "5xx": 0,
                        "total": 0
                    },
                    "sent": 0,
                    "received": 0,
                    "fails": 0,
                    "unavail": 0,
                    "health_checks": {
                        "checks": 0,
                        "fails": 0,
                        "unhealthy": 0
                    },
                    "downtime": 0,
                    "downstart": 0,
                    "selected": 0
                }
            ],
            "keepalive": 0
        },
        "demo-backend": {
            "peers": [
                {
                    "id": 0,
                    "server": "10.0.0.2:15431",
                    "backup": false,
                    "weight": 1,
                    "state": "up",
                    "active": 0,
                    "requests": 0,
                    "responses": {
                        "1xx": 0,
                        "2xx": 0,
                        "3xx": 0,
                        "4xx": 0,
                        "5xx": 0,
                        "total": 0
                    },
                    "sent": 0,
                    "received": 0,
                    "fails": 0,
                    "unavail": 0,
                    "health_checks": {
                        "checks": 506057,
                        "fails": 0,
                        "unhealthy": 0,
                        "last_passed": true
                    },
                    "downtime": 0,
                    "downstart": 0,
                    "selected": 0
                }
            ],
            "keepalive": 0
        }
    },
    "caches": {
        "http_cache": {
            "size": 115032064,
            "max_size": 536870912,
            "cold": false,
            "hit": {
                "responses": 2129227,
                "bytes": 32373707466
            },
            "stale": {
                "responses": 0,
                "bytes": 0
            },
            "updating": {
                "responses": 0,
                "bytes": 0
            },
            "revalidated": {
                "responses": 0,
                "bytes": 0
            },
            "miss": {
                "responses": 3911938,
                "bytes": 154562775056,
                "responses_written": 1365246,
                "bytes_written": 57700783273
            },
            "expired": {
                "responses": 318649,
                "bytes": 11871676705,
                "responses_written": 292442,
                "bytes_written": 11646995273
            },
            "bypass": {
                "responses": 518402,
                "bytes": 20493958220,
                "responses_written": 517569,
                "bytes_written": 20493836473
            }
        }
    },
    "stream": {
        "server_zones": {
            "postgresql_loadbalancer": {
                "processing": 0,
                "connections": 506057,
                "received": 53642042,
                "sent": 3762321433
            },
            "dns_loadbalancer": {
                "processing": 0,
                "connections": 290631,
                "received": 7846956,
                "sent": 36342172
            }
        },
        "upstreams": {
            "postgresql_backends": {
                "peers": [
                    {
                        "id": 0,
                        "server": "10.0.0.2:15432",
                        "backup": false,
                        "weight": 1,
                        "state": "up",
                        "active": 0,
                        "max_conns": 42,
                        "connections": 76582,
                        "connect_time": 127,
                        "first_byte_time": 139,
                        "response_time": 139,
                        "sent": 8117692,
                        "received": 566806435,
                        "fails": 0,
                        "unavail": 0,
                        "health_checks": {
                            "checks": 101531,
                            "fails": 0,
                            "unhealthy": 0,
                            "last_passed": true
                        },
                        "downtime": 0,
                        "downstart": 0,
                        "selected": 1470103445000
                    },
                    {
                        "id": 1,
                        "server": "10.0.0.2:15433",
                        "backup": false,
                        "weight": 1,
                        "state": "up",
                        "active": 0,
                        "connections": 214738,
                        "connect_time": 2,
                        "first_byte_time": 5,
                        "response_time": 5,
                        "sent": 22762228,
                        "received": 1597761177,
                        "fails": 0,
                        "unavail": 0,
                        "health_checks": {
                            "checks": 101531,
                            "fails": 0,
                            "unhealthy": 0,
                            "last_passed": true
                        },
                        "downtime": 0,
                        "downstart": 0,
                        "selected": 1470380827000
                    },
                    {
                        "id": 2,
                        "server": "10.0.0.2:15434",
                        "backup": false,
                        "weight": 1,
                        "state": "up",
                        "active": 0,
                        "connections": 214737,
                        "connect_time": 1,
                        "first_byte_time": 20,
                        "response_time": 20,
                        "sent": 22762122,
                        "received": 1597753821,
                        "fails": 0,
                        "unavail": 0,
                        "health_checks": {
                            "checks": 101531,
                            "fails": 0,
                            "unhealthy": 0,
                            "last_passed": true
                        },
                        "downtime": 0,
                        "downstart": 0,
                        "selected": 1470380826000
                    },
                    {
                        "id": 3,
                        "server": "10.0.0.2:15435",
                        "backup": false,
                        "weight": 1,
                        "state": "down",
                        "active": 0,
                        "connections": 0,
                        "sent": 0,
                        "received": 0,
                        "fails": 0,
                        "unavail": 0,
                        "health_checks": {
                            "checks": 0,
                            "fails": 0,
                            "unhealthy": 0
                        },
                        "downtime": 0,
                        "downstart": 0,
                        "selected": 0
                    }
                ]
            },
            "dns_udp_backends": {
                "peers": [
                    {
                        "id": 0,
                        "server": "10.0.0.5:53",
                        "backup": false,
                        "weight": 2,
                        "state": "up",
                        "active": 0,
                        "connections": 193754,
                        "sent": 5231358,
                        "received": 24228464,
                        "fails": 0,
                        "unavail": 0,
                        "health_checks": {
                            "checks": 101486,
                            "fails": 1,
                            "unhealthy": 1,
                            "last_passed": true
                        },
                        "downtime": 5325,
                        "downstart": 0,
                        "selected": 1470380825000
                    },
                    {
                        "id": 1,
                        "server": "10.0.0.2:53",
                        "backup": false,
                        "weight": 1,
                        "state": "up",
                        "active": 0,
                        "connections": 96874,
                        "sent": 2615598,
                        "received": 12113708,
                        "fails": 0,
                        "unavail": 0,
                        "health_checks": {
                            "checks": 101485,
                            "fails": 3,
                            "unhealthy": 2,
                            "last_passed": true
                        },
                        "downtime": 20006,
                        "downstart": 0,
                        "selected": 1470380825000
                    },
                    {
                        "id": 2,
                        "server": "10.0.0.7:53",
                        "backup": false,
                        "weight": 1,
                        "state": "down",
                        "active": 0,
                        "connections": 0,
                        "sent": 0,
                        "received": 0,
                        "fails": 0,
                        "unavail": 0,
                        "health_checks": {
                            "checks": 0,
                            "fails": 0,
                            "unhealthy": 0
                        },
                        "downtime": 0,
                        "downstart": 0,
                        "selected": 0
                    }
                ]
            },
            "unused_tcp_backends": {
                "peers": [
                    {
                        "id": 1,
                        "server": "95.211.80.227:80",
                        "backup": false,
                        "weight": 1,
                        "state": "down",
                        "active": 0,
                        "connections": 0,
                        "sent": 0,
                        "received": 0,
                        "fails": 0,
                        "unavail": 0,
                        "health_checks": {
                            "checks": 0,
                            "fails": 0,
                            "unhealthy": 0
                        },
                        "downtime": 0,
                        "downstart": 0,
                        "selected": 0
                    },
                    {
                        "id": 2,
                        "server": "206.251.255.63:80",
                        "backup": false,
                        "weight": 1,
                        "state": "down",
                        "active": 0,
                        "connections": 0,
                        "sent": 0,
                        "received": 0,
                        "fails": 0,
                        "unavail": 0,
                        "health_checks": {
                            "checks": 0,
                            "fails": 0,
                            "unhealthy": 0
                        },
                        "downtime": 0,
                        "downstart": 0,
                        "selected": 0
                    },
                    {
                        "id": 3,
                        "server": "[2001:1af8:4060:a004:21::e3]:80",
                        "backup": false,
                        "weight": 1,
                        "state": "down",
                        "active": 0,
                        "connections": 0,
                        "sent": 0,
                        "received": 0,
                        "fails": 0,
                        "unavail": 0,
                        "health_checks": {
                            "checks": 0,
                            "fails": 0,
                            "unhealthy": 0
                        },
                        "downtime": 0,
                        "downstart": 0,
                        "selected": 0
                    }
                ]
            }
        }
    }
}
```
