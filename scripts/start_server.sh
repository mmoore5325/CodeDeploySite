#!/bin/bash
(cd .. && cd .. && cd .. && cd .. && cd .. && cd .. && cd .. && cd .. && cd .. && cd /var/www && sudo bundle install && sudo ruby app.rb -o 0.0.0.0 &)
echo "working?"
exit 0

