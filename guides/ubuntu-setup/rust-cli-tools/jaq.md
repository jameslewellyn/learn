# Jaq - JSON Query Tool Installation and Setup Guide

## Overview

**Jaq** is a jq clone written in Rust that provides a fast and reliable way to process JSON data. It implements most of the jq language and aims to be a drop-in replacement with better performance and additional features.

### Key Features
- **jq compatibility**: Compatible with most jq programs
- **High performance**: Written in Rust for speed and memory efficiency
- **Better error messages**: More informative error reporting
- **Unicode support**: Full Unicode support for strings
- **Streaming**: Supports streaming large JSON files
- **JSON and YAML**: Can process both JSON and YAML files

### Why Use Jaq?
- Faster than the original jq implementation
- Better error messages and debugging
- More memory efficient
- Active development and modern codebase
- Drop-in replacement for existing jq workflows
- Additional features not available in jq

## Installation

### Prerequisites
- Rust toolchain (for building from source)
- Basic understanding of JSON and jq syntax

### Via Mise (Recommended)
```bash
# Install jaq via mise
mise use -g cargo:jaq

# Verify installation
jaq --version
```

### Manual Installation
```bash
# Install via cargo
cargo install jaq

# Or download binary release
curl -L https://github.com/01mf02/jaq/releases/latest/download/jaq-linux-amd64 -o jaq
chmod +x jaq
sudo mv jaq /usr/local/bin/
```

### Verify Installation
```bash
# Test basic functionality
echo '{"name": "test"}' | jaq '.name'

# Check version
jaq --version

# Show help
jaq --help
```

## Configuration

### Shell Integration
```bash
# Add to ~/.bashrc or ~/.zshrc
alias jq='jaq'  # Use jaq as drop-in replacement

# Useful functions
json_pretty() {
    local file="$1"
    if [[ -f "$file" ]]; then
        jaq '.' "$file"
    else
        echo "$file" | jaq '.'
    fi
}

json_validate() {
    local file="$1"
    if [[ -f "$file" ]]; then
        jaq 'empty' "$file" && echo "Valid JSON" || echo "Invalid JSON"
    else
        echo "$file" | jaq 'empty' && echo "Valid JSON" || echo "Invalid JSON"
    fi
}

# Function to extract specific keys
json_extract() {
    local file="$1"
    local key="$2"
    jaq ".$key" "$file"
}

# Function to transform JSON structure
json_transform() {
    local file="$1"
    local transformation="$2"
    jaq "$transformation" "$file"
}

# Function to filter JSON arrays
json_filter() {
    local file="$1"
    local filter="$2"
    jaq ".[] | select($filter)" "$file"
}
```

### Configuration File
```bash
# Create config directory
mkdir -p ~/.config/jaq

# Create aliases file
cat > ~/.config/jaq/aliases.json << 'EOF'
{
  "pretty": ".",
  "keys": "keys",
  "values": "values",
  "length": "length",
  "type": "type",
  "flatten": "flatten",
  "unique": "unique",
  "sort": "sort",
  "reverse": "reverse"
}
EOF

# Create common filters
cat > ~/.config/jaq/filters.jq << 'EOF'
# Common jaq filters

# Extract all values from nested objects
def all_values: .. | select(type != "object" and type != "array");

# Get object paths
def paths: path(leaf_paths) as $p | $p | join(".");

# Deep merge objects
def deep_merge(other): 
  reduce (other | keys)[] as $key (.; 
    if (.[$key] | type) == "object" and ((other[$key]) | type) == "object"
    then .[$key] = (.[$key] // {}) | deep_merge(other[$key])
    else .[$key] = other[$key]
    end
  );

# Remove null values
def remove_nulls: walk(if type == "object" then with_entries(select(.value != null)) else . end);

# Flatten nested arrays
def flatten_all: [.. | select(type != "array")] | flatten;
EOF
```

## Basic Usage

### JSON Processing Basics
```bash
# Pretty print JSON
echo '{"name":"John","age":30}' | jaq '.'

# Extract specific field
echo '{"name":"John","age":30}' | jaq '.name'

# Extract multiple fields
echo '{"name":"John","age":30,"city":"NYC"}' | jaq '.name, .age'

# Create new object
echo '{"name":"John","age":30}' | jaq '{name: .name, adult: (.age >= 18)}'

# Process arrays
echo '[1,2,3,4,5]' | jaq '.[]'
echo '[1,2,3,4,5]' | jaq 'map(. * 2)'
```

