# 1. Find all subdirectories with a src.tex
SOURCES := $(wildcard */src.tex)
DIRS := $(patsubst %/src.tex, %, $(SOURCES))
PDFS := $(patsubst %/src.tex, %/dic.pdf, $(SOURCES))

# 2. Generate clean targets (clean-carioca, clean-algarvio)
CLEAN_TARGETS := $(addprefix clean-, $(DIRS))

# 3. Mark all targets as phony (not real files)
.PHONY: all clean $(DIRS) $(CLEAN_TARGETS)

# --- DEFAULT TARGET ---
# "make" builds everything
all: $(PDFS)

# --- COMPILATION RULES ---

# Helper: Allow "make carioca" to build carioca/dic.pdf
$(DIRS): %: %/dic.pdf

# Main Compile Rule
# 1. Enter dir, 2. Build PDF, 3. Remove temp files (logs/aux)
%/dic.pdf: %/src.tex
	@echo "Compiling dictionary in $*..."
	cd $* && latexmk -pdf -interaction=nonstopmode -quiet -f -jobname=dic src.tex
	cd $* && latexmk -c -jobname=dic src.tex

# --- CLEAN RULES ---

# 1. "make clean" runs all specific clean targets
clean: $(CLEAN_TARGETS)

# 2. Specific Clean Rule (Static Pattern)
# This allows "make clean-carioca", "make clean-algarvio", etc.
$(CLEAN_TARGETS): clean-%:
	@echo "Cleaning specific dictionary: $*..."
	-cd $* && latexmk -C -jobname=dic src.tex
