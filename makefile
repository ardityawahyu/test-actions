SHELL = /bin/bash
DOCSFILES = $(shell find docs -name '*.mmd')
GENERATEDFILES = $(shell find docs -name '*.svg')

.PHONY: mermaid
mermaid: 
	@echo "Generating docs mermaid JS"
	$(foreach doc,$(DOCSFILES),$(shell mmdc -i $(doc) -o $(doc:%.mmd=%.svg)))
	$(foreach doc,$(GENERATEDFILES),$(shell echo $(doc)))