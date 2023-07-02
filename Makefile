

.PHONY: build
build:
	@echo "Building..."
	@jupyter lite build --contents=content --force -y 

.PHONY: serve
serve:
	@echo "Serving..."
	@jupyter lite serve

.PHONY: clean
clean:
	@echo "Cleaning..."
	@rm -rf ./_output /tmp/text_analytics-main /tmp/text_analytics.zip

.PHONY: rebuild
rebuild: clean build serve
	@echo "Serving..."

.PHONY: notebooks
notebooks: download
	@echo "Generating notebooks..."
	@mkdir -p ./content/notebooks
	@find /tmp/text_analytics-main/notebooks/ -name "*.ipynb" -exec mv -f \{\} ./content/notebooks/ \;
	@echo "Done."

download:
	@echo "Downloading notebooks..."
	@rm -rf /tmp/text_analytics-main
	@wget -O /tmp/text_analytics.zip https://github.com/inidun/text_analytics/archive/master.zip
	@unzip /tmp/text_analytics.zip -d /tmp
	@echo "rm -rf /tmp/text_analytics-main /tmp/text_analytics.zip"
