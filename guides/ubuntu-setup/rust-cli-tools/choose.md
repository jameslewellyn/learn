# Choose - Column Selector Installation and Setup Guide

## Overview

**Choose** is a human-friendly and fast alternative to `cut` and `awk` for selecting columns from structured text. It provides intuitive syntax for extracting specific fields from lines of text, making it ideal for parsing logs, CSV files, and command output.

### Key Features
- **Intuitive syntax**: Simple field selection with ranges
- **Flexible delimiters**: Support for various field separators
- **Output formatting**: Control output field separators
- **Performance**: Fast processing of large files
- **Unicode support**: Handles UTF-8 text correctly

### Why Use Choose?
- More readable than `cut` and `awk` for simple field extraction
- Consistent behavior across different input formats
- Better handling of whitespace and empty fields
- Simpler syntax for common use cases
- Good performance on large datasets

## Installation

### Prerequisites
- No special dependencies required
- Works on any Unix-like system

### Via Mise (Recommended)
```bash
# Install choose via mise
mise use -g choose

# Verify installation
choose --version
```

### Manual Installation
```bash
# Install via cargo
cargo install choose

# Or download binary release
curl -L https://github.com/theryangeary/choose/releases/latest/download/choose-x86_64-unknown-linux-gnu.tar.gz | tar xz
sudo mv choose /usr/local/bin/
```

### Verify Installation
```bash
# Test basic functionality
echo "one two three" | choose 1
echo "field1,field2,field3" | choose -f ',' 0 2
```

## Configuration

### Shell Integration
```bash
# Add to ~/.bashrc or ~/.zshrc
# No specific configuration needed for choose

# Optional: Create useful aliases
alias c1='choose 0'
alias c2='choose 1'
alias c3='choose 2'
alias clast='choose -1'
```

### Environment Variables
```bash
# Set default field separator (if needed frequently)
export CHOOSE_DEFAULT_SEPARATOR=':'

# Add to shell functions
extract_field() {
    local field="$1"
    local separator="${2:- }"
    choose -f "$separator" "$field"
}
```

## Basic Usage

### Simple Field Selection
```bash
# Select first field (0-indexed)
echo "one two three" | choose 0
# Output: one

# Select second field
echo "one two three" | choose 1
# Output: two

# Select last field
echo "one two three" | choose -1
# Output: three
```

### Multiple Field Selection
```bash
# Select multiple fields
echo "one two three four" | choose 0 2
# Output: one three

# Select range of fields
echo "one two three four" | choose 1:3
# Output: two three four

# Select from start to index
echo "one two three four" | choose :2
# Output: one two three

# Select from index to end
echo "one two three four" | choose 2:
# Output: three four
```

### Custom Field Separators
```bash
# Use comma as separator
echo "one,two,three" | choose -f ',' 0 2
# Output: one three

# Use colon as separator
echo "user:x:1000:1000:User:/home/user:/bin/bash" | choose -f ':' 0 4 5
# Output: user User /home/user

# Use tab as separator
echo -e "one\ttwo\tthree" | choose -f '\t' 1
# Output: two
```

### Output Formatting
```bash
# Custom output separator
echo "one two three" | choose -o ',' 0 2
# Output: one,three

# Use different input/output separators
echo "one:two:three" | choose -f ':' -o ' | ' 0 2
# Output: one | three

# Quote output fields
echo "one two three" | choose -o '", "' 0 2
# Output: one", "three
```

## Advanced Usage

### Complex Field Selection
```bash
# Select non-consecutive fields
echo "a b c d e f" | choose 0 2 4
# Output: a c e

# Reverse field order
echo "a b c d" | choose 3 2 1 0
# Output: d c b a

# Duplicate fields
echo "a b c" | choose 1 1 0
# Output: b b a
```

### Working with Structured Data
```bash
# Parse /etc/passwd
choose -f ':' 0 4 5 < /etc/passwd
# Output: username gecos home_directory (for each user)

# Extract specific columns from ps output
ps aux | choose 0 1 10 | head -5
# Output: user pid command (for top 5 processes)

# Parse CSV files
choose -f ',' 0 2 4 < data.csv
# Output: first, third, and fifth columns
```

### Log Processing
```bash
# Extract timestamp and message from logs
tail -f /var/log/syslog | choose 0 1 2 4:
# Output: month day time message

# Parse Apache/Nginx logs
choose 0 3 6 8 < access.log
# Output: ip timestamp status size

# Extract specific fields from structured logs
choose -f '|' 1 3 5 < application.log
# Output: level timestamp message
```

### Data Transformation
```bash
# Convert space-separated to comma-separated
echo "one two three" | choose -o ',' 0:
# Output: one,two,three

# Reorder CSV columns
echo "name,age,city" | choose -f ',' -o ',' 2 0 1
# Output: city,name,age

# Extract and format data
echo "user:1000:1000:User Name:/home/user" | choose -f ':' -o ' | ' 0 3 4
# Output: user | User Name | /home/user
```

### Pipeline Integration
```bash
# With find command
find /etc -name "*.conf" | choose -f '/' -1
# Output: just the filenames

# With ls command
ls -la | choose 0 2 4 8
# Output: permissions links size filename

# With df command
df -h | choose 0 1 4 5
# Output: filesystem size available mounted_on
```

