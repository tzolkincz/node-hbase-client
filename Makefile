TESTS = test/*.test.js
REPORTER = spec
TIMEOUT = 15000
MOCHA_OPTS =

install:
	@npm install

jshint: install
	@./node_modules/.bin/jshint . | true

test: install
	@NODE_ENV=test ./node_modules/.bin/mocha \
		--reporter $(REPORTER) \
		--timeout $(TIMEOUT) \
		$(MOCHA_OPTS) \
		$(TESTS)

test-cov cov: install
	@NODE_ENV=test node --harmony \
		node_modules/.bin/istanbul cover --preserve-comments \
		./node_modules/.bin/_mocha \
		-- -u exports \
		--reporter $(REPORTER) \
		--timeout $(TIMEOUT) \
		$(MOCHA_OPTS) \
		$(TESTS)
	@./node_modules/.bin/cov coverage

test-all: jshint test test-cov

test-coveralls:
	@$(MAKE) test
	@echo TRAVIS_JOB_ID $(TRAVIS_JOB_ID)
	@$(MAKE) test MOCHA_OPTS='--require blanket' REPORTER=mocha-lcov-reporter | ./node_modules/coveralls/bin/coveralls.js

contributors: install
	@./node_modules/.bin/contributors -f plain -o AUTHORS

autod: install
	@./node_modules/.bin/autod -w -e examples -k zookeeper-watcher --prefix "~"

.PHONY: test
