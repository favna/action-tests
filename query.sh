#!/usr/bin/env bash

set -ex

curl -sL \
    $(curl -sL \
        -H "Authorization: bearer ${GITHUB_TOKEN}" \
        -X POST \
        --data '{"query":"query { repository(owner: \"cli\", name: \"cli\") { releases(last: 1) { nodes { releaseAssets(first: 20) { nodes { downloadUrl name }}}}}}"}' "https://api.github.com/graphql" |
        jq -cr '.data.repository.releases.nodes[0].releaseAssets.nodes[]? | select(.name | contains("linux_amd64.tar.gz")).downloadUrl') |
    tar -xz --wildcards "*gh" && mv gh*linux_amd64/bin/gh . && rm -r gh_*linux_amd64
