#!/bin/bash -le
cd /home/app/yarn
bin/rake yarn:export:csv
xz - <public/yarn-synsets.csv >public/yarn-synsets.csv.xz
chown app:app public/yarn-synsets.csv*
