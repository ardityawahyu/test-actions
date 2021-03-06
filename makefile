SHELL = /bin/bash
MERMAIDFILES = $(shell find docs -name '*.mmd')
ARCHFILES = $(shell find docs -name '*.py')
PWD = $(shell pwd)

.PHONY: architecture
architecture: 
	@echo "Generating architecture diagram"
	$(foreach doc,$(ARCHFILES),$(shell cat ${doc} | docker run -i --rm -v ${PWD}/docs/out:/out gtramontina/diagrams:0.20.0))

.PHONY: mermaid-diagram
mermaid-diagram:
	@echo "Creating diagram with mermaid-js $(MERMAIDFILES)"
	@$(foreach doc,$(MERMAIDFILES),docker run -u root -i --rm -v $(PWD)/docs:/data/docs -v $(PWD)/docs/out:/data/docs/out minlag/mermaid-cli:8.13.3 -i /data/$(doc) -o /data/docs/out/$(shell basename $(doc)).svg;)