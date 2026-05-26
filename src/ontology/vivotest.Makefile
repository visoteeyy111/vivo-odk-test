## Customize Makefile settings for vivotest

mirror-geopolitical: | $(TMPDIR)
	robot extract \
		--method BOT \
		--input vivo-core-extracted.ofn \
		--term-file imports/geopolitical_terms.txt \
		--force true \
		--individuals include \
		--output $(TMPDIR)/mirror-geopolitical.owl
mirror-statistics: | $(TMPDIR)
	robot extract \
		--method BOT \
		--input vivo-core-extracted.ofn \
		--term-file imports/statistics_terms.txt \
		--force true \
		--individuals include \
		--output $(TMPDIR)/mirror-statistics.owl
mirror-study_protocol: | $(TMPDIR)
	robot extract \
		--method BOT \
		--input vivo-core-extracted.ofn \
		--term-file imports/study_protocol_terms.txt \
		--force true \
		--individuals include \
		--output $(TMPDIR)/mirror-study_protocol.owl
mirror-dcterms: | $(TMPDIR)
	robot extract \
		--method BOT \
		--input vivo-core-extracted.ofn \
		--term-file imports/dcterms_terms.txt \
		--force true \
		--individuals include \
		--output $(TMPDIR)/mirror-dcterms.owl
mirror-vitro: | $(TMPDIR)
	robot extract \
		--method BOT \
		--input vivo-core-extracted.ofn \
		--term-file imports/vitro_terms.txt \
		--force true \
		--individuals include \
		--output $(TMPDIR)/mirror-vitro.owl
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

VIOLATION_QUERIES = owldef-self-reference \
                    iri-range \
                    label-with-iri \
                    multiple-replaced_by \
                    dc-properties \
                    missing-label \
                    duplicate-label \
                    missing-definition \
                    deprecated-no-replacement \
                    rdfs-comment-instead-of-def

.PHONY: violation-reports
violation-reports: $(patsubst %, $(REPORTDIR)/%-violation.tsv, $(VIOLATION_QUERIES))

$(REPORTDIR)/%-violation.tsv: $(SPARQLDIR)/%-violation.sparql $(SRCMERGED) | $(REPORTDIR)
	$(ROBOT) query --use-graphs true \
	  --input $(SRCMERGED) \
	  --query $< $@

.PHONY: check-violations
check-violations: violation-reports
	@for f in $(patsubst %, $(REPORTDIR)/%-violation.tsv, $(VIOLATION_QUERIES)); do \
	  COUNT=$$(tail -n +2 "$$f" | grep -c '.'); \
	  if [ "$$COUNT" -gt 0 ]; then \
	    echo "VIOLATION FOUND in $$f ($$COUNT row(s))"; \
	    cat "$$f"; \
	    exit 1; \
	  fi; \
	done
	@echo "All violation checks passed."