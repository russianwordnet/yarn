#!/bin/bash -le
cd /home/app/yarn
bin/rails r 'Merit::RankRules.new.check_rank_rules'
