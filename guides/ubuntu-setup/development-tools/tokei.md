# Tokei - Code Statistics Tool Installation and Setup Guide

## Overview

**Tokei** is a fast program that displays statistics about your code. It shows the number of files, total lines, comments, and blank lines grouped by language. Written in Rust, it's designed to be accurate and extremely fast, making it perfect for analyzing large codebases.

### Key Features
- **Multi-language support**: Supports over 200 programming languages
- **Accurate counting**: Distinguishes between code, comments, and blank lines
- **Fast performance**: Optimized for large codebases
- **Multiple output formats**: JSON, YAML, and customizable text output
- **Git integration**: Respects .gitignore files
- **Sorting options**: Sort by files, lines, comments, or blanks

### Why Use Tokei?
- Faster than traditional tools like `cloc` or `sloccount`
- More accurate language detection
- Better handling of mixed-language files
- Clean, readable output format
- Excellent for code analysis and reporting
- Integrates well with CI/CD pipelines

## Installation

### Prerequisites
- Any Unix-like system
- Source code to analyze

### Via Mise (Recommended)
```bash
# Install tokei via mise
mise use -g tokei

# Verify installation
tokei --version
```

### Manual Installation
```bash
# Install via cargo
cargo install tokei

# Or download binary release
curl -L https://github.com/XAMPPRocky/tokei/releases/latest/download/tokei-x86_64-unknown-linux-gnu.tar.gz | tar xz
sudo mv tokei /usr/local/bin/
```

### Verify Installation
```bash
# Test basic functionality
tokei --help

# Quick test on current directory
tokei .
```

## Configuration

### Shell Integration
```bash
# Add to ~/.bashrc or ~/.zshrc
alias count='tokei'
alias stats='tokei --output compact'
alias verbose-stats='tokei --output verbose'

# Function for common analysis patterns
code_summary() {
    local dir="${1:-.}"
    echo "=== Code Statistics for $dir ==="
    tokei "$dir" --output compact
}

# Function for detailed analysis
detailed_analysis() {
    local dir="${1:-.}"
    echo "=== Detailed Code Analysis for $dir ==="
    tokei "$dir" --sort lines --output verbose
}
```

### Configuration File
```bash
# Create tokei config directory
mkdir -p ~/.config/tokei

# Create configuration file (if supported by version)
cat > ~/.config/tokei/config.toml << 'EOF'
# Tokei configuration
[output]
format = "compact"
sort_by = "lines"

[filters]
# Add custom file extensions
[filters.extensions]
mylang = ["*.mylang", "*.ml"]
EOF
```

## Basic Usage

### Simple Analysis
```bash
# Analyze current directory
tokei .

# Analyze specific directory
tokei /path/to/project

# Analyze multiple directories
tokei project1/ project2/ project3/

# Analyze specific files
tokei src/main.rs src/lib.rs
```

### Output Formats
```bash
# Compact output (default)
tokei . --output compact

# Verbose output with file details
tokei . --output verbose

# JSON output for scripting
tokei . --output json

# YAML output
tokei . --output yaml
```

### Sorting Options
```bash
# Sort by lines of code (default)
tokei . --sort lines

# Sort by number of files
tokei . --sort files

# Sort by comments
tokei . --sort comments

# Sort by blank lines
tokei . --sort blanks
```

## Advanced Usage

### Filtering and Exclusions
```bash
# Exclude specific directories
tokei . --exclude node_modules --exclude target --exclude build

# Include only specific file types
tokei . --type rust --type python --type javascript

# Exclude specific file types
tokei . --exclude-type json --exclude-type yaml

# Use custom .gitignore-like file
tokei . --ignore-file .tokeignore
```

### Detailed Analysis
```bash
# Show individual file statistics
tokei . --files

# Show hidden files
tokei . --hidden

# Follow symbolic links
tokei . --follow-links

# Show only languages with code
tokei . --compact
```

### Git Integration
```bash
# Analyze only tracked files
tokei . --git

# Analyze files in specific branch
git checkout feature-branch
tokei . --git

# Analyze git repository with specific commit
git checkout HEAD~10
tokei . --git
```

