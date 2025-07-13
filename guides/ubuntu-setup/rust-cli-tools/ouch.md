# Ouch - Universal Archive Tool

Ouch is a painless compression and decompression tool for various archive formats.

## Installation

```bash
cargo install ouch
```

## Basic Setup

### Shell Aliases

```bash
# Add convenient aliases
echo 'alias extract="ouch decompress"' >> ~/.bashrc
echo 'alias compress="ouch compress"' >> ~/.bashrc
```

### Helper Functions

```bash
# Example usage functions
cat >> ~/.bashrc << 'EOF'
# Quick archive extraction
function unpack() {
    if [ -f "$1" ]; then
        ouch decompress "$1"
    else
        echo "File not found: $1"
    fi
}

# Quick archive creation
function pack() {
    if [ -z "$2" ]; then
        echo "Usage: pack <source> <archive_name>"
    else
        ouch compress "$1" "$2"
    fi
}
EOF
```

## Usage Examples

```bash
# Extract archives
ouch decompress archive.tar.gz
ouch decompress archive.zip
ouch decompress archive.7z

# Create archives
ouch compress file.txt file.tar.gz
ouch compress folder/ folder.zip
ouch compress multiple/ files/ archive.tar.xz

# List archive contents
ouch list archive.tar.gz
ouch list archive.zip

# Extract to specific directory
ouch decompress archive.tar.gz --dir /path/to/extract

# Create archive with compression level
ouch compress file.txt file.tar.gz --level 9

# Verbose output
ouch decompress archive.tar.gz --verbose
ouch compress file.txt file.tar.gz --verbose

# Yes to all prompts
ouch decompress archive.tar.gz --yes
```

## Supported Formats

### Compression Formats
- **tar** - Tar archives
- **zip** - ZIP archives
- **7z** - 7-Zip archives
- **rar** - RAR archives (extract only)
- **gz** - Gzip compression
- **bz2** - Bzip2 compression
- **xz** - XZ compression
- **lz4** - LZ4 compression
- **zst** - Zstandard compression

### Archive Formats
- **tar.gz** / **tgz** - Gzipped tar
- **tar.bz2** / **tbz2** - Bzip2 tar
- **tar.xz** / **txz** - XZ tar
- **tar.lz4** - LZ4 tar
- **tar.zst** - Zstandard tar

## Key Features

- Automatic format detection
- Support for multiple compression formats
- Parallel compression/decompression
- Progress indicators
- Consistent command interface
- Safe extraction (prevents zip bombs)

## Command Options

### Compression Options
- `--level N` - Compression level (1-9)
- `--format FORMAT` - Force specific format
- `--overwrite` - Overwrite existing files
- `--verbose` - Verbose output
- `--quiet` - Suppress output

### Extraction Options
- `--dir PATH` - Extract to specific directory
- `--yes` - Answer yes to all prompts
- `--accessible` - Make extracted files accessible
- `--overwrite` - Overwrite existing files

## Common Use Cases

### Basic Operations
```bash
# Extract any archive
ouch decompress archive.*

# Create a backup
ouch compress ~/Documents/ backup.tar.gz

# Extract with progress
ouch decompress large-archive.tar.gz --verbose
```

### Advanced Operations
```bash
# High compression
ouch compress folder/ folder.tar.xz --level 9

# Extract to custom location
ouch decompress archive.tar.gz --dir ~/extracted/

# List contents before extracting
ouch list archive.zip
```

### Batch Operations
```bash
# Extract multiple archives
for archive in *.tar.gz; do
    ouch decompress "$archive"
done

# Create archives from multiple directories
for dir in */; do
    ouch compress "$dir" "${dir%/}.tar.gz"
done
```

## Format Selection

Ouch automatically detects formats based on file extensions:
- `.tar.gz` → gzipped tar
- `.zip` → ZIP archive
- `.7z` → 7-Zip archive
- `.tar.bz2` → bzip2 tar
- `.tar.xz` → XZ tar

## Performance Tips

- Use appropriate compression levels
- For backups, use `.tar.gz` or `.tar.xz`
- For maximum compression, use `.7z` or `.tar.xz`
- For speed, use `.tar.lz4` or `.zip`

## Security Features

- Prevents zip bombs
- Safe extraction paths
- Validates archive integrity
- Prevents directory traversal attacks

## Error Handling

```bash
# Check if operation succeeded
if ouch decompress archive.tar.gz; then
    echo "Extraction successful"
else
    echo "Extraction failed"
fi
```

## Integration with Other Tools

### With Find
```bash
# Extract all archives in directory
find . -name "*.tar.gz" -exec ouch decompress {} \;
```

### With Parallel
```bash
# Parallel extraction
ls *.tar.gz | parallel ouch decompress {}
```

### With Scripts
```bash
#!/bin/bash
# Backup script
DATE=$(date +%Y%m%d)
ouch compress ~/Documents/ "backup_${DATE}.tar.gz"
```

## Troubleshooting

- **Format not supported**: Check supported formats list
- **Permission denied**: Verify file permissions
- **Extraction failed**: Check archive integrity
- **Path too long**: Use shorter paths or extract to root

## Comparison with Traditional Tools

### Advantages over tar/zip
- Single command for all formats
- Automatic format detection
- Consistent interface
- Better error messages
- Progress indicators

### Traditional equivalents
```bash
# tar
tar -xzf archive.tar.gz  # → ouch decompress archive.tar.gz
tar -czf archive.tar.gz folder/  # → ouch compress folder/ archive.tar.gz

# unzip
unzip archive.zip  # → ouch decompress archive.zip
zip -r archive.zip folder/  # → ouch compress folder/ archive.zip
```

## Configuration

Ouch doesn't use configuration files, but you can set environment variables:
- `OUCH_BINARY` - Path to ouch binary
- `OUCH_DEFAULT_FORMAT` - Default compression format

## Use Cases

### System Administration
- Log file compression
- Backup creation
- Archive management
- Software distribution

### Development
- Build artifact compression
- Source code archiving
- Release preparation
- Dependency packaging

### Personal Use
- File organization
- Space saving
- File sharing
- Backup creation

## Alternative Installation

```bash
# Via package manager (if available)
sudo apt install ouch

# Via GitHub releases
wget https://github.com/ouch-org/ouch/releases/latest/download/ouch-x86_64-unknown-linux-gnu.tar.gz
tar -xzf ouch-*.tar.gz
sudo cp ouch /usr/local/bin/
```

## Best Practices

1. Always verify archive integrity
2. Use appropriate compression levels
3. Test extraction in safe environments
4. Keep backups of important data
5. Use descriptive archive names
6. Document compression settings for reproducibility