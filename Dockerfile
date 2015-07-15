FROM phusion/passenger-ruby22

MAINTAINER Dmitry Ustalov <dmitry@eveel.ru>

CMD ["/sbin/my_init"]

ENV RACK_ENV production

RUN \
apt-get update && \
apt-get install -y -o Dpkg::Options::="--force-confold" libraptor2-0 && \
apt-get clean && \
rm -rf /var/lib/apt/lists/* && \
rm -f /etc/nginx/sites-enabled/default /etc/service/nginx/down && \
mkdir -p /home/app/yarn

WORKDIR /home/app/yarn

COPY Gemfile* /home/app/yarn/

RUN bundle install --deployment --without 'development test' --jobs 4

COPY . /home/app/yarn/

RUN \
mv -fv docker/database.yml /home/app/yarn/config/database.yml && \
mv -fv docker/*-env.conf /etc/nginx/main.d/ && \
mv -fv docker/yarn.conf /etc/nginx/sites-enabled/yarn.conf && \
mv -fv docker/yarn.yml.sh /home/app/yarn/bin/yarn.yml.sh && \
mv -fv docker/rc.local /etc/rc.local && \
mv -fv docker/export-*.sh docker/merit-ranks.sh docker/refresh-scores.sh /home/app/yarn/bin/

RUN bin/rake assets:precompile

RUN \
rm -rf /tmp/* /var/tmp/* && \
mkdir -p /home/app/yarn/log && \
chown -R app:app /home/app