### File Processing
```bash
# Process JSON file
jaq '.' data.json

# Extract specific data from file
jaq '.users[] | .name' users.json

# Filter and transform
jaq '.items[] | select(.price > 100) | .name' products.json

# Output to file
jaq '.results[] | {id: .id, name: .name}' input.json > output.json
```

### Common Operations
```bash
# Get all keys
echo '{"a":1,"b":2,"c":3}' | jaq 'keys'

# Get all values
echo '{"a":1,"b":2,"c":3}' | jaq 'values'

# Get object length
echo '{"a":1,"b":2,"c":3}' | jaq 'length'

# Check if key exists
echo '{"a":1,"b":2}' | jaq 'has("a")'

# Get type of value
echo '{"a":1,"b":"text"}' | jaq '.a | type'
```

## Advanced Usage

### Complex Queries
```bash
# Nested object navigation
echo '{"user":{"profile":{"name":"John"}}}' | jaq '.user.profile.name'

# Optional navigation (won't fail if key doesn't exist)
echo '{"user":{"profile":{}}}' | jaq '.user.profile.name?'

# Array indexing
echo '["a","b","c"]' | jaq '.[1]'

# Array slicing
echo '["a","b","c","d","e"]' | jaq '.[1:3]'

# Recursive descent
echo '{"a":{"b":{"c":1}}}' | jaq '.. | .c?'
```

### Data Transformation
```bash
# Transform array of objects
cat > users.json << 'EOF'
[
  {"id": 1, "name": "John", "age": 30, "city": "NYC"},
  {"id": 2, "name": "Jane", "age": 25, "city": "LA"},
  {"id": 3, "name": "Bob", "age": 35, "city": "Chicago"}
]
EOF

# Extract names only
jaq '.[].name' users.json

# Filter by age
jaq '.[] | select(.age > 28)' users.json

# Group by city
jaq 'group_by(.city)' users.json

# Create summary
jaq '{
  total: length,
  avg_age: (map(.age) | add / length),
  cities: [.[].city] | unique
}' users.json
```

### Working with APIs
```bash
# Process API response
curl -s "https://api.github.com/users/octocat" | jaq '{
  name: .name,
  followers: .followers,
  repos: .public_repos
}'

# Extract specific fields from API array
curl -s "https://api.github.com/users/octocat/repos" | jaq '.[] | {
  name: .name,
  language: .language,
  stars: .stargazers_count
} | select(.language != null)'

# Process paginated API results
api_collect() {
    local url="$1"
    local page=1
    local all_results="[]"
    
    while true; do
        local response=$(curl -s "${url}?page=${page}")
        local results=$(echo "$response" | jaq '.')
        
        # Check if we got results
        if [[ "$(echo "$results" | jaq 'length')" -eq 0 ]]; then
            break
        fi
        
        # Merge results
        all_results=$(echo "$all_results" | jaq ". + $results")
        ((page++))
    done
    
    echo "$all_results"
}
```

### Configuration File Processing
```bash
# Process package.json
jaq '.dependencies | keys' package.json

# Extract script commands
jaq '.scripts | to_entries | .[] | "\(.key): \(.value)"' package.json

# Process Docker compose
jaq '.services | keys' docker-compose.yml

# Extract environment variables
jaq '.services[].environment // {} | to_entries | .[] | "\(.key)=\(.value)"' docker-compose.yml
```

