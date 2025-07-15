# XSV - Fast CSV Toolkit Installation and Setup Guide

## Overview

**XSV** is a fast CSV command-line toolkit written in Rust. It provides powerful tools for working with CSV files including searching, slicing, indexing, joining, and statistical analysis. XSV is designed to be fast, memory-efficient, and capable of handling large CSV files.

### Key Features
- **High performance**: Built in Rust for speed and memory efficiency
- **Large file support**: Can handle CSV files larger than available memory
- **Comprehensive tools**: Search, slice, join, statistics, and more
- **Unicode support**: Full Unicode support for international data
- **Streaming**: Process large files without loading into memory
- **Multiple output formats**: CSV, TSV, and custom delimiters

### Why Use XSV?
- Much faster than traditional CSV processing tools
- Memory efficient for large datasets
- Comprehensive set of CSV manipulation commands
- Great for data analysis and ETL workflows
- Excellent for data quality checks and validation
- Active development and regular updates

## Installation

### Prerequisites
- Rust toolchain (for building from source)
- Understanding of CSV format and basic data manipulation

### Via Mise (Recommended)
```bash
# Install xsv via mise
mise use -g cargo:xsv

# Verify installation
xsv --version
```

### Manual Installation
```bash
# Install via cargo
cargo install xsv

# Or download binary release
curl -L https://github.com/BurntSushi/xsv/releases/latest/download/xsv-0.13.0-x86_64-unknown-linux-musl.tar.gz | tar xz
sudo mv xsv /usr/local/bin/
```

### Verify Installation
```bash
# Test basic functionality
echo -e "name,age\nJohn,30\nJane,25" | xsv table

# Check version
xsv --version

# Show help
xsv --help
```

## Configuration

### Shell Integration
```bash
# Add to ~/.bashrc or ~/.zshrc
alias csvtable='xsv table'
alias csvstats='xsv stats'
alias csvselect='xsv select'
alias csvcount='xsv count'

# Useful functions
csv_preview() {
    local file="$1"
    local rows="${2:-10}"
    echo "=== CSV Preview: $file ==="
    xsv headers "$file"
    echo
    xsv slice --start 0 --len "$rows" "$file" | xsv table
}

csv_summary() {
    local file="$1"
    echo "=== CSV Summary: $file ==="
    echo "Rows: $(xsv count "$file")"
    echo "Columns: $(xsv headers "$file" | wc -l)"
    echo
    echo "Headers:"
    xsv headers "$file"
    echo
    echo "Statistics:"
    xsv stats "$file" | xsv table
}

csv_validate() {
    local file="$1"
    echo "Validating CSV: $file"
    
    # Check if file exists and is not empty
    if [[ ! -f "$file" ]]; then
        echo "Error: File not found"
        return 1
    fi
    
    if [[ ! -s "$file" ]]; then
        echo "Error: File is empty"
        return 1
    fi
    
    # Check for parsing errors
    if ! xsv count "$file" >/dev/null 2>&1; then
        echo "Error: CSV parsing failed"
        return 1
    fi
    
    echo "CSV validation passed"
}

# Function to convert CSV to other formats
csv_convert() {
    local file="$1"
    local format="$2"
    
    case "$format" in
        "json")
            echo "["
            xsv select 1- "$file" | tail -n +2 | while IFS= read -r line; do
                echo "  {"
                headers=$(xsv headers "$file")
                echo "$line" | xsv fmt --out-delimiter ',' | while IFS=',' read -r -a values; do
                    i=0
                    echo "$headers" | while read -r header; do
                        if [[ $i -gt 0 ]]; then echo ","; fi
                        echo "    \"$header\": \"${values[$i]}\""
                        ((i++))
                    done
                done
                echo "  },"
            done
            echo "]"
            ;;
        "tsv")
            xsv fmt --out-delimiter '\t' "$file"
            ;;
        "table")
            xsv table "$file"
            ;;
        *)
            echo "Unsupported format: $format"
            echo "Supported formats: json, tsv, table"
            return 1
            ;;
    esac
}
```

