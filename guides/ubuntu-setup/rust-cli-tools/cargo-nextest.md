# Cargo Nextest - Next-Generation Test Runner Installation and Setup Guide

## Overview

**Cargo Nextest** is a next-generation test runner for Rust that provides faster, more reliable, and more feature-rich testing than the built-in `cargo test`. It's designed to handle complex test scenarios, provide better output formatting, and support advanced features like test partitioning and retry logic.

### Key Features
- **Faster test execution**: Improved parallelization and caching
- **Better output formatting**: Enhanced test result display
- **Test partitioning**: Split tests across multiple jobs for CI/CD
- **Retry logic**: Automatic retry of flaky tests
- **JUnit XML output**: Integration with CI/CD systems
- **Advanced filtering**: Sophisticated test selection
- **Binary caching**: Faster subsequent runs

### Why Use Cargo Nextest?
- Significantly faster test execution
- Better CI/CD integration
- More reliable handling of flaky tests
- Enhanced debugging capabilities
- Better resource utilization
- Improved test organization and reporting

## Installation

### Prerequisites
- Rust toolchain (rustc 1.56+)
- Cargo package manager
- Active Rust project with tests

### Via Mise (Recommended)
```bash
# Install cargo-nextest via mise
mise use -g cargo:cargo-nextest

# Verify installation
cargo nextest --version
```

### Manual Installation
```bash
# Install via cargo
cargo install cargo-nextest --locked

# Or install the latest version from GitHub
cargo install --git https://github.com/nextest-rs/nextest cargo-nextest
```

### Verify Installation
```bash
# Check installation
cargo nextest --version

# Test with a simple Rust project
cargo nextest run --help

# Run tests if you have a Rust project
cargo nextest run
```

## Configuration

### Basic Configuration
```bash
# Create nextest configuration directory
mkdir -p .config

# Create basic nextest.toml
cat > .config/nextest.toml << 'EOF'
[profile.default]
# Number of tests to run simultaneously
test-threads = 8

# Timeout for individual tests
slow-timeout = "60s"

# Timeout for the entire test run
test-timeout = "300s"

# Number of retries for flaky tests
retries = 0

# Fail fast on first failure
fail-fast = false

# Show output for failing tests
failure-output = "immediate"

# Show output for successful tests
success-output = "never"

# Enable colored output
color = "auto"
EOF
```

### Advanced Configuration
```bash
# Advanced nextest configuration
cat > .config/nextest.toml << 'EOF'
[profile.default]
test-threads = 8
slow-timeout = "60s"
leak-timeout = "100ms"
test-timeout = "300s"
retries = 2
fail-fast = false
failure-output = "immediate"
success-output = "never"
status-level = "pass"
final-status-level = "flaky"

[profile.ci]
# Configuration for CI environment
test-threads = 4
slow-timeout = "30s"
test-timeout = "600s"
retries = 1
fail-fast = true
failure-output = "immediate-final"
success-output = "never"
status-level = "retry"
final-status-level = "slow"

[profile.local]
# Configuration for local development
test-threads = 12
slow-timeout = "10s"
test-timeout = "120s"
retries = 0
fail-fast = false
failure-output = "immediate"
success-output = "final"
status-level = "slow"

# Test filtering
[[profile.default.overrides]]
filter = "test(slow_test)"
slow-timeout = "5m"
test-timeout = "10m"

[[profile.default.overrides]]
filter = "test(integration)"
test-threads = 2
retries = 3

# Environment variables
[profile.default.env]
RUST_BACKTRACE = "1"
RUST_LOG = "info"
EOF
```

### Shell Integration
```bash
# Add to ~/.bashrc or ~/.zshrc
alias nt='cargo nextest run'
alias ntr='cargo nextest run --retries 3'
alias ntf='cargo nextest run --fail-fast'
alias ntv='cargo nextest run --nocapture'
alias nts='cargo nextest run --status-level slow'

# Useful functions
nextest_profile() {
    local profile="${1:-default}"
    echo "Running tests with profile: $profile"
    cargo nextest run --profile "$profile"
}

nextest_filter() {
    local filter="$1"
    echo "Running tests matching: $filter"
    cargo nextest run --filter "$filter"
}

nextest_package() {
    local package="$1"
    echo "Running tests for package: $package"
    cargo nextest run --package "$package"
}

# Function to run tests with custom settings
nextest_custom() {
    local threads="${1:-8}"
    local timeout="${2:-60s}"
    local retries="${3:-0}"
    
    echo "Running tests with $threads threads, ${timeout} timeout, $retries retries"
    cargo nextest run \
        --test-threads "$threads" \
        --slow-timeout "$timeout" \
        --retries "$retries"
}

# Function to analyze test results
nextest_analyze() {
    local results_file="test-results.xml"
    
    echo "Analyzing test results..."
    cargo nextest run --message-format json > nextest-results.json
    
    # Extract statistics
    echo "=== Test Statistics ==="
    jq '.test-finished | group_by(.status) | map({status: .[0].status, count: length})' nextest-results.json
    
    # Show failed tests
    echo "=== Failed Tests ==="
    jq '.test-finished | select(.status == "failed") | .name' nextest-results.json
    
    # Show slow tests
    echo "=== Slow Tests ==="
    jq '.test-finished | select(.exec_time > 1.0) | {name: .name, time: .exec_time} | sort_by(.time) | reverse' nextest-results.json
}
```

