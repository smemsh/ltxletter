#

define VERSION 1.2.0
endef

BASENAME	= $(basename $(wildcard *.txt))
FILTER1		= a2ltx.sed
FILTER2		= abulleted2ltx.awk
TXTNAME		= $(BASENAME).txt
LTXNAME		= $(BASENAME).ltx
PDFNAME		= $(BASENAME).pdf
DVINAME		= $(BASENAME).dvi
ESCNAME1	= $(BASENAME)-escaped1.ltx
ESCNAME2	= $(BASENAME)-escaped2.ltx
PREM4NAME	= $(BASENAME)-header.ltx

$(PDFNAME): $(LTXNAME) $(ESCNAME2)
	latex --output-format=pdf $(LTXNAME)

dvi: $(DVINAME)

$(DVINAME): $(LTXNAME) $(ESCNAME2)
	latex --output-format=dvi $(LTXNAME)

$(LTXNAME): $(PREM4NAME)
	m4 -D __M4SUB_ESCAPED_NAME__=$(ESCNAME2) < $(PREM4NAME) > $(LTXNAME)

$(ESCNAME2): $(TXTNAME)
	$(FILTER1) < $(TXTNAME) > $(ESCNAME1)
	$(FILTER2) < $(ESCNAME1) > $(ESCNAME2)

clean:
	rm -f				\
		$(ESCNAME1)		\
		$(ESCNAME2)		\
		$(PDFNAME)		\
		$(DVINAME)		\
		$(LTXNAME)		\
		$(BASENAME).log		\
		$(BASENAME).aux