### Scripting and Automation
```bash
#!/bin/bash
# Code analysis script

analyze_project() {
    local project_dir="$1"
    local output_file="$2"
    
    echo "Analyzing project: $project_dir"
    
    # Basic statistics
    tokei "$project_dir" --output json > "$output_file"
    
    # Summary report
    echo "=== Project Statistics ===" >> "${output_file}.summary"
    tokei "$project_dir" --output compact >> "${output_file}.summary"
    
    # Detailed report
    echo "=== Detailed Analysis ===" >> "${output_file}.detailed"
    tokei "$project_dir" --output verbose >> "${output_file}.detailed"
}

# Compare two versions
compare_versions() {
    local old_version="$1"
    local new_version="$2"
    
    echo "Comparing $old_version vs $new_version"
    
    # Analyze both versions
    tokei "$old_version" --output json > old_stats.json
    tokei "$new_version" --output json > new_stats.json
    
    # Simple comparison (would need custom script for detailed comparison)
    echo "Old version stats:"
    tokei "$old_version" --output compact
    echo
    echo "New version stats:"
    tokei "$new_version" --output compact
}
```

### CI/CD Integration
```bash
# Code statistics for CI pipeline
generate_code_report() {
    local project_root="$1"
    local report_file="code_statistics.json"
    
    echo "Generating code statistics report..."
    
    # Generate JSON report
    tokei "$project_root" --output json > "$report_file"
    
    # Generate human-readable summary
    tokei "$project_root" --output compact > "code_summary.txt"
    
    # Check for significant changes (conceptual)
    if [ -f "previous_stats.json" ]; then
        echo "Comparing with previous statistics..."
        compare_code_stats.py "previous_stats.json" "$report_file"
    fi
    
    # Save current stats as baseline
    cp "$report_file" "previous_stats.json"
}

# Quality gate based on code statistics
check_code_quality() {
    local max_lines_per_file=1000
    local min_comment_ratio=0.1
    
    # Get detailed file statistics
    tokei . --files --output json > temp_stats.json
    
    # Check metrics (would need custom script)
    if check_file_lengths.py temp_stats.json "$max_lines_per_file"; then
        echo "✓ All files within size limits"
    else
        echo "✗ Some files exceed maximum length"
        exit 1
    fi
    
    if check_comment_ratio.py temp_stats.json "$min_comment_ratio"; then
        echo "✓ Comment ratio meets requirements"
    else
        echo "✗ Comment ratio too low"
        exit 1
    fi
}
```

### Multi-Project Analysis
```bash
# Analyze multiple projects
analyze_workspace() {
    local workspace_dir="$1"
    local output_dir="$2"
    
    mkdir -p "$output_dir"
    
    echo "Analyzing workspace: $workspace_dir"
    
    # Find all projects (assuming they have specific markers)
    find "$workspace_dir" -name "package.json" -o -name "Cargo.toml" -o -name "setup.py" | \
    while read -r project_marker; do
        local project_dir=$(dirname "$project_marker")
        local project_name=$(basename "$project_dir")
        
        echo "Analyzing project: $project_name"
        
        # Generate statistics for each project
        tokei "$project_dir" --output json > "$output_dir/${project_name}.json"
        tokei "$project_dir" --output compact > "$output_dir/${project_name}.txt"
    done
    
    # Generate combined report
    echo "=== Workspace Summary ===" > "$output_dir/workspace_summary.txt"
    tokei "$workspace_dir" --output compact >> "$output_dir/workspace_summary.txt"
}

# Language-specific analysis
analyze_by_language() {
    local project_dir="$1"
    local languages=("rust" "python" "javascript" "typescript" "go" "java")
    
    echo "=== Language-specific Analysis ==="
    
    for lang in "${languages[@]}"; do
        echo "--- $lang ---"
        if tokei "$project_dir" --type "$lang" --output compact | grep -q "$lang"; then
            tokei "$project_dir" --type "$lang" --output compact
        else
            echo "No $lang files found"
        fi
        echo
    done
}
```

### Custom Reporting
```bash
# Generate custom reports
generate_custom_report() {
    local project_dir="$1"
    local report_file="$2"
    
    cat > "$report_file" << EOF
# Code Statistics Report
Generated: $(date)
Project: $project_dir

## Summary
EOF
    
    # Add summary statistics
    tokei "$project_dir" --output compact >> "$report_file"
    
    cat >> "$report_file" << EOF

## Detailed Breakdown
EOF
    
    # Add detailed statistics
    tokei "$project_dir" --output verbose >> "$report_file"
    
    cat >> "$report_file" << EOF

## File Statistics
EOF
    
    # Add file-level statistics
    tokei "$project_dir" --files >> "$report_file"
    
    echo "Report generated: $report_file"
}

# Progress tracking
track_progress() {
    local project_dir="$1"
    local log_file="progress.log"
    
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local stats=$(tokei "$project_dir" --output compact | tail -1)
    
    echo "$timestamp | $stats" >> "$log_file"
    
    echo "Progress logged to $log_file"
}
```