## Basic Usage

### Running Tests
```bash
# Run all tests
cargo nextest run

# Run tests with specific number of threads
cargo nextest run --test-threads 4

# Run tests with timeout
cargo nextest run --test-timeout 30s

# Run tests with retries
cargo nextest run --retries 3

# Run tests with fail-fast
cargo nextest run --fail-fast
```

### Test Filtering
```bash
# Run tests matching pattern
cargo nextest run test_name

# Run tests in specific package
cargo nextest run --package my_package

# Run tests with complex filter
cargo nextest run --filter "test(integration) and not test(slow)"

# Run only tests that previously failed
cargo nextest run --failed

# Run tests by their full path
cargo nextest run --exact my_crate::tests::test_function
```

### Output Control
```bash
# Show output for all tests
cargo nextest run --success-output immediate

# Show output only for failed tests
cargo nextest run --failure-output immediate

# Capture output and show at the end
cargo nextest run --success-output final --failure-output final

# Show test output as it happens
cargo nextest run --nocapture

# Control verbosity
cargo nextest run --status-level all
```

## Advanced Usage

### Test Partitioning
```bash
# Split tests across multiple jobs (useful for CI)
cargo nextest run --partition count:1/4
cargo nextest run --partition count:2/4
cargo nextest run --partition count:3/4
cargo nextest run --partition count:4/4

# Hash-based partitioning
cargo nextest run --partition hash:1/4
cargo nextest run --partition hash:2/4
cargo nextest run --partition hash:3/4
cargo nextest run --partition hash:4/4
```

### Profile Management
```bash
# Run with specific profile
cargo nextest run --profile ci

# Create custom profile for different scenarios
cat > .config/nextest.toml << 'EOF'
[profile.debug]
test-threads = 1
slow-timeout = "10m"
test-timeout = "30m"
retries = 0
failure-output = "immediate"
success-output = "immediate"
status-level = "all"

[profile.integration]
test-threads = 2
slow-timeout = "5m"
test-timeout = "15m"
retries = 2
failure-output = "immediate-final"
success-output = "never"
filter = "test(integration)"

[profile.unit]
test-threads = 16
slow-timeout = "10s"
test-timeout = "60s"
retries = 0
failure-output = "immediate"
success-output = "never"
filter = "not test(integration)"
EOF

# Run with custom profiles
cargo nextest run --profile debug
cargo nextest run --profile integration
cargo nextest run --profile unit
```

### CI/CD Integration
```bash
# Generate JUnit XML output
cargo nextest run --message-format json | cargo nextest junit > test-results.xml

# Run tests with CI-friendly settings
cargo nextest run \
    --profile ci \
    --partition count:${CI_NODE_INDEX}/${CI_NODE_TOTAL} \
    --retries 3 \
    --fail-fast \
    --message-format json \
    > test-results.json

# Create GitHub Actions workflow
cat > .github/workflows/test.yml << 'EOF'
name: Test with Nextest

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        partition: [1, 2, 3, 4]
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Install Rust
      uses: actions-rs/toolchain@v1
      with:
        toolchain: stable
        override: true
    
    - name: Install nextest
      run: cargo install cargo-nextest
    
    - name: Cache cargo
      uses: actions/cache@v3
      with:
        path: ~/.cargo
        key: ${{ runner.os }}-cargo-${{ hashFiles('**/Cargo.lock') }}
    
    - name: Run tests
      run: |
        cargo nextest run \
          --profile ci \
          --partition count:${{ matrix.partition }}/4 \
          --retries 3 \
          --message-format json \
          > test-results-${{ matrix.partition }}.json
    
    - name: Generate JUnit XML
      run: |
        cargo nextest junit \
          < test-results-${{ matrix.partition }}.json \
          > test-results-${{ matrix.partition }}.xml
    
    - name: Upload test results
      uses: actions/upload-artifact@v3
      if: always()
      with:
        name: test-results-${{ matrix.partition }}
        path: test-results-${{ matrix.partition }}.xml
EOF
```