### Log Processing
```bash
# Process JSON logs
process_logs() {
    local log_file="$1"
    local level="${2:-INFO}"
    
    jaq --raw-input --slurp '
        split("\n") | 
        map(select(length > 0) | fromjson) | 
        map(select(.level == "'"$level"'")) |
        .[] | 
        "\(.timestamp) [\(.level)] \(.message)"
    ' "$log_file"
}

# Analyze log patterns
analyze_logs() {
    local log_file="$1"
    
    jaq --raw-input --slurp '
        split("\n") | 
        map(select(length > 0) | fromjson) | 
        {
            total: length,
            by_level: group_by(.level) | map({level: .[0].level, count: length}),
            errors: map(select(.level == "ERROR")) | length,
            warnings: map(select(.level == "WARN")) | length
        }
    ' "$log_file"
}

# Extract error details
extract_errors() {
    local log_file="$1"
    
    jaq --raw-input --slurp '
        split("\n") | 
        map(select(length > 0) | fromjson) | 
        map(select(.level == "ERROR")) |
        .[] |
        {
            timestamp: .timestamp,
            message: .message,
            stack: .stack // null
        }
    ' "$log_file"
}
```

### Data Validation and Cleaning
```bash
# Validate JSON structure
validate_schema() {
    local file="$1"
    local required_fields=("name" "email" "age")
    
    for field in "${required_fields[@]}"; do
        if ! jaq "has(\"$field\")" "$file" | grep -q true; then
            echo "Missing required field: $field"
            return 1
        fi
    done
    
    echo "Schema validation passed"
}

# Clean and normalize data
clean_data() {
    local file="$1"
    
    jaq '
        # Remove null values
        walk(if type == "object" then with_entries(select(.value != null)) else . end) |
        # Normalize strings
        walk(if type == "string" then . | ascii_downcase | ltrimstr(" ") | rtrimstr(" ") else . end) |
        # Ensure required fields exist
        if has("name") | not then . + {"name": "unknown"} else . end
    ' "$file"
}

# Data type conversion
convert_types() {
    local file="$1"
    
    jaq '
        # Convert string numbers to numbers
        walk(if type == "string" and test("^[0-9]+$") then tonumber else . end) |
        # Convert string booleans to booleans
        walk(if . == "true" then true elif . == "false" then false else . end) |
        # Normalize dates
        walk(if type == "string" and test("^[0-9]{4}-[0-9]{2}-[0-9]{2}") then . + "T00:00:00Z" else . end)
    ' "$file"
}
```

### Integration with Other Tools
```bash
# Combine with curl for API processing
api_query() {
    local url="$1"
    local query="$2"
    
    curl -s "$url" | jaq "$query"
}

# Process CSV to JSON and back
csv_to_json() {
    local csv_file="$1"
    local headers=$(head -1 "$csv_file")
    
    tail -n +2 "$csv_file" | while IFS=',' read -r line; do
        echo "$line"
    done | jaq --raw-input --slurp '
        split("\n") | 
        map(select(length > 0) | split(",")) |
        map({name: .[0], email: .[1], age: .[2] | tonumber})
    '
}

# Database query result processing
process_db_results() {
    local query_result="$1"
    
    echo "$query_result" | jaq '
        .results[] | 
        {
            id: .id,
            name: .name,
            created: .created_at,
            updated: .updated_at
        }
    '
}
```

## Integration Examples

### CI/CD Pipeline Processing
```bash
# Process build artifacts
process_build_info() {
    local build_json="$1"
    
    jaq '{
        build_id: .id,
        status: .status,
        duration: .duration,
        artifacts: .artifacts | length,
        tests: {
            total: .test_results.total,
            passed: .test_results.passed,
            failed: .test_results.failed
        }
    }' "$build_json"
}

# Extract deployment configuration
extract_deploy_config() {
    local config_file="$1"
    local environment="$2"
    
    jaq ".environments.$environment | {
        image: .image,
        replicas: .replicas,
        resources: .resources,
        env_vars: .env_vars
    }" "$config_file"
}
```

### Monitoring and Metrics
```bash
# Process metrics JSON
process_metrics() {
    local metrics_file="$1"
    
    jaq '{
        timestamp: .timestamp,
        cpu_usage: .system.cpu.usage,
        memory_usage: .system.memory.usage,
        disk_usage: .system.disk.usage,
        active_connections: .network.active_connections
    }' "$metrics_file"
}

# Generate alerts from metrics
generate_alerts() {
    local metrics_file="$1"
    
    jaq '
        select(.system.cpu.usage > 80 or .system.memory.usage > 90) |
        {
            alert_type: "resource_high",
            timestamp: .timestamp,
            cpu: .system.cpu.usage,
            memory: .system.memory.usage,
            severity: (if .system.cpu.usage > 90 or .system.memory.usage > 95 then "critical" else "warning" end)
        }
    ' "$metrics_file"
}
```