### Configuration File
```bash
# Create config directory
mkdir -p ~/.config/xsv

# Create common configuration
cat > ~/.config/xsv/config.toml << 'EOF'
[defaults]
delimiter = ","
output_delimiter = ","
no_headers = false
flexible = false

[table]
width = 120
align = "left"
padding = 1

[stats]
everything = false
median = true
mode = false
cardinality = true
EOF
```

## Basic Usage

### File Information
```bash
# Count rows in CSV
xsv count data.csv

# Show headers
xsv headers data.csv

# Show basic statistics
xsv stats data.csv

# Display as formatted table
xsv table data.csv

# Get file info
xsv info data.csv
```

### Selecting and Slicing
```bash
# Select specific columns
xsv select name,age data.csv

# Select columns by index
xsv select 1,3 data.csv

# Select range of columns
xsv select 1-5 data.csv

# Slice rows
xsv slice --start 10 --len 5 data.csv

# Get first N rows
xsv slice --len 10 data.csv

# Get last N rows
xsv slice --start -10 data.csv
```

### Searching and Filtering
```bash
# Search for pattern
xsv search "John" data.csv

# Search in specific column
xsv search --select name "John" data.csv

# Case-insensitive search
xsv search --ignore-case "john" data.csv

# Use regex
xsv search --regex "^J.*" data.csv

# Invert search (exclude matches)
xsv search --invert-match "John" data.csv
```

## Advanced Usage

### Data Transformation
```bash
# Sort by column
xsv sort --select name data.csv

# Sort numerically
xsv sort --numeric --select age data.csv

# Reverse sort
xsv sort --reverse --select name data.csv

# Remove duplicates
xsv dedup data.csv

# Remove duplicates based on specific column
xsv dedup --select email data.csv

# Reorder columns
xsv select age,name,email data.csv
```

### Data Analysis
```bash
# Generate comprehensive statistics
xsv stats --everything data.csv

# Get frequency counts
xsv frequency --select category data.csv

# Calculate specific statistics
xsv stats --median --mode --cardinality data.csv

# Group statistics by column
xsv stats --select age --group-by department data.csv
```

### Joining and Merging
```bash
# Join two CSV files
xsv join --left id data1.csv id data2.csv

# Inner join
xsv join id data1.csv id data2.csv

# Left join
xsv join --left id data1.csv id data2.csv

# Right join  
xsv join --right id data1.csv id data2.csv

# Full outer join
xsv join --full id data1.csv id data2.csv
```

### Data Validation and Cleaning
```bash
# Check for data inconsistencies
check_data_quality() {
    local file="$1"
    echo "=== Data Quality Report: $file ==="
    
    # Basic info
    echo "Total rows: $(xsv count "$file")"
    echo "Columns: $(xsv headers "$file" | wc -l)"
    echo
    
    # Check for empty cells
    echo "Empty cells by column:"
    xsv stats "$file" | xsv select field,nulls | xsv table
    echo
    
    # Check for duplicates
    local total_rows=$(xsv count "$file")
    local unique_rows=$(xsv dedup "$file" | xsv count)
    local duplicates=$((total_rows - unique_rows))
    echo "Duplicate rows: $duplicates"
    echo
    
    # Data type analysis
    echo "Data types (inferred):"
    xsv stats "$file" | xsv select field,type | xsv table
}

# Clean CSV data
clean_csv() {
    local input_file="$1"
    local output_file="$2"
    
    echo "Cleaning CSV: $input_file -> $output_file"
    
    # Remove duplicates and empty rows
    xsv dedup "$input_file" | \
    xsv search --invert-match "^$" | \
    xsv fmt > "$output_file"
    
    echo "Cleaned $(xsv count "$input_file") rows to $(xsv count "$output_file") rows"
}

# Validate data format
validate_format() {
    local file="$1"
    local column="$2"
    local pattern="$3"
    
    echo "Validating format in column '$column' with pattern '$pattern'"
    
    # Find rows that don't match pattern
    local invalid_rows=$(xsv search --select "$column" --regex --invert-match "$pattern" "$file" | xsv count)
    
    if [[ $invalid_rows -gt 0 ]]; then
        echo "Found $invalid_rows invalid rows:"
        xsv search --select "$column" --regex --invert-match "$pattern" "$file" | xsv table
        return 1
    else
        echo "All rows in column '$column' match the required format"
        return 0
    fi
}
```

