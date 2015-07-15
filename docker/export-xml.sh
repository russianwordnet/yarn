#!/bin/bash -le
cd /home/app/yarn
bin/rake yarn:export:xml
xz - <public/yarn-synsets.xml >public/yarn-synsets.xml.xz
chown app:app public/yarn-synsets.xml*
