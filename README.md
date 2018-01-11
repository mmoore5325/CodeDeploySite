# Attempt at deploying Sinatra with AWS Code Deploy
Saw someone starred this so I thought I would let anyone else
know interested know where it went wrong.  I need to install nginx proxied
to unicorn.  It works up until the point where code deploy looks for
server restart, and if you look at any other code deploy git,
using any language, they either use nginx or apache, most apache.
But to get Code Deploy to work with Ruby and Sinatra, you need to set
it up with nginx or apache.  
