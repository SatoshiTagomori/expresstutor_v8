sudo kill `head -n 1 /home/gakuto/workspace/expresstutor_v8/tmp/unicorn.pid`;
cd /home/gakuto/workspace/expresstutor_v8/;
bundle exec unicorn_rails -c /home/gakuto/workspace/expresstutor_v8/config/unicorn.rb -p 3000 -E production -D
