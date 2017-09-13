#!/bin/bash
(cd .. && cd .. && cd .. && cd .. && cd .. && cd .. && cd .. && cd .. && cd .. && cd /var/www && nohup sudo bundle install && sudo ruby app.rb -o 0.0.0.0 &)
expect "nohup: ignoring input and appending output to '/home/ubuntu/nohup.out'" { send "\r" }
echo "working?"
exit 0