### Large File Processing
```bash
# Process large files in chunks
process_large_csv() {
    local file="$1"
    local chunk_size="${2:-10000}"
    
    echo "Processing large CSV in chunks of $chunk_size rows"
    
    local total_rows=$(xsv count "$file")
    local num_chunks=$(( (total_rows + chunk_size - 1) / chunk_size ))
    
    echo "Total rows: $total_rows"
    echo "Number of chunks: $num_chunks"
    
    for ((i=0; i<num_chunks; i++)); do
        local start=$((i * chunk_size))
        echo "Processing chunk $((i+1))/$num_chunks (starting at row $start)"
        
        # Process chunk
        xsv slice --start "$start" --len "$chunk_size" "$file" | \
        xsv stats > "chunk_${i}_stats.csv"
    done
}

# Split large CSV into smaller files
split_csv() {
    local file="$1"
    local lines_per_file="${2:-10000}"
    local prefix="${3:-chunk_}"
    
    echo "Splitting CSV into files of $lines_per_file lines each"
    
    # Get header
    local header=$(xsv slice --len 1 "$file")
    
    # Split data (excluding header)
    xsv slice --start 1 "$file" | split -l "$lines_per_file" - "${prefix}"
    
    # Add header to each chunk
    for chunk in ${prefix}*; do
        local temp_file="${chunk}.tmp"
        echo "$header" > "$temp_file"
        cat "$chunk" >> "$temp_file"
        mv "$temp_file" "${chunk}.csv"
        rm "$chunk"
    done
    
    echo "Created $(ls ${prefix}*.csv | wc -l) files"
}
```

### Data Transformation Scripts
```bash
# Convert between different CSV formats
convert_csv_format() {
    local input_file="$1"
    local output_file="$2"
    local input_delimiter="${3:-,}"
    local output_delimiter="${4:-,}"
    
    echo "Converting CSV format: $input_file -> $output_file"
    
    xsv fmt --delimiter "$input_delimiter" --out-delimiter "$output_delimiter" "$input_file" > "$output_file"
}

# Normalize column names
normalize_headers() {
    local file="$1"
    local output_file="$2"
    
    echo "Normalizing headers in: $file"
    
    # Get headers and normalize them
    local headers=$(xsv headers "$file")
    local normalized_headers=$(echo "$headers" | \
        tr '[:upper:]' '[:lower:]' | \
        sed 's/[^a-z0-9]/_/g' | \
        sed 's/_\+/_/g' | \
        sed 's/^_\|_$//g')
    
    # Create new file with normalized headers
    {
        echo "$normalized_headers" | tr '\n' ',' | sed 's/,$//'
        echo
        xsv slice --start 1 "$file"
    } > "$output_file"
}

# Aggregate data
aggregate_data() {
    local file="$1"
    local group_column="$2"
    local value_column="$3"
    local operation="${4:-sum}"
    
    echo "Aggregating $value_column by $group_column using $operation"
    
    # Group and aggregate
    xsv sort --select "$group_column" "$file" | \
    xsv group --group-by "$group_column" --aggregate "$operation" --select "$value_column"
}
```

## Integration Examples

### Data Pipeline Processing
```bash
# ETL pipeline example
etl_pipeline() {
    local input_file="$1"
    local output_file="$2"
    
    echo "Running ETL pipeline: $input_file -> $output_file"
    
    # Extract and transform
    xsv select name,email,age,department "$input_file" | \
    xsv search --invert-match "^$" | \
    xsv dedup | \
    xsv sort --select department,name | \
    xsv fmt > "$output_file"
    
    echo "ETL pipeline completed"
    echo "Input rows: $(xsv count "$input_file")"
    echo "Output rows: $(xsv count "$output_file")"
}

# Data quality pipeline
quality_pipeline() {
    local file="$1"
    local report_file="quality_report.txt"
    
    echo "Running data quality pipeline for: $file"
    
    {
        echo "=== Data Quality Report ==="
        echo "File: $file"
        echo "Generated: $(date)"
        echo
        
        echo "=== Basic Statistics ==="
        xsv stats "$file" | xsv table
        echo
        
        echo "=== Duplicate Analysis ==="
        local total=$(xsv count "$file")
        local unique=$(xsv dedup "$file" | xsv count)
        echo "Total rows: $total"
        echo "Unique rows: $unique"
        echo "Duplicates: $((total - unique))"
        echo
        
        echo "=== Column Frequency Analysis ==="
        xsv headers "$file" | while read -r column; do
            echo "Column: $column"
            xsv frequency --select "$column" "$file" | head -10
            echo
        done
    } > "$report_file"
    
    echo "Quality report generated: $report_file"
}
```

