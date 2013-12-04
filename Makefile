# -*- mode: makefile; -*-
EMACS=emacs
README_tangles = README.el \
	latex.d/lecture-style.sty latex.d/org-preamble.sty

.SECONDARY: $(README_tangles)
$(README_tangles): README.org
	@$(EMACS) --batch --no-init-file \
	--eval "(require 'org)" \
	--eval "(org-babel-do-load-languages 'org-babel-load-languages '((sh . t)))" \
	--eval "(setq org-confirm-babel-evaluate nil)" \
	--eval "(org-babel-tangle-file \"$<\")"

files_org = $(wildcard td*.org)
files_pdf = $(files_org:.org=.pdf)

all: pdf

pdf: $(files_pdf)

$(files_pdf): %.pdf: %.org README.el
	@echo "NOTICE: Exporting $< to pdf..."
	@$(EMACS) --batch --no-init-file --load=$(lastword $^) --visit "$<" --funcall npp-export-classes
#> /dev/null 2>&1

clean:
	@rm -rf	latex.d *.tex *.pdf *.fdb* *~ $(README_tangles)

.PHONY: all pdf clean
