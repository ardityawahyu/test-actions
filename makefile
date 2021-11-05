SHELL = /bin/bash
MERMAIDFILES = $(shell find docs -name '*.mmd')
ARCHFILES = $(shell find docs -name '*.py')
PWD = $(shell pwd)

.PHONY: architecture
architecture: 
	@echo "Generating architecture diagram"
	$(foreach doc,$(ARCHFILES),$(shell cat ${doc} | docker run -i --rm -v ${PWD}/docs:/out gtramontina/diagrams:0.20.0))

.PHONY: mermaid-diagram
mermaid-diagram:
	@echo "Creating diagram with mermaid-js"
	$(foreach doc,$(MERMAIDFILES),$(shell docker run -i --rm -v ${PWD}:/data minlag/mermaid-cli:8.13.3 -i /data/${doc}))