### Custom Test Runners
```bash
# Create custom test runner script
cat > scripts/test-runner.sh << 'EOF'
#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
TEST_THREADS=${TEST_THREADS:-8}
RETRIES=${RETRIES:-2}
TIMEOUT=${TIMEOUT:-300s}
PROFILE=${PROFILE:-default}

echo -e "${GREEN}Starting test run with nextest${NC}"
echo "Profile: $PROFILE"
echo "Threads: $TEST_THREADS"
echo "Retries: $RETRIES"
echo "Timeout: $TIMEOUT"
echo

# Run tests and capture output
if cargo nextest run \
    --profile "$PROFILE" \
    --test-threads "$TEST_THREADS" \
    --retries "$RETRIES" \
    --test-timeout "$TIMEOUT" \
    --message-format json \
    > test-results.json 2>&1; then
    
    echo -e "${GREEN}All tests passed!${NC}"
    
    # Show summary
    echo -e "\n${GREEN}Test Summary:${NC}"
    jq -r '.test-finished | group_by(.status) | map("\(.[]|.[0].status): \(length)") | join(", ")' test-results.json
    
    # Show slow tests
    echo -e "\n${YELLOW}Slow Tests (>1s):${NC}"
    jq -r '.test-finished | select(.exec_time > 1.0) | "\(.name): \(.exec_time)s"' test-results.json | head -10
    
else
    echo -e "${RED}Some tests failed!${NC}"
    
    # Show failed tests
    echo -e "\n${RED}Failed Tests:${NC}"
    jq -r '.test-finished | select(.status == "failed") | .name' test-results.json
    
    # Show retry information
    echo -e "\n${YELLOW}Retry Information:${NC}"
    jq -r '.test-finished | select(.status == "failed" and .retry_count > 0) | "\(.name): \(.retry_count) retries"' test-results.json
    
    exit 1
fi
EOF

chmod +x scripts/test-runner.sh
```

### Test Analysis and Reporting
```bash
# Test performance analysis
analyze_test_performance() {
    local results_file="test-results.json"
    
    echo "=== Test Performance Analysis ==="
    
    # Total test time
    local total_time=$(jq '[.test-finished | .exec_time] | add' "$results_file")
    echo "Total test time: ${total_time}s"
    
    # Slowest tests
    echo -e "\n=== Slowest Tests ==="
    jq -r '.test-finished | sort_by(.exec_time) | reverse | .[:10] | .[] | "\(.name): \(.exec_time)s"' "$results_file"
    
    # Test distribution by time
    echo -e "\n=== Test Duration Distribution ==="
    jq -r '.test-finished | group_by(if .exec_time < 0.1 then "fast" elif .exec_time < 1.0 then "medium" else "slow" end) | map({category: .[0] | if .exec_time < 0.1 then "fast" elif .exec_time < 1.0 then "medium" else "slow" end, count: length}) | .[]' "$results_file"
    
    # Memory usage analysis (if available)
    if jq -e '.test-finished[0] | has("memory_usage")' "$results_file" > /dev/null; then
        echo -e "\n=== Memory Usage ==="
        jq -r '.test-finished | sort_by(.memory_usage) | reverse | .[:5] | .[] | "\(.name): \(.memory_usage)MB"' "$results_file"
    fi
}

# Flaky test detection
detect_flaky_tests() {
    local results_file="test-results.json"
    
    echo "=== Flaky Test Detection ==="
    
    # Tests that were retried
    echo "Tests that required retries:"
    jq -r '.test-finished | select(.retry_count > 0) | "\(.name): \(.retry_count) retries (\(.status))"' "$results_file"
    
    # Tests that eventually passed after retries
    echo -e "\nTests that passed after retries:"
    jq -r '.test-finished | select(.retry_count > 0 and .status == "passed") | "\(.name): \(.retry_count) retries"' "$results_file"
    
    # Tests that failed even after retries
    echo -e "\nTests that failed after retries:"
    jq -r '.test-finished | select(.retry_count > 0 and .status == "failed") | "\(.name): \(.retry_count) retries"' "$results_file"
}

# Generate test report
generate_test_report() {
    local results_file="test-results.json"
    local report_file="test-report.html"
    
    cat > "$report_file" << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Test Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .passed { color: green; }
        .failed { color: red; }
        .slow { color: orange; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <h1>Test Report</h1>
    <div id="summary"></div>
    <div id="details"></div>
    
    <script>
        // Load and display test results
        fetch('test-results.json')
            .then(response => response.json())
            .then(data => {
                displaySummary(data);
                displayDetails(data);
            });
        
        function displaySummary(data) {
            // Implementation for summary display
        }
        
        function displayDetails(data) {
            // Implementation for detailed results
        }
    </script>
</body>
</html>
EOF
    
    echo "Test report generated: $report_file"
}
```