## Integration Examples

### With Git Hooks
```bash
# Pre-commit hook for code statistics
#!/bin/bash
# .git/hooks/pre-commit

echo "Checking code statistics..."

# Generate current statistics
tokei . --output json > current_stats.json

# Check for significant changes
if [ -f "baseline_stats.json" ]; then
    # Compare with baseline (would need custom script)
    if significant_changes.py baseline_stats.json current_stats.json; then
        echo "Significant code changes detected"
        echo "Current statistics:"
        tokei . --output compact
        
        read -p "Continue with commit? (y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
fi

# Update baseline
cp current_stats.json baseline_stats.json
```

### With Build Systems
```bash
# Makefile integration
stats:
	@echo "Generating code statistics..."
	@tokei . --output compact
	@tokei . --output json > build/stats.json

verbose-stats:
	@echo "Generating detailed code statistics..."
	@tokei . --output verbose

# CMake integration
add_custom_target(stats
    COMMAND tokei ${CMAKE_SOURCE_DIR} --output compact
    COMMENT "Generating code statistics"
)
```

### With Documentation
```bash
# Generate documentation with code stats
generate_docs_with_stats() {
    local project_dir="$1"
    local docs_dir="$2"
    
    mkdir -p "$docs_dir"
    
    # Generate README with statistics
    cat > "$docs_dir/README.md" << EOF
# Project Statistics

Last updated: $(date)

## Code Overview
EOF
    
    # Add code statistics
    echo '```' >> "$docs_dir/README.md"
    tokei "$project_dir" --output compact >> "$docs_dir/README.md"
    echo '```' >> "$docs_dir/README.md"
    
    # Add detailed breakdown
    cat >> "$docs_dir/README.md" << EOF

## Detailed Breakdown
\`\`\`
EOF
    tokei "$project_dir" --output verbose >> "$docs_dir/README.md"
    echo '```' >> "$docs_dir/README.md"
}
```

## Troubleshooting

### Common Issues

**Issue**: Inaccurate language detection
```bash
# Solution: Use --type flag to specify languages
tokei . --type rust --type python

# Solution: Check file extensions
tokei . --files | grep "Unknown"
```

**Issue**: Large directories taking too long
```bash
# Solution: Exclude large directories
tokei . --exclude node_modules --exclude target --exclude .git

# Solution: Use .gitignore integration
tokei . --git
```

**Issue**: Incorrect file counting
```bash
# Solution: Check for hidden files
tokei . --hidden

# Solution: Verify symlink handling
tokei . --follow-links
```

### Performance Tips
```bash
# Use git integration for better performance
tokei . --git

# Exclude unnecessary directories
tokei . --exclude build --exclude dist --exclude node_modules

# Use specific types for faster analysis
tokei . --type rust --type python --type javascript
```

### Language Support
```bash
# List supported languages
tokei --languages

# Check specific language support
tokei --help | grep -A 10 "LANGUAGES"

# Add custom language support (if available)
# Edit ~/.config/tokei/config.toml
```

## Comparison with Alternatives

### Tokei vs cloc
```bash
# Speed comparison
time tokei large_project/
time cloc large_project/

# Tokei advantages:
# - Faster execution
# - Better accuracy
# - More output formats
# - Better Git integration
```

### Tokei vs sloccount
```bash
# Feature comparison
tokei . --output verbose
sloccount .

# Tokei advantages:
# - More languages supported
# - Better comment detection
# - JSON/YAML output
# - Active development
```

## Resources and References

- [Tokei GitHub Repository](https://github.com/XAMPPRocky/tokei)
- [Tokei Documentation](https://github.com/XAMPPRocky/tokei/blob/master/README.md)
- [Supported Languages](https://github.com/XAMPPRocky/tokei/blob/master/LANGUAGES.md)
- [Configuration Guide](https://github.com/XAMPPRocky/tokei/wiki/Configuration)

This guide provides comprehensive coverage of tokei installation, configuration, and usage patterns for effective code analysis and statistics generation.