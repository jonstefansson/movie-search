#!/usr/bin/env bash
curl \
--request GET \
--data @- \
--url http://localhost:9200/movies/_search \
<<EOF
{
  "query": {
    "term": {"watched": true}
  },
  "sort": [
    {
      "release_date": {
        "order": "asc"
      }
    }
  ],
  "from": 0,
  "size": 10
}
EOF \
| jq '.'
