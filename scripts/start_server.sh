#!/bin/bash
cd ..
nohup sudo bundle exec rackup -p80 -o 0.0.0.0 &
echo "Hello"