# Hexyl - Modern Hex Viewer Installation and Setup Guide

## Overview

**Hexyl** is a command-line hex viewer written in Rust that provides a colorful and user-friendly way to examine binary files. It's designed to be a modern replacement for traditional hex viewers like `xxd` and `hexdump`, offering better visual presentation and additional features.

### Key Features
- **Colorful output**: Syntax highlighting for different data types
- **ASCII representation**: Shows printable characters alongside hex values
- **Customizable display**: Adjustable column width and display options
- **Large file support**: Efficient handling of large binary files
- **Paging support**: Integrates with pagers for large files
- **Multiple output formats**: Various formatting options

### Why Use Hexyl?
- Modern and intuitive visual representation
- Better readability than traditional hex viewers
- Excellent for debugging binary files
- Great for reverse engineering and file analysis
- Fast performance with large files
- Cross-platform compatibility

## Installation

### Prerequisites
- Modern terminal with color support
- Understanding of hexadecimal notation and binary data

### Via Mise (Recommended)
```bash
# Install hexyl via mise
mise use -g hexyl

# Verify installation
hexyl --version
```

### Manual Installation
```bash
# Install via cargo
cargo install hexyl

# Or download binary release
curl -L https://github.com/sharkdp/hexyl/releases/latest/download/hexyl-v0.14.0-x86_64-unknown-linux-gnu.tar.gz | tar xz
sudo mv hexyl /usr/local/bin/

# Or via package manager (if available)
sudo apt install hexyl  # On newer Ubuntu versions
```

### Verify Installation
```bash
# Test basic functionality
echo "Hello, World!" | hexyl

# Check version
hexyl --version

# Show help
hexyl --help
```

## Configuration

### Shell Integration
```bash
# Add to ~/.bashrc or ~/.zshrc
alias hex='hexyl'
alias hx='hexyl'

# Useful functions
hex_file() {
    local file="$1"
    local length="${2:-256}"
    
    if [[ -f "$file" ]]; then
        hexyl --length "$length" "$file"
    else
        echo "File not found: $file"
        return 1
    fi
}

hex_compare() {
    local file1="$1"
    local file2="$2"
    local length="${3:-256}"
    
    echo "=== File 1: $file1 ==="
    hexyl --length "$length" "$file1"
    echo
    echo "=== File 2: $file2 ==="
    hexyl --length "$length" "$file2"
}

hex_search() {
    local file="$1"
    local pattern="$2"
    
    echo "Searching for pattern '$pattern' in $file"
    
    # Convert pattern to hex if it's ASCII
    if [[ "$pattern" =~ ^[[:print:]]+$ ]]; then
        local hex_pattern=$(echo -n "$pattern" | od -A n -t x1 | tr -d ' ')
        echo "Pattern in hex: $hex_pattern"
    fi
    
    hexyl "$file" | grep -i "$pattern"
}

# Function to analyze file structure
hex_analyze() {
    local file="$1"
    
    echo "=== File Analysis: $file ==="
    
    # Basic file info
    echo "File size: $(stat -c%s "$file") bytes"
    echo "File type: $(file -b "$file")"
    echo
    
    # Show first 256 bytes
    echo "=== First 256 bytes ==="
    hexyl --length 256 "$file"
    echo
    
    # Show magic bytes (first 16 bytes)
    echo "=== Magic bytes ==="
    hexyl --length 16 "$file"
    echo
    
    # Show last 64 bytes if file is large enough
    local file_size=$(stat -c%s "$file")
    if [[ $file_size -gt 64 ]]; then
        echo "=== Last 64 bytes ==="
        hexyl --skip $((file_size - 64)) --length 64 "$file"
    fi
}

# Function for binary diff
hex_diff() {
    local file1="$1"
    local file2="$2"
    
    echo "Binary diff between $file1 and $file2"
    
    # Simple comparison using diff on hex output
    diff <(hexyl --no-color "$file1") <(hexyl --no-color "$file2") | head -50
}
```