### Log Analysis
```bash
# Analyze CSV logs
analyze_csv_logs() {
    local log_file="$1"
    
    echo "Analyzing CSV logs: $log_file"
    
    # Error analysis
    echo "=== Error Analysis ==="
    xsv search --select level "ERROR" "$log_file" | \
    xsv frequency --select message | \
    xsv sort --numeric --reverse --select count | \
    xsv slice --len 10 | \
    xsv table
    
    echo
    echo "=== Hourly Activity ==="
    xsv select timestamp "$log_file" | \
    xsv slice --start 1 | \
    sed 's/:[0-9][0-9]:[0-9][0-9].*$//' | \
    sort | uniq -c | sort -nr | head -10
    
    echo
    echo "=== Top Users ==="
    xsv frequency --select user "$log_file" | \
    xsv sort --numeric --reverse --select count | \
    xsv slice --len 10 | \
    xsv table
}

# Process web server logs
process_web_logs() {
    local log_file="$1"
    local output_file="$2"
    
    echo "Processing web server logs: $log_file -> $output_file"
    
    # Extract and analyze key metrics
    xsv select timestamp,method,url,status,bytes,user_agent "$log_file" | \
    xsv search --select status --regex "^[45]" | \
    xsv sort --select timestamp | \
    xsv slice --start 1 | \
    xsv fmt > "$output_file"
    
    echo "Error logs extracted: $(xsv count "$output_file") entries"
}
```

### Financial Data Processing
```bash
# Analyze financial transactions
analyze_transactions() {
    local file="$1"
    
    echo "Analyzing financial transactions: $file"
    
    # Monthly summary
    echo "=== Monthly Summary ==="
    xsv select date,amount "$file" | \
    xsv slice --start 1 | \
    sed 's/^\([0-9]\{4\}-[0-9]\{2\}\).*/\1/' | \
    xsv group --group-by date --aggregate sum --select amount | \
    xsv table
    
    echo
    echo "=== Top Expenses ==="
    xsv select description,amount "$file" | \
    xsv search --select amount --regex "^-" | \
    xsv sort --numeric --select amount | \
    xsv slice --len 10 | \
    xsv table
    
    echo
    echo "=== Category Analysis ==="
    xsv frequency --select category "$file" | \
    xsv sort --numeric --reverse --select count | \
    xsv table
}

# Budget tracking
track_budget() {
    local transactions_file="$1"
    local budget_file="$2"
    
    echo "Tracking budget vs actual spending"
    
    # Calculate actual spending by category
    xsv select category,amount "$transactions_file" | \
    xsv search --select amount --regex "^-" | \
    xsv group --group-by category --aggregate sum --select amount > actual_spending.csv
    
    # Join with budget
    xsv join category "$budget_file" category actual_spending.csv | \
    xsv select category,budget,actual | \
    xsv table
    
    rm actual_spending.csv
}
```

