SCHEME = AStar
DOCC_DIR = ./docs
WORKSPACE = $(PWD)/$(SCHEME).workspace
SKIPS = -skipMacroValidation -skipPackagePluginValidation

test:
	swift test --parallel

docc:
	DOCC_JSON_PRETTYPRINT="YES" \
	swift package \
		--allow-writing-to-directory $(DOCC_DIR) \
		generate-documentation \
		--target $(SCHEME) \
		--transform-for-static-hosting \
		--output-path $(DOCC_DIR)

clean:
	rm -rf "$(WORKSPACE)"

.PHONY: test docc clean
