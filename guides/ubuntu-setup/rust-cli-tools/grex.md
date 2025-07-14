# Grex - Regex Generator Installation and Setup Guide

## Overview

**Grex** is a command-line tool and library for generating regular expressions from user-provided test cases. It's designed to simplify the process of creating regex patterns by analyzing example strings and generating the most appropriate regular expression that matches all provided examples.

### Key Features
- **Automatic regex generation**: Create regex patterns from examples
- **Multiple output formats**: Various regex flavors supported
- **Pattern optimization**: Generates concise and efficient patterns
- **Unicode support**: Full Unicode character support
- **Flexible matching**: Case-sensitive/insensitive options
- **Multiple algorithms**: Different generation strategies

### Why Use Grex?
- Eliminates the need to manually craft complex regex patterns
- Reduces errors in regex creation
- Saves time when working with pattern matching
- Provides educational insight into regex construction
- Supports various regex flavors and engines
- Great for learning regex patterns from examples

## Installation

### Prerequisites
- Rust toolchain (for building from source)
- Understanding of regular expressions and pattern matching

### Via Mise (Recommended)
```bash
# Install grex via mise
mise use -g grex

# Verify installation
grex --version
```

### Manual Installation
```bash
# Install via cargo
cargo install grex

# Or download binary release
curl -L https://github.com/pemistahl/grex/releases/latest/download/grex-linux-x86_64.tar.gz | tar xz
sudo mv grex /usr/local/bin/
```

### Verify Installation
```bash
# Test basic functionality
echo -e "hello\nworld" | grex

# Check version
grex --version

# Show help
grex --help
```

## Configuration

### Shell Integration
```bash
# Add to ~/.bashrc or ~/.zshrc
alias regex='grex'
alias re='grex'

# Useful functions
regex_from_file() {
    local file="$1"
    local options="${2:-}"
    
    if [[ -f "$file" ]]; then
        grex $options < "$file"
    else
        echo "File not found: $file"
        return 1
    fi
}

regex_case_insensitive() {
    grex --ignore-case "$@"
}

regex_with_digits() {
    grex --with-surrogates "$@"
}

# Function to generate regex and test it
regex_and_test() {
    local test_file="$1"
    local options="${2:-}"
    
    echo "Generating regex from: $test_file"
    local regex=$(grex $options < "$test_file")
    echo "Generated regex: $regex"
    
    echo "Testing regex against input:"
    while IFS= read -r line; do
        if [[ "$line" =~ $regex ]]; then
            echo "✓ '$line' matches"
        else
            echo "✗ '$line' does not match"
        fi
    done < "$test_file"
}

# Function to generate regex for different flavors
regex_flavors() {
    local input="$1"
    
    echo "Input: $input"
    echo
    
    echo "=== Default (Rust) ==="
    echo "$input" | grex
    echo
    
    echo "=== PCRE ==="
    echo "$input" | grex --flavor pcre
    echo
    
    echo "=== JavaScript ==="
    echo "$input" | grex --flavor javascript
    echo
    
    echo "=== Python ==="
    echo "$input" | grex --flavor python
    echo
}

# Function to generate regex with different strategies
regex_strategies() {
    local input="$1"
    
    echo "Input: $input"
    echo
    
    echo "=== Default ==="
    echo "$input" | grex
    echo
    
    echo "=== Minimum ==="
    echo "$input" | grex --min-repetitions 1
    echo
    
    echo "=== Maximum ==="
    echo "$input" | grex --max-repetitions 1000
    echo
    
    echo "=== Case Insensitive ==="
    echo "$input" | grex --ignore-case
    echo
}
```

### Configuration File
```bash
# Create config directory
mkdir -p ~/.config/grex

# Create default settings
cat > ~/.config/grex/config.toml << 'EOF'
[default]
flavor = "rust"
ignore_case = false
min_repetitions = 1
max_repetitions = 1000
min_surrogate_codepoints = 1
max_surrogate_codepoints = 1000
verbose = false
colorize = true

[pcre]
flavor = "pcre"
ignore_case = false
min_repetitions = 1
max_repetitions = 1000

[javascript]
flavor = "javascript"
ignore_case = false
min_repetitions = 1
max_repetitions = 1000

[python]
flavor = "python"
ignore_case = false
min_repetitions = 1
max_repetitions = 1000
EOF
```

## Basic Usage

