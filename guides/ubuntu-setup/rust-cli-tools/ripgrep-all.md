# Ripgrep-all - Extended Search Tool Installation and Setup Guide

## Overview

**Ripgrep-all** (rga) is a line-oriented search tool that recursively searches your current directory for a regex pattern while respecting your gitignore rules. It's built on top of ripgrep and adds support for searching inside various file formats including PDFs, EPUB books, ZIP archives, and more.

### Key Features
- **Multi-format support**: Search inside PDFs, EPUB, ZIP, Office documents, and more
- **Speed**: Built on ripgrep's fast search engine
- **Caching**: Intelligent caching to avoid re-extracting files
- **Preprocessing**: Automatic text extraction from various file formats
- **Gitignore support**: Respects .gitignore patterns
- **Cross-platform**: Works on Linux, macOS, and Windows

### Why Use Ripgrep-all?
- Search inside files that regular grep/ripgrep can't handle
- Find text in document archives and compressed files
- Great for research and document management
- Maintains ripgrep's performance characteristics
- Seamless integration with existing workflows
- Intelligent caching reduces repeated processing

## Installation

### Prerequisites
- `ripgrep` (rg) must be installed
- Various format-specific tools (installed automatically or manually)

### Via Mise (Recommended)
```bash
# Install ripgrep-all via mise
mise use -g ripgrep-all

# Verify installation
rga --version
```

### Manual Installation
```bash
# Install via cargo
cargo install ripgrep-all

# Or download binary release
curl -L https://github.com/phiresky/ripgrep-all/releases/latest/download/ripgrep-all-v0.9.6-x86_64-unknown-linux-musl.tar.gz | tar xz
sudo mv rga /usr/local/bin/

# Install format-specific dependencies
sudo apt-get install pandoc poppler-utils ffmpeg
```

### Install Additional Dependencies
```bash
# For PDF support
sudo apt-get install poppler-utils

# For Office documents
sudo apt-get install pandoc

# For audio/video metadata
sudo apt-get install ffmpeg

# For image text extraction (OCR)
sudo apt-get install tesseract-ocr

# For various archive formats
sudo apt-get install unzip p7zip-full
```

### Verify Installation
```bash
# Test basic functionality
rga --version

# Test with a simple search
rga "search term" .

# Check available adapters
rga --list-adapters
```

## Configuration

### Shell Integration
```bash
# Add to ~/.bashrc or ~/.zshrc
alias search='rga'
alias searchall='rga --type-all'
alias searchpdf='rga --type pdf'

# Function for common search patterns
search_docs() {
    local pattern="$1"
    local dir="${2:-.}"
    rga --type pdf --type docx --type epub "$pattern" "$dir"
}

# Function for archive search
search_archives() {
    local pattern="$1"
    local dir="${2:-.}"
    rga --type zip --type tar --type gz "$pattern" "$dir"
}
```

### Configuration File
```bash
# Create rga config directory
mkdir -p ~/.config/rga

# Create configuration file
cat > ~/.config/rga/config.toml << 'EOF'
# Ripgrep-all configuration
[cache]
# Cache directory
dir = "~/.cache/rga"
# Max cache size (in MB)
max_size = 1000

[adapters]
# Enable/disable specific adapters
pdf = true
zip = true
epub = true
docx = true
ffmpeg = true
EOF
```

## Basic Usage

### Simple Searches
```bash
# Search in current directory
rga "search pattern"

# Search in specific directory
rga "pattern" /path/to/directory

# Search in specific file
rga "pattern" document.pdf

# Case-insensitive search
rga -i "pattern"
```

### File Type Filtering
```bash
# Search only PDF files
rga --type pdf "pattern"

# Search only archive files
rga --type zip --type tar "pattern"

# Search only Office documents
rga --type docx --type xlsx "pattern"

# Exclude specific file types
rga --type-not pdf "pattern"
```

### Output Control
```bash
# Show line numbers
rga -n "pattern"

# Show file names only
rga -l "pattern"

# Show context lines
rga -C 3 "pattern"

# Show only matches (no filenames)
rga -o "pattern"
```

## Advanced Usage

### Format-Specific Searches
```bash
# Search in PDF files
rga --type pdf "research paper" ~/Documents/

# Search in EPUB books
rga --type epub "character name" ~/Books/

# Search in ZIP archives
rga --type zip "config" ~/Downloads/

# Search in Office documents
rga --type docx --type xlsx "budget" ~/Work/
```

### Caching and Performance
```bash
# Enable caching (default)
rga --cache "pattern"

# Disable caching for one-time searches
rga --no-cache "pattern"

# Clear cache
rga --cache-clear

# Show cache statistics
rga --cache-stats
```

