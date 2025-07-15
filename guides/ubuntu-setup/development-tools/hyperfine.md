# Hyperfine - Command-line Benchmarking Tool Installation and Setup Guide

## Overview

**Hyperfine** is a command-line benchmarking tool written in Rust that allows you to benchmark commands and compare their performance. It provides statistical analysis, warmup runs, and detailed output formatting, making it ideal for performance testing and optimization workflows.

### Key Features
- **Statistical analysis**: Mean, median, standard deviation, and range
- **Warmup runs**: Eliminate cold start effects
- **Multiple command comparison**: Side-by-side performance comparison
- **Export formats**: JSON, CSV, and markdown output
- **Parameter sweeps**: Test commands with different parameters
- **Shell integration**: Works with any shell command

### Why Use Hyperfine?
- More accurate than manual timing with `time`
- Statistical significance testing
- Easy comparison of multiple approaches
- Professional benchmark reporting
- Integrated warmup and preparation commands
- Cross-platform compatibility

## Installation

### Prerequisites
- Any Unix-like system
- Commands you want to benchmark

### Via Mise (Recommended)
```bash
# Install hyperfine via mise
mise use -g hyperfine

# Verify installation
hyperfine --version
```

### Manual Installation
```bash
# Install via cargo
cargo install hyperfine

# Or download binary release
curl -L https://github.com/sharkdp/hyperfine/releases/latest/download/hyperfine-v1.18.0-x86_64-unknown-linux-gnu.tar.gz | tar xz
sudo mv hyperfine /usr/local/bin/
```

### Verify Installation
```bash
# Test basic functionality
hyperfine --help

# Simple benchmark test
hyperfine 'sleep 0.1'
```

## Configuration

### Shell Integration
```bash
# Add to ~/.bashrc or ~/.zshrc
alias bench='hyperfine'
alias compare='hyperfine --show-output'

# Function for quick benchmarking
quick_bench() {
    local cmd="$1"
    local runs="${2:-10}"
    hyperfine --runs "$runs" "$cmd"
}

# Function for comparing two commands
compare_commands() {
    local cmd1="$1"
    local cmd2="$2"
    hyperfine --show-output "$cmd1" "$cmd2"
}
```

### Environment Variables
```bash
# Set default options
export HYPERFINE_RUNS=10
export HYPERFINE_WARMUP=3

# Add to shell functions
benchmark_with_defaults() {
    hyperfine \
        --runs "${HYPERFINE_RUNS:-10}" \
        --warmup "${HYPERFINE_WARMUP:-3}" \
        "$@"
}
```

## Basic Usage

### Simple Benchmarking
```bash
# Benchmark a single command
hyperfine 'ls -la'

# Benchmark with specific number of runs
hyperfine --runs 50 'grep "pattern" file.txt'

# Benchmark with warmup runs
hyperfine --warmup 5 'python script.py'
```

### Command Comparison
```bash
# Compare two commands
hyperfine 'grep "pattern" file.txt' 'rg "pattern" file.txt'

# Compare multiple commands
hyperfine \
    'find . -name "*.txt"' \
    'fd -e txt' \
    'locate "*.txt"'

# Compare with descriptive names
hyperfine \
    --command-name 'grep' 'grep "pattern" file.txt' \
    --command-name 'ripgrep' 'rg "pattern" file.txt'
```

### Parameter Sweeps
```bash
# Test with different parameters
hyperfine --parameter-scan num 1 10 'head -n {num} large_file.txt'

# Test with different thread counts
hyperfine --parameter-scan threads 1 8 'sort --parallel={threads} large_file.txt'

# Test with different file sizes
hyperfine --parameter-scan size 1000 10000 --parameter-step-size 1000 \
    'head -n {size} /dev/urandom | sort'
```

## Advanced Usage

### Preparation and Cleanup
```bash
# Prepare before each run
hyperfine \
    --prepare 'sync; echo 3 > /proc/sys/vm/drop_caches' \
    'grep "pattern" large_file.txt'

# Cleanup after each run
hyperfine \
    --cleanup 'rm -f temp_file.txt' \
    'process_data.py > temp_file.txt'

# Both preparation and cleanup
hyperfine \
    --prepare 'cp original.txt working.txt' \
    --cleanup 'rm -f working.txt' \
    'process_file.py working.txt'
```

### Export and Reporting
```bash
# Export to JSON
hyperfine --export-json benchmark_results.json 'command_to_test'

# Export to CSV
hyperfine --export-csv benchmark_results.csv 'command_to_test'

# Export to markdown
hyperfine --export-markdown benchmark_results.md \
    'grep "pattern" file.txt' \
    'rg "pattern" file.txt'

# Multiple export formats
hyperfine \
    --export-json results.json \
    --export-csv results.csv \
    --export-markdown results.md \
    'command_to_test'
```