## Integration Examples

### With Development Workflows
```bash
# Pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
set -e

echo "Running tests before commit..."

# Run fast tests only
cargo nextest run --profile unit --fail-fast

echo "All tests passed! Proceeding with commit."
EOF

chmod +x .git/hooks/pre-commit

# Pre-push hook
cat > .git/hooks/pre-push << 'EOF'
#!/bin/bash
set -e

echo "Running full test suite before push..."

# Run all tests with retries
cargo nextest run --retries 2 --fail-fast

echo "All tests passed! Proceeding with push."
EOF

chmod +x .git/hooks/pre-push
```

### With Docker
```bash
# Dockerfile for testing
cat > Dockerfile.test << 'EOF'
FROM rust:1.70

WORKDIR /app

# Install nextest
RUN cargo install cargo-nextest

# Copy source code
COPY . .

# Run tests
CMD ["cargo", "nextest", "run", "--profile", "ci"]
EOF

# Docker compose for testing
cat > docker-compose.test.yml << 'EOF'
version: '3.8'

services:
  test:
    build:
      context: .
      dockerfile: Dockerfile.test
    environment:
      - RUST_BACKTRACE=1
      - RUST_LOG=info
    volumes:
      - ./target:/app/target
      - ./test-results:/app/test-results
    command: >
      sh -c "
        cargo nextest run --profile ci --message-format json > test-results.json &&
        cargo nextest junit < test-results.json > test-results.xml
      "
EOF
```

### With IDEs
```bash
# VS Code settings
cat > .vscode/settings.json << 'EOF'
{
    "rust-analyzer.cargo.buildScripts.enable": true,
    "rust-analyzer.checkOnSave.command": "nextest",
    "rust-analyzer.checkOnSave.extraArgs": [
        "run",
        "--profile",
        "local",
        "--no-run"
    ]
}
EOF

# VS Code tasks
cat > .vscode/tasks.json << 'EOF'
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "nextest-run",
            "type": "shell",
            "command": "cargo",
            "args": ["nextest", "run"],
            "group": {
                "kind": "test",
                "isDefault": true
            },
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "shared"
            }
        },
        {
            "label": "nextest-run-failed",
            "type": "shell",
            "command": "cargo",
            "args": ["nextest", "run", "--failed"],
            "group": "test"
        }
    ]
}
EOF
```

## Troubleshooting

### Common Issues

**Issue**: Tests failing due to timeout
```bash
# Solution: Increase timeout
cargo nextest run --test-timeout 600s

# Solution: Use profile with longer timeout
[profile.long]
test-timeout = "10m"
slow-timeout = "5m"

# Solution: Identify slow tests
cargo nextest run --message-format json | jq '.test-finished | select(.exec_time > 30) | .name'
```

**Issue**: Flaky tests causing issues
```bash
# Solution: Enable retries
cargo nextest run --retries 3

# Solution: Create profile for flaky tests
[profile.flaky]
retries = 5
slow-timeout = "2m"
test-timeout = "5m"

# Solution: Isolate flaky tests
cargo nextest run --filter "not test(flaky_test)"
```

**Issue**: Memory issues with parallel tests
```bash
# Solution: Reduce parallelism
cargo nextest run --test-threads 2

# Solution: Use profile with limited resources
[profile.limited]
test-threads = 1
leak-timeout = "1s"
```

### Performance Tips
```bash
# Use binary caching
export NEXTEST_EXPERIMENTAL_BINARY_CACHE=1

# Optimize test discovery
cargo nextest list --message-format json > test-list.json

# Use partitioning for large test suites
cargo nextest run --partition count:1/4

# Profile-specific optimizations
[profile.fast]
test-threads = 16
slow-timeout = "5s"
retries = 0
```

## Comparison with Alternatives

### Nextest vs cargo test
```bash
# cargo test
cargo test --release --jobs 4

# nextest (better)
cargo nextest run --profile ci --test-threads 4

# Nextest advantages:
# - Better output formatting
# - Retry logic
# - Test partitioning
# - Performance improvements
# - Better CI integration
```

### Nextest vs other test runners
```bash
# Nextest advantages over other runners:
# - Native Rust integration
# - Better performance
# - Advanced filtering
# - JUnit XML output
# - Profile management
# - Partition support
```

## Resources and References

- [Cargo Nextest GitHub Repository](https://github.com/nextest-rs/nextest)
- [Nextest Documentation](https://nexte.st/)
- [Configuration Reference](https://nexte.st/book/configuration.html)
- [CI/CD Integration Guide](https://nexte.st/book/ci-integration.html)

This guide provides comprehensive coverage of cargo nextest installation, configuration, and usage patterns for efficient and reliable Rust testing workflows.