### Simple Pattern Generation
```bash
# Generate regex from simple strings
echo -e "cat\nrat\nbat" | grex
# Output: ^[bcr]at$

# Generate regex from numbers
echo -e "123\n456\n789" | grex
# Output: ^[1-9][2-9][3-9]$

# Generate regex from mixed patterns
echo -e "hello123\nworld456\ntest789" | grex
# Output: ^[htw][eoe][lsr][ltd][dol][123456789][456789][3-9]$
```

### Case Sensitivity
```bash
# Case-sensitive (default)
echo -e "Hello\nHELLO\nhello" | grex

# Case-insensitive
echo -e "Hello\nHELLO\nhello" | grex --ignore-case

# Mixed case patterns
echo -e "iPhone\nAndroid\nWindows" | grex
echo -e "iPhone\nAndroid\nWindows" | grex --ignore-case
```

### Different Regex Flavors
```bash
# Rust regex (default)
echo -e "test123\ndata456" | grex

# PCRE flavor
echo -e "test123\ndata456" | grex --flavor pcre

# JavaScript flavor
echo -e "test123\ndata456" | grex --flavor javascript

# Python flavor
echo -e "test123\ndata456" | grex --flavor python
```

## Advanced Usage

### Complex Pattern Generation
```bash
# Email-like patterns
echo -e "user@domain.com\ntest@example.org\nadmin@site.net" | grex

# URL patterns
echo -e "https://example.com\nhttp://test.org\nhttps://demo.net" | grex

# Phone number patterns
echo -e "123-456-7890\n987-654-3210\n555-123-4567" | grex

# Date patterns
echo -e "2023-01-15\n2023-12-31\n2023-06-22" | grex
```

### Repetition Control
```bash
# Minimum repetitions
echo -e "a\naa\naaa\naaaa" | grex --min-repetitions 2

# Maximum repetitions
echo -e "a\naa\naaa\naaaa" | grex --max-repetitions 3

# Control both min and max
echo -e "test\ntests\ntesting" | grex --min-repetitions 1 --max-repetitions 10
```

### Unicode and Surrogate Handling
```bash
# Unicode characters
echo -e "café\nnaïve\nrésumé" | grex

# With surrogate codepoints
echo -e "emoji😀\ntest🎉\nfun🚀" | grex --with-surrogates

# Control surrogate repetitions
echo -e "test🎉🎉\nfun🚀🚀🚀" | grex --min-surrogate-codepoints 1 --max-surrogate-codepoints 3
```

### File Processing
```bash
# Process patterns from file
process_file_patterns() {
    local file="$1"
    local output_file="${2:-regex_output.txt}"
    
    echo "Processing patterns from: $file"
    
    # Generate basic regex
    echo "=== Basic Regex ===" > "$output_file"
    grex < "$file" >> "$output_file"
    echo >> "$output_file"
    
    # Generate case-insensitive regex
    echo "=== Case Insensitive ===" >> "$output_file"
    grex --ignore-case < "$file" >> "$output_file"
    echo >> "$output_file"
    
    # Generate for different flavors
    echo "=== PCRE Flavor ===" >> "$output_file"
    grex --flavor pcre < "$file" >> "$output_file"
    echo >> "$output_file"
    
    echo "=== JavaScript Flavor ===" >> "$output_file"
    grex --flavor javascript < "$file" >> "$output_file"
    echo >> "$output_file"
    
    echo "Results saved to: $output_file"
}

# Extract patterns from logs
extract_log_patterns() {
    local log_file="$1"
    local pattern_type="$2"
    
    case "$pattern_type" in
        "ip")
            grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' "$log_file" | head -20 | grex
            ;;
        "timestamp")
            grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}' "$log_file" | head -20 | grex
            ;;
        "url")
            grep -oE 'https?://[^\s]+' "$log_file" | head -20 | grex
            ;;
        "email")
            grep -oE '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' "$log_file" | head -20 | grex
            ;;
        *)
            echo "Supported patterns: ip, timestamp, url, email"
            return 1
            ;;
    esac
}
```