### Complex Benchmarking Scenarios
```bash
# Benchmark with different input sizes
benchmark_scaling() {
    local command="$1"
    local min_size="${2:-1000}"
    local max_size="${3:-10000}"
    local step="${4:-1000}"
    
    hyperfine \
        --parameter-scan size "$min_size" "$max_size" \
        --parameter-step-size "$step" \
        --export-json "scaling_results.json" \
        "$command"
}

# Benchmark with different algorithms
compare_algorithms() {
    hyperfine \
        --warmup 3 \
        --runs 20 \
        --export-markdown "algorithm_comparison.md" \
        --command-name 'quicksort' './sort --algorithm=quick input.txt' \
        --command-name 'mergesort' './sort --algorithm=merge input.txt' \
        --command-name 'heapsort' './sort --algorithm=heap input.txt'
}
```

### Performance Regression Testing
```bash
#!/bin/bash
# Performance regression test script

performance_test() {
    local test_command="$1"
    local baseline_file="$2"
    local current_results="current_benchmark.json"
    
    echo "Running performance test for: $test_command"
    
    # Run benchmark
    hyperfine \
        --runs 20 \
        --warmup 5 \
        --export-json "$current_results" \
        "$test_command"
    
    # Compare with baseline (conceptual - would need custom script)
    if [ -f "$baseline_file" ]; then
        echo "Comparing with baseline..."
        compare_benchmarks.py "$baseline_file" "$current_results"
    else
        echo "No baseline found, saving current results as baseline"
        cp "$current_results" "$baseline_file"
    fi
}

# CI/CD integration
ci_performance_check() {
    local test_suite="$1"
    local threshold_percent="${2:-10}"
    
    echo "Running CI performance check"
    
    # Run benchmarks
    hyperfine \
        --runs 10 \
        --warmup 3 \
        --export-json "ci_results.json" \
        "$test_suite"
    
    # Check for performance regression
    if check_performance_regression.py "ci_results.json" "$threshold_percent"; then
        echo "Performance check passed"
        exit 0
    else
        echo "Performance regression detected!"
        exit 1
    fi
}
```

### Development Workflow Integration
```bash
# Benchmark build times
benchmark_build() {
    local project_dir="$1"
    cd "$project_dir" || exit 1
    
    hyperfine \
        --prepare 'make clean' \
        --warmup 1 \
        --runs 5 \
        --export-markdown "build_benchmark.md" \
        'make -j1' \
        'make -j2' \
        'make -j4' \
        'make -j8'
}

# Test optimization impact
test_optimization() {
    local source_file="$1"
    local optimization_levels=("-O0" "-O1" "-O2" "-O3")
    
    for opt in "${optimization_levels[@]}"; do
        gcc "$opt" -o "test_$opt" "$source_file"
    done
    
    hyperfine \
        --warmup 5 \
        --runs 20 \
        --export-markdown "optimization_results.md" \
        --command-name 'O0' './test_-O0' \
        --command-name 'O1' './test_-O1' \
        --command-name 'O2' './test_-O2' \
        --command-name 'O3' './test_-O3'
}
```

### Database and System Benchmarking
```bash
# Database query benchmarking
benchmark_queries() {
    local db_name="$1"
    
    hyperfine \
        --prepare 'systemctl restart postgresql' \
        --warmup 3 \
        --runs 10 \
        --export-json "db_benchmark.json" \
        --command-name 'simple_query' "psql -d $db_name -c 'SELECT * FROM users LIMIT 1000;'" \
        --command-name 'complex_query' "psql -d $db_name -c 'SELECT u.*, p.* FROM users u JOIN profiles p ON u.id = p.user_id;'" \
        --command-name 'indexed_query' "psql -d $db_name -c 'SELECT * FROM users WHERE email = \"test@example.com\";'"
}

# System utility benchmarking
benchmark_system_tools() {
    local test_dir="$1"
    
    hyperfine \
        --warmup 2 \
        --runs 10 \
        --export-markdown "system_tools_benchmark.md" \
        --command-name 'find' "find $test_dir -name '*.txt'" \
        --command-name 'fd' "fd -e txt . $test_dir" \
        --command-name 'locate' "locate '*.txt' | grep $test_dir"
}
```

