ODOCS=./Documentation

all:
	@echo "Targets:"
	@echo "   - build-docs: Builds the documentation"
	@echo "   - preview-docs: Start local web server serving the documentation"

build-docs:
	GENERATE_DOCS=1 swift package --allow-writing-to-directory $(ODOCS) generate-documentation --target SpectreKit --disable-indexing --transform-for-static-hosting --hosting-base-path / --emit-digest --output-path $(ODOCS) >& build-docs.log

preview-docs:
	GENERATE_DOCS=1 swift package --disable-sandbox preview-documentation --target SpectreKit --disable-indexing --emit-digest