### Advanced Filtering
```bash
# Use regex patterns
rga "email.*@.*\.com" --type pdf

# Search with multiple patterns
rga "pattern1|pattern2" --type docx

# Search with word boundaries
rga "\bword\b" --type epub

# Search with case sensitivity
rga -s "ExactCase" --type pdf
```

### Integration with Other Tools
```bash
# Combine with other commands
rga "pattern" --type pdf | head -20

# Use with xargs for processing
rga -l "pattern" --type pdf | xargs -I {} cp {} ~/matches/

# Count matches
rga "pattern" --type pdf | wc -l

# Sort results
rga "pattern" --type pdf | sort
```

### Scripting and Automation
```bash
#!/bin/bash
# Document search script

search_research() {
    local query="$1"
    local dir="${2:-~/Documents}"
    
    echo "=== Searching for '$query' in documents ==="
    
    # Search in PDFs
    echo "--- PDF Results ---"
    rga --type pdf "$query" "$dir"
    
    # Search in EPUB books
    echo "--- EPUB Results ---"
    rga --type epub "$query" "$dir"
    
    # Search in Office documents
    echo "--- Office Document Results ---"
    rga --type docx --type xlsx "$query" "$dir"
}

# Archive content analysis
analyze_archives() {
    local pattern="$1"
    local archive_dir="$2"
    
    echo "Analyzing archives in $archive_dir for pattern: $pattern"
    
    # Search in ZIP files
    rga --type zip "$pattern" "$archive_dir" > zip_results.txt
    
    # Search in TAR files
    rga --type tar "$pattern" "$archive_dir" > tar_results.txt
    
    # Summary
    echo "ZIP matches: $(wc -l < zip_results.txt)"
    echo "TAR matches: $(wc -l < tar_results.txt)"
}
```

### Research and Documentation Workflows
```bash
# Academic research helper
research_search() {
    local topic="$1"
    local papers_dir="$2"
    
    echo "Searching for research on: $topic"
    
    # Search in academic papers
    rga --type pdf -i "$topic" "$papers_dir" | \
        grep -E "(abstract|introduction|conclusion)" | \
        head -20
}

# Legal document search
legal_search() {
    local term="$1"
    local docs_dir="$2"
    
    echo "Searching legal documents for: $term"
    
    # Search with context for legal analysis
    rga --type pdf --type docx -C 5 "$term" "$docs_dir" | \
        grep -E "(section|clause|paragraph)" -A 2 -B 2
}

# Technical documentation search
tech_search() {
    local api_name="$1"
    local docs_dir="$2"
    
    echo "Searching technical documentation for: $api_name"
    
    # Search in various documentation formats
    rga --type pdf --type epub --type docx \
        "$api_name" "$docs_dir" | \
        grep -E "(function|method|class|API)" | \
        head -30
}
```

### Content Management
```bash
# Document inventory
inventory_docs() {
    local dir="$1"
    
    echo "=== Document Inventory for $dir ==="
    
    # Count by file type
    echo "PDFs: $(rga --type pdf --files "$dir" | wc -l)"
    echo "EPUB: $(rga --type epub --files "$dir" | wc -l)"
    echo "DOCX: $(rga --type docx --files "$dir" | wc -l)"
    echo "ZIP: $(rga --type zip --files "$dir" | wc -l)"
}

# Duplicate content finder
find_duplicates() {
    local unique_text="$1"
    local dir="$2"
    
    echo "Finding documents with duplicate content: $unique_text"
    
    # Search for specific text across all supported formats
    rga --type-all "$unique_text" "$dir" | \
        cut -d: -f1 | sort | uniq -c | sort -nr
}
```

### Advanced Configuration
```bash
# Custom adapter configuration
configure_adapters() {
    cat > ~/.config/rga/adapters.toml << 'EOF'
[adapters.pdf]
enabled = true
command = "pdftotext"
args = ["-", "-"]

[adapters.docx]
enabled = true
command = "pandoc"
args = ["-t", "plain", "-f", "docx"]

[adapters.epub]
enabled = true
command = "pandoc"
args = ["-t", "plain", "-f", "epub"]
EOF
}

# Performance tuning
optimize_rga() {
    # Set environment variables for better performance
    export RGA_CACHE_DIR="$HOME/.cache/rga"
    export RGA_CACHE_MAX_SIZE="2000"  # 2GB
    export RGA_THREADS="$(nproc)"
    
    # Create optimized search function
    fast_search() {
        local pattern="$1"
        local dir="${2:-.}"
        
        rga --threads "$RGA_THREADS" \
            --cache-dir "$RGA_CACHE_DIR" \
            "$pattern" "$dir"
    }
}
```

## Integration Examples

