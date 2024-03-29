.PHONY: docs lint reformat requirements functional-tests sync-submodules

run-dev: export API_VERSION=dev
run-dev: export WORKER_VERSION=dev
run-dev:
	docker compose up -d

stop:
	docker compose down -v

clean:
	$(MAKE) stop
	docker compose rm --force
	rm -rf ./data
	rm -rf ./data_test


sync-submodules:
	git submodule sync
	git submodule update --init --force --recursive
	git submodule foreach git pull origin main

docs:
	# repository-service-tuf-cli
	cp -r repository-service-tuf-cli/docs/diagrams/* docs/diagrams/
	rm -rf docs/source/guide/repository-service-tuf-cli/*
	cp -r repository-service-tuf-cli/docs/source/guide/* docs/source/guide/repository-service-tuf-cli/

	# repository-service-tuf-api
	cp -r repository-service-tuf-api/docs/diagrams/* docs/diagrams/
	rm -rf docs/source/guide/repository-service-tuf-api/*
	cp -r repository-service-tuf-api/docs/source/guide/* docs/source/guide/repository-service-tuf-api/

	# repository-service-tuf-worker
	cp -r repository-service-tuf-worker/docs/diagrams/* docs/diagrams/
	rm -rf docs/source/guide/repository-service-tuf-worker/*
	cp -r repository-service-tuf-worker/docs/source/guide/* docs/source/guide/repository-service-tuf-worker/

	plantuml -o ../source/_static/ -tpng docs/diagrams/*.puml
	sphinx-build -T -E -b html docs/source docs/build/html

requirements:
	pipenv lock
	pipenv requirements > requirements.txt

reformat:
	isort -l79 --profile black tests/
	black -l79 tests/

lint:
	flake8 tests/
	isort -l79 --profile black --check --diff tests/
	black -l79 --check --diff tests/
	pipenv requirements > requirements.commit
	diff -w requirements.txt requirements.commit
	rm requirements.commit

functional-tests-exitfirst:
ifeq ($(SLOW),)
	echo "Running fast tests"
	# `splits` and the `pytest-group` matrix on CI should match
	pytest --exitfirst --splits 3 --group $(PYTEST_GROUP) --store-durations --durations-path=./.test_durations.$(PYTEST_GROUP) --deselect=tests/functional/artifacts/test_performance.py::test_api_requester_multiple_request_and_artifacts[50-50-600] tests -vvv --cucumberjson=test-report.json --durations=0 --html=test-report.html
else
	echo "Running slow tests"
	pytest --exitfirst tests/functional/artifacts/test_performance.py::test_api_requester_multiple_request_and_artifacts[50-50-600] -vvv --cucumberjson=test-report.json --durations=0 --html=test-report.html
endif

functional-tests:
	pytest --gherkin-terminal-reporter tests -vvv --cucumberjson=test-report.json --durations=0 --html=test-report.html

# CLI_VERSION enables using specific RSTUF CLI version, default: dev
# usage: `make ft-das CLI_VERSION=v0.8.0b1`
ft-das:
ifneq ($(CLI_VERSION),)
	docker compose run --env UMBRELLA_PATH=. --rm rstuf-ft-runner bash tests/functional/scripts/run-ft-das.sh dev $(PYTEST_GROUP) $(SLOW)
else
	docker compose run --env UMBRELLA_PATH=. --rm rstuf-ft-runner bash tests/functional/scripts/run-ft-das.sh $(CLI_VERSION) $(PYTEST_GROUP) $(SLOW)
endif

ft-signed:
ifneq ($(CLI_VERSION),)
	docker compose run --env UMBRELLA_PATH=. --rm rstuf-ft-runner bash tests/functional/scripts/run-ft-signed.sh dev $(PYTEST_GROUP) $(SLOW)
else
	docker compose run --env UMBRELLA_PATH=. --rm rstuf-ft-runner bash tests/functional/scripts/run-ft-signed.sh $(CLI_VERSION) $(PYTEST_GROUP) $(SLOW)
endif