### Configuration File
```bash
# Create config directory
mkdir -p ~/.config/hexyl

# Create default settings
cat > ~/.config/hexyl/config.toml << 'EOF'
[display]
# Default number of columns
columns = 16

# Show ASCII representation
show_ascii = true

# Use colors by default
use_colors = true

# Default pager
pager = "less -R"

[colors]
# Color scheme for different data types
null_bytes = "bright_black"
printable_ascii = "cyan"
ascii_whitespace = "green"
other_ascii = "yellow"
non_ascii = "red"
EOF
```

## Basic Usage

### Viewing Files
```bash
# View entire file
hexyl file.bin

# View first N bytes
hexyl --length 256 file.bin

# Skip first N bytes
hexyl --skip 100 file.bin

# View specific range
hexyl --skip 100 --length 256 file.bin

# View without colors
hexyl --no-color file.bin
```

### Display Options
```bash
# Change number of columns
hexyl --columns 8 file.bin

# Hide ASCII representation
hexyl --no-ascii file.bin

# Show character display
hexyl --characters file.bin

# Display with addresses in decimal
hexyl --base decimal file.bin

# Display with addresses in octal
hexyl --base octal file.bin
```

### Input Sources
```bash
# Read from stdin
echo "Hello, World!" | hexyl

# Read from command output
ls -la | hexyl

# Read from multiple files
hexyl file1.bin file2.bin

# Read from device
hexyl --length 512 /dev/urandom
```

## Advanced Usage

### File Format Analysis
```bash
# Analyze executable files
analyze_executable() {
    local file="$1"
    
    echo "=== Executable Analysis: $file ==="
    
    # ELF header analysis
    if file "$file" | grep -q "ELF"; then
        echo "=== ELF Header ==="
        hexyl --length 64 "$file"
        echo
        
        # ELF magic bytes
        echo "ELF Magic: $(hexyl --length 4 "$file" | head -1)"
        
        # Architecture info
        echo "Architecture info (bytes 4-5):"
        hexyl --skip 4 --length 2 "$file"
        
        # Entry point (bytes 24-31 for 64-bit)
        echo "Entry point (bytes 24-31):"
        hexyl --skip 24 --length 8 "$file"
    fi
    
    # PE header analysis
    if file "$file" | grep -q "PE32"; then
        echo "=== PE Header ==="
        hexyl --length 64 "$file"
        echo
        
        # DOS header
        echo "DOS Header:"
        hexyl --length 16 "$file"
    fi
}

# Analyze image files
analyze_image() {
    local file="$1"
    
    echo "=== Image Analysis: $file ==="
    
    # JPEG analysis
    if file "$file" | grep -q "JPEG"; then
        echo "=== JPEG Header ==="
        hexyl --length 32 "$file"
        echo
        
        # JPEG magic bytes
        echo "JPEG Magic: $(hexyl --length 2 "$file" | head -1)"
        
        # Look for EXIF data
        echo "Searching for EXIF data..."
        hexyl --length 1024 "$file" | grep -i "exif"
    fi
    
    # PNG analysis
    if file "$file" | grep -q "PNG"; then
        echo "=== PNG Header ==="
        hexyl --length 32 "$file"
        echo
        
        # PNG signature
        echo "PNG Signature: $(hexyl --length 8 "$file" | head -1)"
        
        # IHDR chunk
        echo "IHDR Chunk:"
        hexyl --skip 8 --length 25 "$file"
    fi
    
    # GIF analysis
    if file "$file" | grep -q "GIF"; then
        echo "=== GIF Header ==="
        hexyl --length 32 "$file"
        echo
        
        # GIF signature and version
        echo "GIF Signature: $(hexyl --length 6 "$file" | head -1)"
    fi
}

# Analyze archive files
analyze_archive() {
    local file="$1"
    
    echo "=== Archive Analysis: $file ==="
    
    # ZIP analysis
    if file "$file" | grep -q "Zip"; then
        echo "=== ZIP Header ==="
        hexyl --length 32 "$file"
        echo
        
        # ZIP signature
        echo "ZIP Signature: $(hexyl --length 4 "$file" | head -1)"
        
        # Local file header
        echo "Local File Header:"
        hexyl --length 30 "$file"
    fi
    
    # TAR analysis
    if file "$file" | grep -q "tar"; then
        echo "=== TAR Header ==="
        hexyl --length 512 "$file"
        echo
        
        # TAR header structure
        echo "Filename (first 100 bytes):"
        hexyl --length 100 "$file"
    fi
}
```