### With Development Workflows
```bash
# Search in project documentation
search_project_docs() {
    local project_dir="$1"
    local search_term="$2"
    
    echo "Searching project documentation for: $search_term"
    
    # Search in README files, docs, and archives
    rga --type pdf --type docx --type zip \
        "$search_term" "$project_dir/docs" "$project_dir/README*"
}

# Configuration file search in archives
search_configs() {
    local pattern="$1"
    local dir="${2:-.}"
    
    echo "Searching for configuration patterns in archives"
    
    # Search configuration files within archives
    rga --type zip --type tar \
        "$pattern" "$dir" | \
        grep -E "\.(conf|cfg|ini|json|yaml|yml):"
}
```

### With Data Analysis
```bash
# Extract data from reports
extract_data() {
    local data_pattern="$1"
    local reports_dir="$2"
    
    echo "Extracting data matching: $data_pattern"
    
    # Search in spreadsheets and PDFs
    rga --type xlsx --type pdf \
        "$data_pattern" "$reports_dir" | \
        grep -E "[0-9]+" | \
        head -50
}

# Financial document search
search_financial() {
    local amount_pattern="$1"
    local docs_dir="$2"
    
    echo "Searching for financial data: $amount_pattern"
    
    # Search in financial documents
    rga --type pdf --type xlsx \
        "$amount_pattern" "$docs_dir" | \
        grep -E "(\$|USD|EUR|GBP)" | \
        sort | uniq
}
```

### With System Administration
```bash
# Log analysis in archives
analyze_archived_logs() {
    local error_pattern="$1"
    local archive_dir="$2"
    
    echo "Analyzing archived logs for errors: $error_pattern"
    
    # Search in compressed log archives
    rga --type zip --type tar --type gz \
        "$error_pattern" "$archive_dir" | \
        grep -E "(ERROR|WARN|FATAL)" | \
        head -100
}

# Configuration audit
audit_configs() {
    local config_pattern="$1"
    local backup_dir="$2"
    
    echo "Auditing configurations for: $config_pattern"
    
    # Search in configuration backups
    rga --type zip --type tar \
        "$config_pattern" "$backup_dir" | \
        grep -E "\.(conf|cfg|ini):" | \
        cut -d: -f1 | sort | uniq
}
```

## Troubleshooting

### Common Issues

**Issue**: Missing adapters for certain file types
```bash
# Solution: Install required dependencies
sudo apt-get install pandoc poppler-utils ffmpeg tesseract-ocr

# Check available adapters
rga --list-adapters

# Test specific adapter
rga --type pdf --debug "test" sample.pdf
```

**Issue**: Slow search performance
```bash
# Solution: Enable caching
rga --cache "pattern"

# Solution: Limit file types
rga --type pdf --type docx "pattern"

# Solution: Use more specific patterns
rga "specific.*pattern" instead of ".*"
```

**Issue**: Cache taking too much space
```bash
# Solution: Clear cache
rga --cache-clear

# Solution: Set cache size limit
export RGA_CACHE_MAX_SIZE="500"  # 500MB

# Solution: Check cache usage
rga --cache-stats
```

### Performance Tips
```bash
# Use specific file types
rga --type pdf "pattern"  # Faster than searching all types

# Enable caching for repeated searches
rga --cache "pattern"

# Use multi-threading
rga --threads 4 "pattern"

# Limit search depth
rga --max-depth 3 "pattern"
```

### Debugging
```bash
# Enable debug mode
rga --debug "pattern"

# Check adapter availability
rga --list-adapters

# Test specific file
rga --type pdf --debug "pattern" specific.pdf

# Check cache status
rga --cache-stats
```

## Comparison with Alternatives

### RGA vs Regular Ripgrep
```bash
# Regular ripgrep (text files only)
rg "pattern" 

# Ripgrep-all (includes PDFs, archives, etc.)
rga "pattern"

# RGA advantages:
# - Searches inside PDFs, EPUB, ZIP, etc.
# - Intelligent caching
# - Same performance for text files
```

### RGA vs pdfgrep
```bash
# pdfgrep (PDF only)
pdfgrep "pattern" *.pdf

# ripgrep-all (multiple formats)
rga --type pdf "pattern"

# RGA advantages:
# - Supports many more formats
# - Better integration with workflows
# - Caching for better performance
```

## Resources and References

- [Ripgrep-all GitHub Repository](https://github.com/phiresky/ripgrep-all)
- [Ripgrep-all Documentation](https://github.com/phiresky/ripgrep-all/blob/master/README.md)
- [Adapter Configuration](https://github.com/phiresky/ripgrep-all/blob/master/adapters.md)
- [Ripgrep Documentation](https://github.com/BurntSushi/ripgrep)

This guide provides comprehensive coverage of ripgrep-all installation, configuration, and usage patterns for searching inside various file formats and archives.