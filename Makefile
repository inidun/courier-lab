include .env

SHELL := /bin/bash

lint: tidy pylint

tidy: black isort

requirements.txt: poetry.lock
	@poetry export --without-hashes -f requirements.txt --output requirements.txt

bump.patch: requirements.txt
	@poetry version patch
	@git add pyproject.toml requirements.txt
	@git commit -m "📌 bump version patch"
	@git push

.PHONY: build
build:
	@echo "Building..."
	@poetry run jupyter lite build --contents=content --force -y

.PHONY: serve
serve:
	@echo "Serving..."
	@poetry run python -m http.server 8080 --directory _output

# @jupyter lite serve

.PHONY: clean
clean:
	@echo "Cleaning..."
	@rm -rf ./_output /tmp/text_analytics-main /tmp/text_analytics.zip

.PHONY: rebuild
rebuild: clean build serve
	@echo "Serving..."

.PHONY: notebooks
notebooks: download-notebooks
	@echo "Generating notebooks..."
	@mkdir -p ./content/notebooks
	@find /tmp/text_analytics-main/notebooks/ -name "*.ipynb" -exec mv -f \{\} ./content/notebooks/ \;
	@echo "Done."

.PHONY: download-notebooks
download-notebooks:
	@echo "Downloading notebooks..."
	@rm -rf /tmp/text_analytics-main
	@wget -O /tmp/text_analytics.zip https://github.com/inidun/text_analytics/archive/master.zip
	@unzip /tmp/text_analytics.zip -d /tmp
	@echo "rm -rf /tmp/text_analytics-main /tmp/text_analytics.zip"