### Binary Data Analysis
```bash
# Find patterns in binary data
find_patterns() {
    local file="$1"
    local pattern="$2"
    
    echo "Finding pattern '$pattern' in $file"
    
    # Convert ASCII pattern to hex
    if [[ "$pattern" =~ ^[[:print:]]+$ ]]; then
        local hex_pattern=$(echo -n "$pattern" | od -A n -t x1 | tr -d ' ')
        echo "Hex pattern: $hex_pattern"
        
        # Search for pattern in hex output
        hexyl "$file" | grep -n "$hex_pattern"
    else
        # Search for hex pattern directly
        hexyl "$file" | grep -n "$pattern"
    fi
}

# Extract strings from binary
extract_strings() {
    local file="$1"
    local min_length="${2:-4}"
    
    echo "Extracting strings from $file (min length: $min_length)"
    
    # Use strings command with hexyl for context
    strings -n "$min_length" "$file" | while read -r str; do
        echo "String: $str"
        
        # Find string in hex output
        local hex_pattern=$(echo -n "$str" | od -A n -t x1 | tr -d ' ')
        local offset=$(hexyl --no-color "$file" | grep -n "$hex_pattern" | head -1 | cut -d: -f1)
        
        if [[ -n "$offset" ]]; then
            echo "Found at line $offset in hex output"
        fi
        echo
    done
}

# Analyze entropy (randomness)
analyze_entropy() {
    local file="$1"
    local block_size="${2:-256}"
    
    echo "Analyzing entropy of $file (block size: $block_size bytes)"
    
    # Simple entropy analysis using frequency count
    local file_size=$(stat -c%s "$file")
    local blocks=$((file_size / block_size))
    
    echo "File size: $file_size bytes"
    echo "Blocks: $blocks"
    echo
    
    for ((i=0; i<blocks && i<10; i++)); do
        local offset=$((i * block_size))
        echo "Block $i (offset $offset):"
        
        # Show hex dump of block
        hexyl --skip "$offset" --length "$block_size" "$file" | head -8
        
        # Calculate byte frequency
        local freq=$(hexyl --no-color --skip "$offset" --length "$block_size" "$file" | \
                    grep -oE '[0-9a-f][0-9a-f]' | sort | uniq -c | sort -nr | head -5)
        
        echo "Top 5 byte frequencies:"
        echo "$freq"
        echo
    done
}
```

