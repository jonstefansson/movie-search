#!/usr/bin/env bash
curl \
--request GET \
--data @- \
--url http://localhost:9200/movies/_search \
<<EOF | jq '.hits.hits | map_values({id: ._id, title: ._source.title})'
{
  "query": {
    "bool": {
      "must": {
        "match_all": {}
      },
      "filter": {
        "bool": {
          "must_not": {
            "term": {"watched": true}
          }
        }
      }
    }
  },
  "sort": [
    {
      "release_date": {
        "order": "asc"
      }
    }
  ],
  "from": 0,
  "size": 30
}
EOF
