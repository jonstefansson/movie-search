#!/usr/bin/env bash
curl \
--request GET \
--url http://localhost:9200/movies/movie/AVaLvl5ifjaj2SZIF3sY \
| jq '.'