### Configuration Management
```bash
# Process Kubernetes manifests
process_k8s_manifest() {
    local manifest_file="$1"
    
    jaq '
        if .kind == "Deployment" then
            {
                name: .metadata.name,
                namespace: .metadata.namespace,
                replicas: .spec.replicas,
                image: .spec.template.spec.containers[0].image,
                ports: .spec.template.spec.containers[0].ports
            }
        elif .kind == "Service" then
            {
                name: .metadata.name,
                type: .spec.type,
                ports: .spec.ports
            }
        else
            {name: .metadata.name, kind: .kind}
        end
    ' "$manifest_file"
}

# Merge configuration files
merge_configs() {
    local base_config="$1"
    local override_config="$2"
    
    jaq --slurpfile override "$override_config" '
        . as $base |
        $override[0] as $override |
        def deep_merge(other): 
            reduce (other | keys)[] as $key (.; 
                if (.[$key] | type) == "object" and ((other[$key]) | type) == "object"
                then .[$key] = (.[$key] // {}) | deep_merge(other[$key])
                else .[$key] = other[$key]
                end
            );
        $base | deep_merge($override)
    ' "$base_config"
}
```

## Troubleshooting

### Common Issues

**Issue**: Invalid JSON input
```bash
# Solution: Validate JSON first
echo '{"invalid": json}' | jaq '.' 2>&1 | grep -q "parse error" && echo "Invalid JSON"

# Solution: Use raw input for non-JSON data
echo 'plain text' | jaq --raw-input '.'

# Solution: Process line-by-line
cat file.txt | jaq --raw-input --slurp 'split("\n")'
```

**Issue**: Complex nested queries failing
```bash
# Solution: Use optional navigation
jaq '.user.profile.name?' instead of jaq '.user.profile.name'

# Solution: Use try-catch
jaq 'try .user.profile.name catch "default"'

# Solution: Check existence first
jaq 'if has("user") then .user.profile.name else null end'
```

**Issue**: Memory issues with large files
```bash
# Solution: Use streaming mode
jaq --stream '. as $item | $item' large_file.json

# Solution: Process in chunks
split -l 1000 large_file.json chunk_
for chunk in chunk_*; do
    jaq '.' "$chunk" >> processed.json
done
```

### Performance Tips
```bash
# Use specific selectors instead of recursive descent
jaq '.users[].name' instead of jaq '.. | .name?'

# Avoid unnecessary operations
jaq '.[] | select(.active)' instead of jaq 'map(select(.active))[]'

# Use streaming for large files
jaq --stream '.' large_file.json

# Combine operations when possible
jaq '.[] | {name: .name, age: .age} | select(.age > 18)' instead of multiple pipes
```

### Debugging
```bash
# Use debug output
jaq --debug '.' input.json

# Add debug statements
jaq '. | debug | .field' input.json

# Print intermediate results
jaq '. as $orig | .field | debug | $orig' input.json
```

## Comparison with Alternatives

### Jaq vs jq
```bash
# Performance comparison
time jq '.' large_file.json
time jaq '.' large_file.json

# Both support same syntax
jq '.[] | select(.active)' file.json
jaq '.[] | select(.active)' file.json

# Jaq advantages:
# - Better performance
# - Better error messages
# - More memory efficient
# - Unicode support
```

### Jaq vs other JSON processors
```bash
# jaq (comprehensive)
jaq '.users[] | select(.age > 18) | .name'

# yq (YAML focused)
yq '.users[] | select(.age > 18) | .name'

# jaq advantages:
# - jq compatibility
# - Better performance
# - More features
```

## Resources and References

- [Jaq GitHub Repository](https://github.com/01mf02/jaq)
- [jq Manual](https://stedolan.github.io/jq/manual/) (syntax reference)
- [jq Tutorial](https://stedolan.github.io/jq/tutorial/)
- [JSON Processing Examples](https://github.com/01mf02/jaq/tree/main/examples)

This guide provides comprehensive coverage of jaq installation, configuration, and usage patterns for efficient JSON processing and data manipulation.