#!/bin/sh

if [ -e "app.config" ]
then
    erl -pa apps/*/ebin deps/*/ebin -s newrelic_example -config app.config \
	      -eval "io:format(\"Point your browser at http://localhost:8888~n\")."
else
    echo "Please copy app.config.example to app.config and update it with your newrelic license key"
fi