### Scripting and Automation
```bash
# Automated performance monitoring
monitor_performance() {
    local command="$1"
    local alert_threshold="$2"
    local log_file="performance_log.json"
    
    while true; do
        hyperfine \
            --runs 5 \
            --export-json "$log_file" \
            "$command"
        
        # Check if performance degraded (conceptual)
        if check_performance_threshold.py "$log_file" "$alert_threshold"; then
            echo "Performance within acceptable range"
        else
            echo "Performance alert: Command is running slower than expected"
            send_alert.py "Performance degradation detected for: $command"
        fi
        
        sleep 300  # Check every 5 minutes
    done
}

# Batch benchmarking
batch_benchmark() {
    local commands_file="$1"
    local output_dir="$2"
    
    mkdir -p "$output_dir"
    
    while IFS= read -r cmd; do
        local safe_name=$(echo "$cmd" | tr ' /' '_-')
        echo "Benchmarking: $cmd"
        
        hyperfine \
            --runs 10 \
            --warmup 3 \
            --export-json "$output_dir/${safe_name}.json" \
            --export-markdown "$output_dir/${safe_name}.md" \
            "$cmd"
    done < "$commands_file"
}
```

## Integration Examples

### With Development Tools
```bash
# Test different Python implementations
python_benchmark() {
    local script="$1"
    
    hyperfine \
        --warmup 3 \
        --runs 20 \
        --export-markdown "python_benchmark.md" \
        --command-name 'python3' "python3 $script" \
        --command-name 'pypy3' "pypy3 $script"
}

# Compare JavaScript engines
js_benchmark() {
    local script="$1"
    
    hyperfine \
        --warmup 2 \
        --runs 15 \
        --export-markdown "js_benchmark.md" \
        --command-name 'node' "node $script" \
        --command-name 'deno' "deno run $script"
}
```

### With System Administration
```bash
# Compare backup methods
backup_benchmark() {
    local source_dir="$1"
    local backup_dir="$2"
    
    hyperfine \
        --prepare "rm -rf $backup_dir/*" \
        --warmup 1 \
        --runs 5 \
        --export-markdown "backup_benchmark.md" \
        --command-name 'tar' "tar -czf $backup_dir/backup.tar.gz $source_dir" \
        --command-name 'rsync' "rsync -av $source_dir/ $backup_dir/" \
        --command-name 'cp' "cp -r $source_dir $backup_dir/"
}

# Network tool comparison
network_benchmark() {
    local host="$1"
    
    hyperfine \
        --runs 10 \
        --export-markdown "network_benchmark.md" \
        --command-name 'ping' "ping -c 5 $host" \
        --command-name 'curl' "curl -s $host > /dev/null" \
        --command-name 'wget' "wget -q $host -O /dev/null"
}
```

## Troubleshooting

### Common Issues

**Issue**: Inconsistent results
```bash
# Solution: Increase warmup runs and total runs
hyperfine --warmup 10 --runs 50 'command_to_test'

# Solution: Use preparation to ensure consistent state
hyperfine --prepare 'sync; echo 3 > /proc/sys/vm/drop_caches' 'command_to_test'
```

**Issue**: Commands with side effects
```bash
# Solution: Use cleanup to reset state
hyperfine --cleanup 'rm -f temp_files*' 'command_that_creates_files'

# Solution: Use preparation to reset state
hyperfine --prepare 'cp original.txt working.txt' 'command_modifies_working.txt'
```

**Issue**: Very fast commands
```bash
# Solution: Use parameter sweeps to test with different loads
hyperfine --parameter-scan size 1000 10000 'head -n {size} large_file.txt'

# Solution: Increase the workload
hyperfine 'for i in {1..1000}; do fast_command; done'
```

### Performance Tips
```bash
# Use appropriate number of runs
hyperfine --runs 50 'very_stable_command'  # Many runs for stable commands
hyperfine --runs 10 'variable_command'     # Fewer runs for variable commands

# Use warmup for I/O bound commands
hyperfine --warmup 5 'command_with_file_io'

# Use preparation for fair comparison
hyperfine --prepare 'clear_cache_command' 'io_intensive_command'
```

## Resources and References

- [Hyperfine GitHub Repository](https://github.com/sharkdp/hyperfine)
- [Hyperfine Documentation](https://github.com/sharkdp/hyperfine/blob/master/README.md)
- [Benchmarking Best Practices](https://github.com/sharkdp/hyperfine/wiki/Benchmarking-best-practices)
- [Statistical Analysis of Benchmarks](https://github.com/sharkdp/hyperfine/wiki/Statistical-analysis)

This guide provides comprehensive coverage of hyperfine installation, configuration, and usage patterns for accurate command-line benchmarking and performance analysis.