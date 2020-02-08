all: yarn.xml yarn-synsets.csv
	docker-compose run --rm jekyll

yarn.xml:
	curl -sLO 'https://github.com/russianwordnet/yarn/releases/download/eol/yarn.xml'

yarn-synsets.csv:
	curl -sLO 'https://github.com/russianwordnet/yarn/releases/download/eol/yarn-synsets.csv'