### Sales Data Analysis
```bash
# Sales performance analysis
analyze_sales() {
    local sales_file="$1"
    
    echo "Analyzing sales performance: $sales_file"
    
    # Top products
    echo "=== Top Products by Revenue ==="
    xsv select product,revenue "$sales_file" | \
    xsv group --group-by product --aggregate sum --select revenue | \
    xsv sort --numeric --reverse --select revenue | \
    xsv slice --len 10 | \
    xsv table
    
    echo
    echo "=== Sales by Region ==="
    xsv select region,revenue "$sales_file" | \
    xsv group --group-by region --aggregate sum --select revenue | \
    xsv sort --numeric --reverse --select revenue | \
    xsv table
    
    echo
    echo "=== Monthly Trends ==="
    xsv select date,revenue "$sales_file" | \
    xsv slice --start 1 | \
    sed 's/^\([0-9]\{4\}-[0-9]\{2\}\).*/\1/' | \
    xsv group --group-by date --aggregate sum --select revenue | \
    xsv sort --select date | \
    xsv table
}

# Customer segmentation
segment_customers() {
    local customer_file="$1"
    
    echo "Segmenting customers: $customer_file"
    
    # RFM analysis (Recency, Frequency, Monetary)
    xsv select customer_id,last_purchase_date,order_count,total_spent "$customer_file" | \
    xsv slice --start 1 | \
    awk -F',' '{
        recency = (systime() - mktime(gensub(/-/, " ", "g", $2 " 00 00 00"))) / 86400
        if (recency <= 30) r_score = 5
        else if (recency <= 90) r_score = 4
        else if (recency <= 180) r_score = 3
        else if (recency <= 365) r_score = 2
        else r_score = 1
        
        if ($3 >= 10) f_score = 5
        else if ($3 >= 5) f_score = 4
        else if ($3 >= 3) f_score = 3
        else if ($3 >= 2) f_score = 2
        else f_score = 1
        
        if ($4 >= 1000) m_score = 5
        else if ($4 >= 500) m_score = 4
        else if ($4 >= 200) m_score = 3
        else if ($4 >= 100) m_score = 2
        else m_score = 1
        
        print $1 "," r_score "," f_score "," m_score
    }' | \
    xsv add-headers customer_id,recency_score,frequency_score,monetary_score | \
    xsv table
}
```

## Troubleshooting

### Common Issues

**Issue**: File encoding problems
```bash
# Solution: Check file encoding
file -b --mime-encoding data.csv

# Solution: Convert encoding
iconv -f ISO-8859-1 -t UTF-8 data.csv > data_utf8.csv

# Solution: Handle BOM
sed '1s/^\xEF\xBB\xBF//' data.csv > data_clean.csv
```

**Issue**: Memory issues with large files
```bash
# Solution: Use streaming operations
xsv slice --start 0 --len 1000 large_file.csv | xsv stats

# Solution: Process in chunks
split -l 10000 large_file.csv chunk_
for chunk in chunk_*; do
    xsv stats "$chunk" > "${chunk}_stats.csv"
done

# Solution: Use selective operations
xsv select 1-5 large_file.csv | xsv stats
```

**Issue**: Parsing errors with malformed CSV
```bash
# Solution: Use flexible parsing
xsv count --flexible malformed.csv

# Solution: Clean the data first
sed 's/"/\\"/g' malformed.csv | xsv fmt > cleaned.csv

# Solution: Handle different delimiters
xsv fmt --delimiter ';' --out-delimiter ',' data.csv
```

### Performance Tips
```bash
# Index large files for faster searches
xsv index data.csv

# Use appropriate data types
xsv stats --infer-dates data.csv

# Combine operations in pipelines
xsv select name,age data.csv | xsv search "John" | xsv stats

# Use specific column selections
xsv select 1,3,5 data.csv  # instead of selecting all columns
```

## Comparison with Alternatives

### XSV vs csvkit
```bash
# csvkit
csvstat data.csv

# xsv (faster)
xsv stats data.csv

# xsv advantages:
# - Much faster performance
# - Lower memory usage
# - Better handling of large files
# - More comprehensive statistics
```

### XSV vs pandas (Python)
```bash
# pandas approach
python -c "import pandas as pd; print(pd.read_csv('data.csv').describe())"

# xsv approach
xsv stats data.csv

# xsv advantages:
# - No Python/pandas installation required
# - Faster for simple operations
# - Better for shell scripting
# - Lower memory usage
```

## Resources and References

- [XSV GitHub Repository](https://github.com/BurntSushi/xsv)
- [XSV Documentation](https://github.com/BurntSushi/xsv/blob/master/README.md)
- [CSV Format Specification](https://tools.ietf.org/html/rfc4180)
- [Data Analysis with Command Line Tools](https://www.datascienceatthecommandline.com/)

This guide provides comprehensive coverage of xsv installation, configuration, and usage patterns for efficient CSV data processing and analysis.