### Scripting Examples
```bash
#!/bin/bash
# Extract user information
get_user_info() {
    local username="$1"
    grep "^$username:" /etc/passwd | choose -f ':' 0 4 5
}

# Parse configuration files
parse_config() {
    local config_file="$1"
    grep -v '^#' "$config_file" | grep '=' | choose -f '=' 0 1
}

# Process CSV data
process_csv() {
    local csv_file="$1"
    local columns="$2"
    choose -f ',' $columns < "$csv_file"
}
```

### Performance Optimization
```bash
# Use with large files efficiently
large_file_extract() {
    local file="$1"
    local fields="$2"
    
    # Use with head/tail for better performance
    head -1000 "$file" | choose $fields
}

# Parallel processing with xargs
parallel_extract() {
    local pattern="$1"
    local fields="$2"
    
    find . -name "$pattern" -print0 | \
        xargs -0 -P 4 -I {} sh -c 'choose '"$fields"' < "{}"'
}
```

### Error Handling
```bash
# Safe field extraction
safe_choose() {
    local field="$1"
    local separator="${2:- }"
    local input
    
    while IFS= read -r input; do
        if [[ -n "$input" ]]; then
            echo "$input" | choose -f "$separator" "$field" 2>/dev/null || echo ""
        fi
    done
}

# Validate field existence
validate_field() {
    local field="$1"
    local separator="${2:- }"
    local input="$3"
    
    local field_count=$(echo "$input" | tr "$separator" '\n' | wc -l)
    if [[ "$field" -lt "$field_count" ]]; then
        echo "$input" | choose -f "$separator" "$field"
    else
        echo "Field $field not found"
    fi
}
```

## Integration Examples

### With System Administration
```bash
# Monitor system resources
monitor_system() {
    # CPU usage
    echo "CPU Usage:"
    top -bn1 | head -20 | choose 0 8 11
    
    # Memory usage
    echo "Memory Usage:"
    free -h | choose 0 1 2 3
    
    # Disk usage
    echo "Disk Usage:"
    df -h | choose 0 1 4 5
}

# Process log analysis
analyze_logs() {
    local log_file="$1"
    local error_pattern="$2"
    
    echo "Error analysis for $log_file:"
    grep "$error_pattern" "$log_file" | choose 0 1 2 4: | head -10
}
```

### With Development Workflow
```bash
# Parse Git output
git_contributors() {
    git log --format="%an %ae %ad" | choose 0 1 | sort | uniq -c | sort -nr
}

# Extract test results
parse_test_output() {
    local test_file="$1"
    grep "^Test:" "$test_file" | choose 1 2 3
}

# Code statistics
code_stats() {
    find . -name "*.py" -exec wc -l {} + | choose 0 1 | head -10
}
```

### With Data Processing
```bash
# CSV analysis
csv_summary() {
    local csv_file="$1"
    echo "Columns 1 and 3 from $csv_file:"
    choose -f ',' 0 2 < "$csv_file" | head -10
}

# Log aggregation
aggregate_logs() {
    local log_dir="$1"
    find "$log_dir" -name "*.log" -exec cat {} \; | \
        choose 0 1 2 | sort | uniq -c | sort -nr | head -20
}
```

## Troubleshooting

### Common Issues

**Issue**: Fields not selected correctly
```bash
# Solution: Check field separator
echo "one:two:three" | choose -f ':' 0 2
# Not: echo "one:two:three" | choose 0 2
```

**Issue**: Empty output
```bash
# Solution: Verify field indices (0-based)
echo "a b c" | choose 3  # No output (only 0,1,2 exist)
echo "a b c" | choose 2  # Output: c
```

**Issue**: Incorrect output format
```bash
# Solution: Use output separator
echo "a b c" | choose -o ',' 0 2  # Output: a,c
# Not: echo "a b c" | choose 0 2  # Output: a c
```

### Performance Tips
```bash
# For large files, use with head/tail
head -1000 large_file.txt | choose 0 2 4

# Use specific field separators instead of default
choose -f ',' 0 2 < file.csv  # Faster than relying on auto-detection

# Combine with other tools efficiently
cut -d' ' -f1-3 file.txt | choose 0 2  # Sometimes cut+choose is faster
```

## Comparison with Alternatives

### Choose vs Cut
```bash
# Cut (traditional)
echo "one two three" | cut -d' ' -f1,3
# Output: one three

# Choose (modern)
echo "one two three" | choose 0 2
# Output: one three

# Choose advantages: Better syntax, Unicode support, flexible ranges
```

### Choose vs Awk
```bash
# Awk (traditional)
echo "one two three" | awk '{print $1, $3}'
# Output: one three

# Choose (modern)
echo "one two three" | choose 0 2
# Output: one three

# Choose advantages: Simpler for field extraction, better readability
```

## Resources and References

- [Choose GitHub Repository](https://github.com/theryangeary/choose)
- [Choose Documentation](https://github.com/theryangeary/choose/blob/main/README.md)
- [Rust CLI Tools Comparison](https://github.com/rust-cli/awesome-rust-cli)

This guide provides comprehensive coverage of choose installation, configuration, and usage patterns for efficient field extraction and text processing workflows.