### Pattern Validation and Testing
```bash
# Validate generated regex
validate_regex() {
    local test_file="$1"
    local regex_options="${2:-}"
    
    echo "Validating regex generation..."
    
    # Generate regex
    local regex=$(grex $regex_options < "$test_file")
    echo "Generated regex: $regex"
    
    # Test each input line
    local passed=0
    local total=0
    
    while IFS= read -r line; do
        ((total++))
        
        # Test with grep (basic compatibility)
        if echo "$line" | grep -qE "$regex"; then
            echo "✓ '$line' matches"
            ((passed++))
        else
            echo "✗ '$line' does not match"
        fi
    done < "$test_file"
    
    echo "Validation: $passed/$total tests passed"
    
    if [[ $passed -eq $total ]]; then
        echo "✓ All tests passed!"
        return 0
    else
        echo "✗ Some tests failed!"
        return 1
    fi
}

# Compare different regex strategies
compare_strategies() {
    local input_file="$1"
    
    echo "Comparing different regex generation strategies..."
    echo
    
    # Default strategy
    echo "=== Default Strategy ==="
    local default_regex=$(grex < "$input_file")
    echo "Regex: $default_regex"
    echo "Length: ${#default_regex}"
    echo
    
    # Case insensitive
    echo "=== Case Insensitive ==="
    local case_insensitive_regex=$(grex --ignore-case < "$input_file")
    echo "Regex: $case_insensitive_regex"
    echo "Length: ${#case_insensitive_regex}"
    echo
    
    # Minimum repetitions
    echo "=== Minimum Repetitions (2) ==="
    local min_reps_regex=$(grex --min-repetitions 2 < "$input_file")
    echo "Regex: $min_reps_regex"
    echo "Length: ${#min_reps_regex}"
    echo
    
    # Find shortest
    local shortest="$default_regex"
    local shortest_len=${#default_regex}
    
    if [[ ${#case_insensitive_regex} -lt $shortest_len ]]; then
        shortest="$case_insensitive_regex"
        shortest_len=${#case_insensitive_regex}
    fi
    
    if [[ ${#min_reps_regex} -lt $shortest_len ]]; then
        shortest="$min_reps_regex"
        shortest_len=${#min_reps_regex}
    fi
    
    echo "=== Shortest Regex ==="
    echo "$shortest"
}
```

### Integration with Other Tools
```bash
# Generate regex for grep
grep_regex() {
    local pattern_file="$1"
    local search_file="$2"
    
    echo "Generating regex for grep from: $pattern_file"
    
    local regex=$(grex < "$pattern_file")
    echo "Generated regex: $regex"
    
    if [[ -f "$search_file" ]]; then
        echo "Searching in: $search_file"
        grep -E "$regex" "$search_file"
    else
        echo "Regex ready for use with grep -E '$regex' <file>"
    fi
}

# Generate regex for sed
sed_regex() {
    local pattern_file="$1"
    local replacement="${2:-MATCH}"
    
    echo "Generating regex for sed from: $pattern_file"
    
    local regex=$(grex < "$pattern_file")
    echo "Generated regex: $regex"
    echo "Sed command: sed -E 's/$regex/$replacement/g'"
}

# Generate regex for awk
awk_regex() {
    local pattern_file="$1"
    
    echo "Generating regex for awk from: $pattern_file"
    
    local regex=$(grex < "$pattern_file")
    echo "Generated regex: $regex"
    echo "Awk command: awk '/$regex/ { print }'"
}

# Generate regex for different programming languages
lang_regex() {
    local pattern_file="$1"
    local language="$2"
    
    local regex=$(grex < "$pattern_file")
    
    case "$language" in
        "python")
            echo "import re"
            echo "pattern = r'$regex'"
            echo "if re.match(pattern, text):"
            echo "    print('Match found')"
            ;;
        "javascript")
            echo "const pattern = /$regex/;"
            echo "if (pattern.test(text)) {"
            echo "    console.log('Match found');"
            echo "}"
            ;;
        "java")
            echo "import java.util.regex.Pattern;"
            echo "Pattern pattern = Pattern.compile(\"$regex\");"
            echo "if (pattern.matcher(text).matches()) {"
            echo "    System.out.println(\"Match found\");"
            echo "}"
            ;;
        "rust")
            echo "use regex::Regex;"
            echo "let re = Regex::new(r\"$regex\").unwrap();"
            echo "if re.is_match(text) {"
            echo "    println!(\"Match found\");"
            echo "}"
            ;;
        *)
            echo "Supported languages: python, javascript, java, rust"
            return 1
            ;;
    esac
}
```

## Integration Examples

