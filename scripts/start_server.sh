#!/bin/bash
echo ls
echo "GOING BACK A LEVEL"
cd ..
echo ls
echo "SHOULD BE IN MAIN APP FOLDER"
nohup sudo bundle exec rackup -p80 -o 0.0.0.0 &
echo "Hello"