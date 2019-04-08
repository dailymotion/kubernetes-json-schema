#!/bin/bash -xe

# This script uses openapi2jsonschema to generate a set of JSON schemas for
# the specified Kubernetes versions in three different flavours:
#
#   X.Y.Z - URL referenced based on the specified GitHub repository
#   X.Y.Z-standalone - de-referenced schemas, more useful as standalone documents
#   X.Y.Z-local - relative references, useful to avoid the network dependency

REPO="garethr/kubernetes-json-schema"

declare -a arr=(master
                v1.13.2
                v1.11.5
                v1.10.5
                )

for version in "${arr[@]}"
do
    schema=https://raw.githubusercontent.com/kubernetes/kubernetes/${version}/api/openapi-spec/swagger.json
    prefix=https://raw.githubusercontent.com/${REPO}/master/${version}/_definitions.json

    openapi2jsonschema -o "${version}-standalone-strict" --kubernetes --stand-alone --strict "${schema}"
    openapi2jsonschema -o "${version}-standalone" --kubernetes --stand-alone "${schema}"
    openapi2jsonschema -o "${version}-local" --kubernetes "${schema}"
    openapi2jsonschema -o "${version}" --kubernetes --prefix "${prefix}" "${schema}"
done