### With Data Processing
```bash
# Process CSV headers
process_csv_headers() {
    local csv_file="$1"
    
    echo "Analyzing CSV headers from: $csv_file"
    
    # Extract headers
    head -1 "$csv_file" | tr ',' '\n' > /tmp/headers.txt
    
    # Generate regex for headers
    local header_regex=$(grex < /tmp/headers.txt)
    echo "Header regex: $header_regex"
    
    # Generate regex for each column type
    echo "Column patterns:"
    for ((i=1; i<=10; i++)); do
        cut -d',' -f"$i" "$csv_file" | tail -n +2 | head -20 > "/tmp/column_$i.txt"
        if [[ -s "/tmp/column_$i.txt" ]]; then
            echo "Column $i: $(grex < "/tmp/column_$i.txt")"
        fi
    done
    
    # Cleanup
    rm -f /tmp/headers.txt /tmp/column_*.txt
}

# Process JSON field patterns
process_json_fields() {
    local json_file="$1"
    local field="$2"
    
    echo "Extracting patterns for field: $field"
    
    # Extract field values
    jq -r ".$field" "$json_file" | head -50 > "/tmp/field_values.txt"
    
    # Generate regex
    local field_regex=$(grex < "/tmp/field_values.txt")
    echo "Field regex: $field_regex"
    
    # Test validation
    echo "Testing validation..."
    validate_regex "/tmp/field_values.txt"
    
    rm -f /tmp/field_values.txt
}
```

### With Log Analysis
```bash
# Analyze log patterns
analyze_log_patterns() {
    local log_file="$1"
    local output_dir="log_analysis"
    
    mkdir -p "$output_dir"
    
    echo "Analyzing log patterns from: $log_file"
    
    # Extract different pattern types
    echo "=== IP Addresses ==="
    grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' "$log_file" | head -50 | grex > "$output_dir/ip_regex.txt"
    cat "$output_dir/ip_regex.txt"
    
    echo "=== Timestamps ==="
    grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}' "$log_file" | head -50 | grex > "$output_dir/timestamp_regex.txt"
    cat "$output_dir/timestamp_regex.txt"
    
    echo "=== HTTP Status Codes ==="
    grep -oE ' [0-9]{3} ' "$log_file" | head -50 | grex > "$output_dir/status_regex.txt"
    cat "$output_dir/status_regex.txt"
    
    echo "=== User Agents ==="
    grep -oE 'User-Agent: [^"]*' "$log_file" | head -20 | grex > "$output_dir/useragent_regex.txt"
    cat "$output_dir/useragent_regex.txt"
    
    echo "Analysis complete. Results saved to: $output_dir/"
}

# Generate regex for log parsing
log_parsing_regex() {
    local log_file="$1"
    local format="$2"
    
    case "$format" in
        "apache")
            # Extract Apache common log format parts
            echo "Generating Apache log regex..."
            awk '{print $1}' "$log_file" | head -20 | grex > /tmp/apache_ip.regex
            awk '{print $7}' "$log_file" | head -20 | grex > /tmp/apache_url.regex
            awk '{print $9}' "$log_file" | head -20 | grex > /tmp/apache_status.regex
            
            echo "IP regex: $(cat /tmp/apache_ip.regex)"
            echo "URL regex: $(cat /tmp/apache_url.regex)"
            echo "Status regex: $(cat /tmp/apache_status.regex)"
            ;;
        "nginx")
            # Extract Nginx log format parts
            echo "Generating Nginx log regex..."
            grep -oE '^[^ ]+' "$log_file" | head -20 | grex > /tmp/nginx_ip.regex
            grep -oE '"[^"]*"' "$log_file" | head -20 | grex > /tmp/nginx_request.regex
            
            echo "IP regex: $(cat /tmp/nginx_ip.regex)"
            echo "Request regex: $(cat /tmp/nginx_request.regex)"
            ;;
        *)
            echo "Supported formats: apache, nginx"
            return 1
            ;;
    esac
    
    rm -f /tmp/*regex
}
```

### With Web Development
```bash
# Generate regex for form validation
form_validation_regex() {
    local field_type="$1"
    local examples_file="$2"
    
    echo "Generating validation regex for: $field_type"
    
    case "$field_type" in
        "email")
            if [[ -f "$examples_file" ]]; then
                grex --flavor javascript < "$examples_file"
            else
                echo -e "user@example.com\ntest@domain.org\nadmin@site.net" | grex --flavor javascript
            fi
            ;;
        "phone")
            if [[ -f "$examples_file" ]]; then
                grex --flavor javascript < "$examples_file"
            else
                echo -e "123-456-7890\n(555) 123-4567\n555.123.4567" | grex --flavor javascript
            fi
            ;;
        "url")
            if [[ -f "$examples_file" ]]; then
                grex --flavor javascript < "$examples_file"
            else
                echo -e "https://example.com\nhttp://test.org\nhttps://demo.net/path" | grex --flavor javascript
            fi
            ;;
        *)
            echo "Supported types: email, phone, url"
            return 1
            ;;
    esac
}

# Generate regex for API endpoint validation
api_endpoint_regex() {
    local endpoints_file="$1"
    
    echo "Generating API endpoint regex..."
    
    # Extract path patterns
    grep -oE '/[^?\s]+' "$endpoints_file" | head -50 | grex --flavor javascript > /tmp/api_paths.regex
    
    # Extract parameter patterns
    grep -oE '\?[^&\s]+' "$endpoints_file" | head -50 | grex --flavor javascript > /tmp/api_params.regex
    
    echo "Path regex: $(cat /tmp/api_paths.regex)"
    echo "Parameter regex: $(cat /tmp/api_params.regex)"
    
    rm -f /tmp/api_*.regex
}
```

