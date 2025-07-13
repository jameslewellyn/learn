# SD - Modern sed Alternative

SD is an intuitive find & replace CLI tool for text replacement.

## Installation

```bash
cargo install sd
```

## Basic Setup

### Shell Aliases

```bash
# Add alias (optional, as sd is short enough)
echo 'alias sed="sd"' >> ~/.bashrc
```

### Usage Examples

```bash
# Example usage patterns (add to ~/.bashrc for quick reference)
cat >> ~/.bashrc << 'EOF'
# SD usage examples (commented out)
# sd 'old_text' 'new_text' file.txt              # Replace in file
# sd 'old_text' 'new_text' $(find . -name "*.txt")  # Replace in multiple files
# echo 'hello world' | sd 'world' 'universe'     # Pipe usage
EOF
```

## Usage Examples

```bash
# Basic replacement in file
sd 'old_text' 'new_text' file.txt

# Replace in multiple files
sd 'old_text' 'new_text' **/*.txt

# Replace with regex
sd '\d{4}-\d{2}-\d{2}' 'DATE' file.txt

# Replace from stdin
echo 'hello world' | sd 'world' 'universe'

# Preview changes (dry run)
sd 'old_text' 'new_text' file.txt --preview

# Replace in place
sd 'old_text' 'new_text' file.txt

# Replace with capture groups
sd '(\w+) (\w+)' '$2 $1' file.txt

# Case insensitive replacement
sd -i 'old_text' 'new_text' file.txt

# Replace only first occurrence
sd -l 1 'old_text' 'new_text' file.txt

# Replace with flags
sd -f i 'old_text' 'new_text' file.txt  # case insensitive
sd -f m 'old_text' 'new_text' file.txt  # multiline
sd -f s 'old_text' 'new_text' file.txt  # dot matches newline
```

## Key Features

- Fast and intuitive
- Regex support
- Unicode support
- Preview mode
- Multiline support
- Capture groups
- Case insensitive search
- Limit replacements

## Common Use Cases

### Text Processing

```bash
# Remove extra whitespace
sd '\s+' ' ' file.txt

# Convert tabs to spaces
sd '\t' '    ' file.txt

# Remove empty lines
sd '\n\s*\n' '\n' file.txt

# Convert Windows line endings
sd '\r\n' '\n' file.txt
```

### Code Refactoring

```bash
# Rename function calls
sd 'old_function\(' 'new_function(' **/*.rs

# Update import statements
sd 'use old_module::' 'use new_module::' **/*.rs

# Update variable names
sd '\bold_var\b' 'new_var' **/*.rs
```

### Configuration Updates

```bash
# Update config values
sd 'debug = false' 'debug = true' config.toml

# Update URLs
sd 'http://old-domain.com' 'https://new-domain.com' **/*.md

# Update version numbers
sd 'version = "1.0.0"' 'version = "1.1.0"' Cargo.toml
```

## Regex Features

SD supports Rust's regex syntax:
- `\d` - Digit
- `\w` - Word character
- `\s` - Whitespace
- `\b` - Word boundary
- `^` - Start of line
- `$` - End of line
- `.*` - Any character (greedy)
- `.*?` - Any character (non-greedy)
- `[abc]` - Character class
- `(...)` - Capture group
- `(?:...)` - Non-capturing group

## Flags

- `i` - Case insensitive
- `m` - Multiline (^ and $ match line boundaries)
- `s` - Dot matches newline
- `x` - Ignore whitespace and comments

## Troubleshooting

- **Regex not matching**: Verify regex syntax
- **Permission errors**: Check file permissions
- **Unexpected results**: Use `--preview` first
- **Special characters**: Escape with backslash

## Alternative Installation

```bash
# Via package manager (if available)
sudo apt install sd
```

## Comparison with sed

SD advantages:
- More intuitive syntax
- Better regex support
- Unicode support
- Preview mode
- Cleaner error messages

Traditional sed equivalents:
```bash
# sed style
sed 's/old/new/g' file.txt

# SD style
sd 'old' 'new' file.txt
```