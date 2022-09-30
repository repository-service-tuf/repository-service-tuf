.PHONY: all docs

docs:
	git submodule foreach git pull origin main

	# tuf-repository-service-cli
	cp -r tuf-repository-service-cli/docs/diagrams/* docs/diagrams/
	rm -rf docs/source/guide/tuf-repository-service-cli/*
	cp -r tuf-repository-service-cli/docs/source/guide/* docs/source/guide/tuf-repository-service-cli/
	cp -r tuf-repository-service-cli/docs/source/devel/design.rst docs/source/devel/tuf-repository-service-cli_design.rst

	# tuf-repository-service-api
	cp -r tuf-repository-service-api/docs/diagrams/* docs/diagrams/
	rm -rf docs/source/guide/tuf-repository-service-api/*
	cp -r tuf-repository-service-api/docs/source/guide/* docs/source/guide/tuf-repository-service-api/
	cp -r tuf-repository-service-api/docs/source/devel/design.rst docs/source/devel/tuf-repository-service-api_design.rst

	# tuf-repository-service-worker
	cp -r tuf-repository-service-worker/docs/diagrams/* docs/diagrams/
	rm -rf docs/source/guide/tuf-repository-service-worker/*
	cp -r tuf-repository-service-worker/docs/source/guide/* docs/source/guide/tuf-repository-service-worker/
	cp -r tuf-repository-service-worker/docs/source/devel/design.rst docs/source/devel/tuf-repository-service-worker_design.rst

	sphinx-build -E -W -b html docs/source docs/build/html
	plantuml -tpng docs/diagrams/1_1_trs.puml

requirements:
	pipenv lock -r > requirements-docs.txt