### With DevOps and System Administration
```bash
# Generate regex for configuration files
config_regex() {
    local config_file="$1"
    local pattern_type="$2"
    
    case "$pattern_type" in
        "key-value")
            grep -oE '^[^=]+' "$config_file" | head -20 | grex
            ;;
        "values")
            grep -oE '=[^$]+$' "$config_file" | sed 's/^=//' | head -20 | grex
            ;;
        "comments")
            grep -oE '^#.*' "$config_file" | head -20 | grex
            ;;
        *)
            echo "Supported types: key-value, values, comments"
            return 1
            ;;
    esac
}

# Generate regex for monitoring alerts
monitoring_regex() {
    local alert_file="$1"
    
    echo "Generating monitoring alert regex..."
    
    # Extract severity levels
    grep -oE '(CRITICAL|WARNING|INFO|DEBUG)' "$alert_file" | grex > /tmp/severity.regex
    
    # Extract service names
    grep -oE 'service=[^,\s]+' "$alert_file" | sed 's/service=//' | head -20 | grex > /tmp/services.regex
    
    # Extract metric values
    grep -oE '[0-9]+\.[0-9]+' "$alert_file" | head -20 | grex > /tmp/metrics.regex
    
    echo "Severity regex: $(cat /tmp/severity.regex)"
    echo "Service regex: $(cat /tmp/services.regex)"
    echo "Metric regex: $(cat /tmp/metrics.regex)"
    
    rm -f /tmp/*.regex
}
```

## Troubleshooting

### Common Issues

**Issue**: Generated regex too complex
```bash
# Solution: Use minimum repetitions
grex --min-repetitions 2 < examples.txt

# Solution: Use case-insensitive matching
grex --ignore-case < examples.txt

# Solution: Try different flavors
grex --flavor javascript < examples.txt
```

**Issue**: Regex doesn't match all examples
```bash
# Solution: Check input format
cat -A examples.txt  # Show hidden characters

# Solution: Use verbose output
grex --verbose < examples.txt

# Solution: Validate step by step
validate_regex examples.txt
```

**Issue**: Unicode characters not handled properly
```bash
# Solution: Use surrogate support
grex --with-surrogates < examples.txt

# Solution: Check encoding
file -b --mime-encoding examples.txt
iconv -f ISO-8859-1 -t UTF-8 examples.txt > examples_utf8.txt
```

### Performance Tips
```bash
# Limit input size for better performance
head -100 large_file.txt | grex

# Use appropriate repetition limits
grex --min-repetitions 1 --max-repetitions 100

# Choose appropriate regex flavor
grex --flavor pcre  # Often more efficient
```

## Comparison with Alternatives

### Grex vs Manual Regex Writing
```bash
# Manual approach (time-consuming, error-prone)
# Analyze patterns manually and write regex

# Grex approach (fast, accurate)
echo -e "example1\nexample2\nexample3" | grex

# Grex advantages:
# - Automatic pattern detection
# - Reduced errors
# - Faster development
# - Educational value
```

### Grex vs Regex Builders
```bash
# Online regex builders (GUI-based)
# Limited to web interface

# Grex (CLI-based)
grex < examples.txt

# Grex advantages:
# - Scriptable and automatable
# - Works offline
# - Integrates with Unix tools
# - Supports multiple flavors
```

## Resources and References

- [Grex GitHub Repository](https://github.com/pemistahl/grex)
- [Grex Documentation](https://github.com/pemistahl/grex/blob/main/README.md)
- [Regular Expression Tutorial](https://regexone.com/)
- [Regex Flavors Comparison](https://www.regular-expressions.info/flavors.html)

This guide provides comprehensive coverage of grex installation, configuration, and usage patterns for efficient regular expression generation from examples.