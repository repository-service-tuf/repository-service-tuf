.PHONY: all docs

docs:
	git submodule update --init --recursive
	git submodule foreach git pull origin main
	ls -la kaprien-cli/
	# kaprien-cli
	cp -r kaprien-cli/docs/diagrams/* docs/diagrams/
	rm -rf docs/source/guide/kaprien-cli/*
	cp -r kaprien-cli/docs/source/guide/* docs/source/guide/kaprien-cli/
	cp -r kaprien-cli/docs/source/devel/design.rst docs/source/devel/kaprien-cli_design.rst

	# kaprien-rest-api
	cp -r kaprien-rest-api/docs/diagrams/* docs/diagrams/
	rm -rf docs/source/guide/kaprien-rest-api/*
	cp -r kaprien-rest-api/docs/source/guide/* docs/source/guide/kaprien-rest-api/
	cp -r kaprien-rest-api/docs/source/devel/design.rst docs/source/devel/kaprien-rest-api_design.rst

	# kaprien-repo-worker
	cp -r kaprien-repo-worker/docs/diagrams/* docs/diagrams/
	rm -rf docs/source/guide/kaprien-repo-worker/*
	cp -r kaprien-repo-worker/docs/source/guide/* docs/source/guide/kaprien-repo-worker/
	cp -r kaprien-repo-worker/docs/source/devel/design.rst docs/source/devel/kaprien-repo-worker_design.rst

	sphinx-build -E -W -b html docs/source docs/build/html
	plantuml -tpng docs/diagrams/1_1_kaprien.puml

requirements:
	pipenv lock -r > requirements-docs.txt