### Debugging and Reverse Engineering
```bash
# Debug binary protocols
debug_protocol() {
    local file="$1"
    local protocol="$2"
    
    echo "Debugging $protocol protocol in $file"
    
    case "$protocol" in
        "http")
            echo "=== HTTP Headers ==="
            hexyl --length 512 "$file" | grep -A 10 -B 10 "485454502f"  # "HTTP/"
            ;;
        "tcp")
            echo "=== TCP Header ==="
            hexyl --length 20 "$file"
            echo
            echo "Source Port (bytes 0-1):"
            hexyl --length 2 "$file"
            echo "Destination Port (bytes 2-3):"
            hexyl --skip 2 --length 2 "$file"
            ;;
        "ip")
            echo "=== IP Header ==="
            hexyl --length 20 "$file"
            echo
            echo "Version and IHL (byte 0):"
            hexyl --length 1 "$file"
            echo "Protocol (byte 9):"
            hexyl --skip 9 --length 1 "$file"
            ;;
        *)
            echo "Supported protocols: http, tcp, ip"
            return 1
            ;;
    esac
}

# Analyze malware samples (safely)
analyze_malware() {
    local file="$1"
    
    echo "=== MALWARE ANALYSIS (READ-ONLY) ==="
    echo "File: $file"
    echo "WARNING: This is for analysis only, do not execute!"
    echo
    
    # Basic file info
    echo "File size: $(stat -c%s "$file") bytes"
    echo "File type: $(file -b "$file")"
    echo "MD5: $(md5sum "$file" | cut -d' ' -f1)"
    echo "SHA256: $(sha256sum "$file" | cut -d' ' -f1)"
    echo
    
    # Look for common malware signatures
    echo "=== Common Signatures ==="
    
    # PE header analysis
    if file "$file" | grep -q "PE32"; then
        echo "PE executable detected"
        hexyl --length 64 "$file"
        echo
        
        # Look for packed executables
        echo "Checking for common packers..."
        hexyl --length 2048 "$file" | grep -i "upx\|vmprotect\|themida\|aspack"
    fi
    
    # String analysis
    echo "=== Suspicious Strings ==="
    strings "$file" | grep -i "http\|ftp\|smtp\|tcp\|socket\|connect\|download\|upload" | head -20
    echo
    
    # Entropy analysis
    echo "=== High Entropy Sections (possible encryption/packing) ==="
    analyze_entropy "$file" 1024
}

# Memory dump analysis
analyze_memory_dump() {
    local file="$1"
    
    echo "=== Memory Dump Analysis: $file ==="
    
    # Look for common memory structures
    echo "=== Process Headers ==="
    hexyl --length 256 "$file" | grep -A 5 -B 5 "4d5a"  # MZ header
    
    echo "=== Stack Frames ==="
    # Look for stack frame patterns
    hexyl --length 1024 "$file" | grep -A 3 -B 3 "deadbeef\|cafebabe\|feedface"
    
    echo "=== Heap Metadata ==="
    # Look for heap management structures
    hexyl --length 512 "$file" | grep -A 5 -B 5 "00000000\|ffffffff"
}
```

### Data Recovery and Forensics
```bash
# Recover deleted files
recover_file_signatures() {
    local device="$1"
    local output_dir="$2"
    
    echo "Scanning $device for file signatures..."
    mkdir -p "$output_dir"
    
    # Common file signatures
    declare -A signatures=(
        ["jpg"]="ffd8ff"
        ["png"]="89504e47"
        ["gif"]="47494638"
        ["zip"]="504b0304"
        ["pdf"]="25504446"
        ["exe"]="4d5a"
        ["elf"]="7f454c46"
    )
    
    for ext in "${!signatures[@]}"; do
        local sig="${signatures[$ext]}"
        echo "Searching for $ext files (signature: $sig)..."
        
        # Search for signature in hex output
        hexyl --length 1048576 "$device" | grep -n "$sig" | head -5 | while read -r line; do
            local offset=$(echo "$line" | cut -d: -f1)
            echo "Found $ext signature at offset $offset"
            
            # Extract potential file
            local output_file="$output_dir/recovered_${ext}_${offset}.${ext}"
            hexyl --skip "$offset" --length 65536 "$device" > "$output_file"
            echo "Extracted to: $output_file"
        done
    done
}

# Analyze disk structures
analyze_disk() {
    local device="$1"
    
    echo "=== Disk Analysis: $device ==="
    
    # MBR analysis
    echo "=== Master Boot Record ==="
    hexyl --length 512 "$device"
    echo
    
    # Boot signature
    echo "Boot signature (bytes 510-511):"
    hexyl --skip 510 --length 2 "$device"
    echo
    
    # Partition table
    echo "Partition table (bytes 446-509):"
    hexyl --skip 446 --length 64 "$device"
    echo
    
    # Look for filesystem signatures
    echo "=== Filesystem Signatures ==="
    
    # FAT32 signature
    echo "Checking for FAT32 (offset 82):"
    hexyl --skip 82 --length 8 "$device"
    
    # NTFS signature
    echo "Checking for NTFS (offset 3):"
    hexyl --skip 3 --length 8 "$device"
    
    # ext4 signature
    echo "Checking for ext4 (offset 1080):"
    hexyl --skip 1080 --length 4 "$device"
}
```

