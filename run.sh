#!/bin/sh
docker run -v $PWD:/work -w /work obolibrary/odkfull:v1.6.1 "$@"
