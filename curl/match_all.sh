#!/usr/bin/env bash
curl \
--request GET \
--data '{"query":{"match_all":{}},"sort":[{"release_date":{"order":"asc"}}],"from": 10,"size": 10}' \
--url http://localhost:9200/movies/_search \
| jq '.'