### Integration with Other Tools
```bash
# Integration with objdump
objdump_hex() {
    local file="$1"
    local section="$2"
    
    echo "Combining objdump and hexyl for $file"
    
    # Get section info from objdump
    local section_info=$(objdump -h "$file" | grep "$section")
    
    if [[ -n "$section_info" ]]; then
        echo "Section info: $section_info"
        
        # Extract offset and size
        local offset=$(echo "$section_info" | awk '{print $6}')
        local size=$(echo "$section_info" | awk '{print $3}')
        
        echo "Hex dump of $section section:"
        hexyl --skip "0x$offset" --length "0x$size" "$file"
    else
        echo "Section $section not found"
    fi
}

# Integration with readelf
readelf_hex() {
    local file="$1"
    
    echo "Combining readelf and hexyl for $file"
    
    # Get ELF header info
    echo "=== ELF Header Info ==="
    readelf -h "$file"
    echo
    
    # Show hex dump of ELF header
    echo "=== ELF Header Hex Dump ==="
    hexyl --length 64 "$file"
    echo
    
    # Show program headers
    echo "=== Program Headers ==="
    readelf -l "$file"
    echo
    
    # Show section headers
    echo "=== Section Headers ==="
    readelf -S "$file"
}

# Integration with gdb
gdb_hex() {
    local binary="$1"
    local address="$2"
    local length="${3:-256}"
    
    echo "Examining memory at $address with gdb and hexyl"
    
    # Create GDB script
    cat > /tmp/gdb_script << EOF
set confirm off
file $binary
run
x/${length}bx $address
quit
EOF
    
    # Run GDB and capture output
    gdb -x /tmp/gdb_script "$binary" 2>/dev/null | \
    grep "^0x" | \
    while read -r line; do
        echo "$line"
    done
    
    rm -f /tmp/gdb_script
}
```

## Integration Examples

### With Development Workflows
```bash
# Debug compiled programs
debug_compilation() {
    local source="$1"
    local binary="$2"
    
    echo "Debugging compilation of $source -> $binary"
    
    # Compile with debug info
    gcc -g -o "$binary" "$source"
    
    # Analyze binary structure
    echo "=== Binary Structure ==="
    hexyl --length 256 "$binary"
    
    # Show symbol table
    echo "=== Symbol Table ==="
    readelf -s "$binary" | head -20
    
    # Show string constants
    echo "=== String Constants ==="
    strings "$binary" | head -10
}

# Analyze library dependencies
analyze_dependencies() {
    local binary="$1"
    
    echo "Analyzing dependencies of $binary"
    
    # Show dynamic section
    echo "=== Dynamic Section ==="
    readelf -d "$binary"
    
    # Show hex dump of dynamic section
    local dyn_offset=$(readelf -S "$binary" | grep "\.dynamic" | awk '{print $5}')
    if [[ -n "$dyn_offset" ]]; then
        echo "Dynamic section hex dump:"
        hexyl --skip "0x$dyn_offset" --length 256 "$binary"
    fi
}
```

### With System Administration
```bash
# Analyze system files
analyze_system_files() {
    local file="$1"
    
    echo "Analyzing system file: $file"
    
    case "$file" in
        "/proc/cpuinfo")
            echo "CPU info (first 512 bytes):"
            hexyl --length 512 "$file"
            ;;
        "/proc/meminfo")
            echo "Memory info (first 256 bytes):"
            hexyl --length 256 "$file"
            ;;
        "/dev/urandom")
            echo "Random data sample:"
            hexyl --length 64 "$file"
            ;;
        *)
            echo "Generic system file analysis:"
            hexyl --length 256 "$file"
            ;;
    esac
}

# Monitor log files
monitor_log_changes() {
    local log_file="$1"
    
    echo "Monitoring changes in $log_file"
    
    # Get initial size
    local initial_size=$(stat -c%s "$log_file")
    
    # Monitor for changes
    while true; do
        local current_size=$(stat -c%s "$log_file")
        
        if [[ $current_size -gt $initial_size ]]; then
            echo "Log file changed, showing new content:"
            local new_bytes=$((current_size - initial_size))
            hexyl --skip "$initial_size" --length "$new_bytes" "$log_file"
            initial_size=$current_size
        fi
        
        sleep 1
    done
}
```

