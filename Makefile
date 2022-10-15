.PHONY: docs lint reformat requirements functional-tests

docs:
	git submodule sync
	git submodule update --init --force repository-service-tuf-worker repository-service-tuf-api repository-service-tuf-cli

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

	plantuml -o ../source/_static/ -tpng docs/diagrams/*rstuf.puml
	sphinx-build -T -E -b html docs/source docs/build/html

requirements:
	pipenv requirements > requirements.txt

reformat:
	isort -l79 --profile black tests/
	black -l79 tests/

lint:
	flake8 tests/
	isort -l79 --profile black --check --diff tests/
	black -l79 --check --diff tests/
	pipenv requirements > requirements.commit
	diff requirements.txt requirements.commit
	rm requirements.commit

functional-tests:
	pytest --gherkin-terminal-reporter tests -vvv