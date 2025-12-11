# Marp Presentation Build Makefile
# ================================

# Marp CLI command
MARP := npx @marp-team/marp-cli@latest

# Theme directory
THEME_DIR := .marp/themes

# Output directory
OUTPUT_DIR := output

# Source files (Marp presentations only)
SOURCES := index.md primary.md slash_command.md custom_tools.md context_keep_clean.md

# Generate output file names
HTML_OUTPUTS := $(SOURCES:%.md=$(OUTPUT_DIR)/%.html)
PDF_OUTPUTS := $(SOURCES:%.md=$(OUTPUT_DIR)/%.pdf)

# Default target: build all HTML
.PHONY: all
all: html

# Create output directory
$(OUTPUT_DIR):
	mkdir -p $(OUTPUT_DIR)

# Build all HTML files
.PHONY: html
html: $(OUTPUT_DIR) $(HTML_OUTPUTS)

# Build all PDF files
.PHONY: pdf
pdf: $(OUTPUT_DIR) $(PDF_OUTPUTS)

# Pattern rule for HTML generation
$(OUTPUT_DIR)/%.html: %.md $(THEME_DIR)/kouen.css
	$(MARP) $< -o $@

# Pattern rule for PDF generation
$(OUTPUT_DIR)/%.pdf: %.md $(THEME_DIR)/kouen.css
	$(MARP) $< --pdf -o $@

# Preview a specific presentation (usage: make preview FILE=index.md)
.PHONY: preview
preview:
	$(MARP) $(FILE) --preview

# Clean output directory
.PHONY: clean
clean:
	rm -rf $(OUTPUT_DIR)

# Help
.PHONY: help
help:
	@echo "Marp Presentation Build Commands:"
	@echo "  make          - Build all HTML presentations"
	@echo "  make html     - Build all HTML presentations"
	@echo "  make pdf      - Build all PDF presentations"
	@echo "  make preview FILE=<file.md> - Preview a presentation"
	@echo "  make clean    - Remove output directory"
	@echo ""
	@echo "Available presentations:"
	@echo "  $(SOURCES)"