### With Security Analysis
```bash
# Analyze network packets
analyze_packet() {
    local packet_file="$1"
    
    echo "Analyzing network packet: $packet_file"
    
    # Ethernet header
    echo "=== Ethernet Header ==="
    hexyl --length 14 "$packet_file"
    
    # IP header
    echo "=== IP Header ==="
    hexyl --skip 14 --length 20 "$packet_file"
    
    # TCP/UDP header
    echo "=== Transport Header ==="
    hexyl --skip 34 --length 20 "$packet_file"
    
    # Payload
    echo "=== Payload ==="
    hexyl --skip 54 --length 256 "$packet_file"
}

# Analyze cryptographic data
analyze_crypto() {
    local file="$1"
    local type="$2"
    
    echo "Analyzing cryptographic data in $file"
    
    case "$type" in
        "key")
            echo "=== Cryptographic Key Analysis ==="
            hexyl --length 64 "$file"
            
            # Check for common key formats
            if hexyl --no-color "$file" | grep -q "3082"; then
                echo "Possible PKCS#8 private key"
            elif hexyl --no-color "$file" | grep -q "3081"; then
                echo "Possible RSA private key"
            fi
            ;;
        "cert")
            echo "=== Certificate Analysis ==="
            hexyl --length 128 "$file"
            
            # Check for PEM format
            if hexyl --no-color "$file" | grep -q "2d2d2d2d2d"; then
                echo "Possible PEM format certificate"
            fi
            ;;
        *)
            echo "Generic cryptographic analysis:"
            hexyl --length 256 "$file"
            ;;
    esac
}
```

## Troubleshooting

### Common Issues

**Issue**: Colors not displaying properly
```bash
# Solution: Check terminal color support
echo $TERM
export TERM=xterm-256color

# Solution: Force color output
hexyl --color always file.bin

# Solution: Disable colors if needed
hexyl --no-color file.bin
```

**Issue**: Large files taking too long
```bash
# Solution: Use length limit
hexyl --length 1024 large_file.bin

# Solution: Use pager
hexyl large_file.bin | less

# Solution: Skip to specific offset
hexyl --skip 1000000 --length 1024 large_file.bin
```

**Issue**: Binary data not displaying correctly
```bash
# Solution: Check file encoding
file -b file.bin

# Solution: Use different column width
hexyl --columns 32 file.bin

# Solution: Show characters instead of ASCII
hexyl --characters file.bin
```

### Performance Tips
```bash
# Limit output for large files
hexyl --length 4096 large_file.bin

# Use appropriate column width
hexyl --columns 16 file.bin  # Standard width

# Skip unnecessary sections
hexyl --skip 1000 --length 256 file.bin

# Use pager for large outputs
hexyl file.bin | less -R
```

## Comparison with Alternatives

### Hexyl vs xxd
```bash
# xxd (traditional)
xxd -l 256 file.bin

# hexyl (modern)
hexyl --length 256 file.bin

# Hexyl advantages:
# - Colorful output
# - Better readability
# - More intuitive options
# - Better performance
```

### Hexyl vs hexdump
```bash
# hexdump (traditional)
hexdump -C file.bin | head -16

# hexyl (modern)
hexyl --length 256 file.bin

# Hexyl advantages:
# - Colored output
# - Built-in paging
# - Better ASCII representation
# - More user-friendly
```

## Resources and References

- [Hexyl GitHub Repository](https://github.com/sharkdp/hexyl)
- [Hexyl Documentation](https://github.com/sharkdp/hexyl/blob/master/README.md)
- [Binary File Analysis Guide](https://en.wikipedia.org/wiki/Hex_editor)
- [File Format Specifications](https://www.fileformat.info/)

This guide provides comprehensive coverage of hexyl installation, configuration, and usage patterns for effective binary file analysis and debugging.