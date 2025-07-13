# Age - Modern Encryption Tool Installation and Setup Guide

A simple, modern, and secure encryption tool for files and streams.

## What is Age?

**Age** (Actually Good Encryption) is a modern encryption tool that provides simple, secure file and stream encryption. It's designed to be a replacement for GPG with a focus on simplicity, security, and ease of use. Age uses modern cryptographic primitives and has a clean, minimal interface.

## Key Features

- **Modern cryptography**: Uses ChaCha20-Poly1305 and X25519
- **Simple interface**: Easy to use command-line interface
- **Multiple recipient types**: Support for X25519 keys, SSH keys, and passphrases
- **Streaming**: Can encrypt/decrypt streams without loading entire files
- **Cross-platform**: Available on Linux, macOS, and Windows
- **No configuration files**: No complex configuration needed
- **Small and fast**: Minimal dependencies and fast performance

## Installation

### Method 1: Official Binary Download (Recommended)
```bash
# Download latest release
curl -LO "https://github.com/FiloSottile/age/releases/latest/download/age-v1.1.1-linux-amd64.tar.gz"
tar -xzf age-v1.1.1-linux-amd64.tar.gz
sudo mv age/age age/age-keygen /usr/local/bin/
rm -rf age age-v1.1.1-linux-amd64.tar.gz
```

### Method 2: Go Installation
```bash
go install filippo.io/age/cmd/...@latest
```

### Method 3: Package Manager (if available)
```bash
# Some distributions may have age in their repositories
sudo apt install age  # May not be available in all versions
```

### Method 4: Build from Source
```bash
git clone https://github.com/FiloSottile/age.git
cd age
go build -o age ./cmd/age
go build -o age-keygen ./cmd/age-keygen
sudo mv age age-keygen /usr/local/bin/
```

## Basic Usage

### Generate Keys
```bash
# Generate a new key pair
age-keygen -o key.txt

# Generate key to stdout
age-keygen

# The output shows both public and private keys:
# AGE-SECRET-KEY-1... (private key)
# age1... (public key)
```

### Basic Encryption and Decryption

#### Encrypt with Public Key
```bash
# Encrypt a file
age -r age1ql3z0hjy54pw02xpwpw7rz9pkm7dvq3h8kskj5esf0u0v6yh6mfp7x... file.txt > file.txt.age

# Encrypt from stdin
echo "Hello, World!" | age -r age1ql3z0hjy54pw02xpwpw7rz9pkm7dvq3h8kskj5esf0u0v6yh6mfp7x... > message.age

# Encrypt with multiple recipients
age -r age1ql3z0hjy54pw02xpwpw7rz9pkm7dvq3h8kskj5esf0u0v6yh6mfp7x... -r age1another... file.txt > file.txt.age
```

#### Decrypt with Private Key
```bash
# Decrypt a file
age -d -i key.txt file.txt.age > file.txt

# Decrypt to stdout
age -d -i key.txt file.txt.age

# Decrypt from stdin
cat file.txt.age | age -d -i key.txt
```

### Passphrase Encryption
```bash
# Encrypt with passphrase
age -p file.txt > file.txt.age

# Decrypt with passphrase
age -d file.txt.age > file.txt
```

## Advanced Usage

### SSH Key Support
```bash
# Encrypt to SSH public key
age -R ~/.ssh/id_rsa.pub file.txt > file.txt.age

# Decrypt with SSH private key
age -d -i ~/.ssh/id_rsa file.txt.age > file.txt

# Convert SSH key to age format
ssh-keygen -Y sign -f ~/.ssh/id_rsa -n file <<< "test" | age-keygen -y
```

### Recipients File
```bash
# Create recipients file
cat > recipients.txt << EOF
age1ql3z0hjy54pw02xpwpw7rz9pkm7dvq3h8kskj5esf0u0v6yh6mfp7x...
age1another...
EOF

# Encrypt using recipients file
age -R recipients.txt file.txt > file.txt.age
```

### Key Management

#### Generate Multiple Keys
```bash
# Generate different keys for different purposes
age-keygen -o personal.key
age-keygen -o work.key
age-keygen -o backup.key

# Extract public keys
grep "age1" personal.key
grep "age1" work.key
grep "age1" backup.key
```

#### Key Derivation
```bash
# Age doesn't directly support key derivation, but you can use:
# - Different passphrases for different contexts
# - Multiple key files
# - SSH keys with different purposes
```

## Practical Use Cases

### File Backup Encryption
```bash
#!/bin/bash
# backup-encrypt.sh
BACKUP_DIR="/home/user/backups"
RECIPIENTS_FILE="/home/user/.age/recipients.txt"

# Create encrypted backup
tar -czf - /home/user/documents | age -R "$RECIPIENTS_FILE" > "$BACKUP_DIR/documents-$(date +%Y%m%d).tar.gz.age"

# Decrypt backup
# age -d -i ~/.age/key.txt "$BACKUP_DIR/documents-20231215.tar.gz.age" | tar -xzf -
```

### Secret Management
```bash
#!/bin/bash
# secret-manager.sh
SECRET_DIR="$HOME/.secrets"
KEY_FILE="$HOME/.age/key.txt"

# Store secret
store_secret() {
    local name="$1"
    local value="$2"
    echo "$value" | age -r "$(get_public_key)" > "$SECRET_DIR/$name.age"
}

# Retrieve secret
get_secret() {
    local name="$1"
    age -d -i "$KEY_FILE" "$SECRET_DIR/$name.age"
}

# Get public key from private key
get_public_key() {
    age-keygen -y "$KEY_FILE"
}

# Usage
# store_secret "database_password" "super_secret_password"
# get_secret "database_password"
```

### Git Repository Encryption
```bash
#!/bin/bash
# git-encrypt.sh
# Encrypt sensitive files before committing

RECIPIENTS_FILE=".age/recipients.txt"

# Encrypt all files in secrets directory
find secrets/ -type f -name "*.txt" | while read -r file; do
    age -R "$RECIPIENTS_FILE" "$file" > "$file.age"
    rm "$file"
done

# Decrypt files
find secrets/ -type f -name "*.age" | while read -r file; do
    age -d -i ~/.age/key.txt "$file" > "${file%.age}"
    rm "$file"
done
```

### Database Backup Encryption
```bash
#!/bin/bash
# db-backup-encrypt.sh
DB_NAME="myapp"
BACKUP_DIR="/var/backups"
AGE_KEY="/root/.age/backup.key"

# Create encrypted database backup
mysqldump "$DB_NAME" | age -r "$(age-keygen -y "$AGE_KEY")" > "$BACKUP_DIR/$DB_NAME-$(date +%Y%m%d_%H%M%S).sql.age"

# Restore from encrypted backup
# age -d -i "$AGE_KEY" "$BACKUP_DIR/$DB_NAME-20231215_120000.sql.age" | mysql "$DB_NAME"
```

## Integration with Other Tools

### Tar Archives
```bash
# Encrypt tar archive
tar -czf - directory/ | age -r age1ql3z0hjy54pw02xpwpw7rz9pkm7dvq3h8kskj5esf0u0v6yh6mfp7x... > archive.tar.gz.age

# Decrypt tar archive
age -d -i key.txt archive.tar.gz.age | tar -xzf -
```

### Rsync with Age
```bash
#!/bin/bash
# rsync-age.sh
# Sync files and encrypt them

SOURCE_DIR="/home/user/documents"
DEST_DIR="/remote/backup"
AGE_KEY="/home/user/.age/backup.key"

# Sync and encrypt
rsync -av --delete "$SOURCE_DIR/" "$DEST_DIR/" --exclude="*.age"
find "$DEST_DIR" -type f ! -name "*.age" | while read -r file; do
    age -r "$(age-keygen -y "$AGE_KEY")" "$file" > "$file.age"
    rm "$file"
done
```

### Docker Secrets
```bash
#!/bin/bash
# docker-secrets.sh
# Manage Docker secrets with age

SECRETS_DIR="/var/lib/docker/secrets"
AGE_KEY="/root/.age/docker.key"

# Store Docker secret
store_docker_secret() {
    local secret_name="$1"
    local secret_value="$2"
    echo "$secret_value" | age -r "$(age-keygen -y "$AGE_KEY")" > "$SECRETS_DIR/$secret_name.age"
}

# Retrieve Docker secret
get_docker_secret() {
    local secret_name="$1"
    age -d -i "$AGE_KEY" "$SECRETS_DIR/$secret_name.age"
}
```

## Security Best Practices

### Key Management
```bash
# Store keys securely
mkdir -p ~/.age
chmod 700 ~/.age

# Generate key with proper permissions
age-keygen -o ~/.age/key.txt
chmod 600 ~/.age/key.txt

# Backup keys securely
age -p ~/.age/key.txt > ~/.age/key.txt.backup.age
```

### Multi-User Scenarios
```bash
# Create shared recipients file
cat > /etc/age/recipients.txt << EOF
# Admin keys
age1ql3z0hjy54pw02xpwpw7rz9pkm7dvq3h8kskj5esf0u0v6yh6mfp7x...  # admin1
age1another...  # admin2

# Backup keys
age1backup...  # backup system
EOF

# Set proper permissions
chmod 644 /etc/age/recipients.txt
```

### Automated Encryption
```bash
#!/bin/bash
# secure-backup.sh
set -euo pipefail

BACKUP_SOURCE="/home/user/documents"
BACKUP_DEST="/backup/encrypted"
RECIPIENTS_FILE="/etc/age/recipients.txt"
LOG_FILE="/var/log/backup.log"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Verify recipients file exists
if [[ ! -f "$RECIPIENTS_FILE" ]]; then
    log "ERROR: Recipients file not found: $RECIPIENTS_FILE"
    exit 1
fi

# Create encrypted backup
log "Starting backup encryption..."
tar -czf - "$BACKUP_SOURCE" | age -R "$RECIPIENTS_FILE" > "$BACKUP_DEST/backup-$(date +%Y%m%d_%H%M%S).tar.gz.age"
log "Backup completed successfully"

# Verify backup can be decrypted (test with first recipient)
if age -d -i ~/.age/key.txt "$BACKUP_DEST/backup-$(date +%Y%m%d_%H%M%S).tar.gz.age" | tar -tzf - > /dev/null; then
    log "Backup verification successful"
else
    log "ERROR: Backup verification failed"
    exit 1
fi
```

## Performance Considerations

### Large Files
```bash
# Age streams data, so it's efficient with large files
age -r age1ql3z0hjy54pw02xpwpw7rz9pkm7dvq3h8kskj5esf0u0v6yh6mfp7x... largefile.img > largefile.img.age

# For very large files, consider compression first
gzip -c largefile.img | age -r age1ql3z0hjy54pw02xpwpw7rz9pkm7dvq3h8kskj5esf0u0v6yh6mfp7x... > largefile.img.gz.age
```

### Batch Operations
```bash
#!/bin/bash
# batch-encrypt.sh
# Encrypt multiple files efficiently

RECIPIENTS_FILE="recipients.txt"
SOURCE_DIR="documents"
DEST_DIR="encrypted"

# Parallel encryption
export -f encrypt_file
find "$SOURCE_DIR" -type f -print0 | xargs -0 -P 4 -I {} bash -c 'encrypt_file "$@"' _ {} "$RECIPIENTS_FILE" "$DEST_DIR"

encrypt_file() {
    local file="$1"
    local recipients="$2"
    local dest="$3"
    
    local relative_path="${file#$SOURCE_DIR/}"
    local dest_file="$dest/$relative_path.age"
    
    mkdir -p "$(dirname "$dest_file")"
    age -R "$recipients" "$file" > "$dest_file"
}
```

## Troubleshooting

### Common Issues

#### Key Not Found
```bash
# Check if key file exists
ls -la ~/.age/key.txt

# Check key format
head -1 ~/.age/key.txt
# Should start with: AGE-SECRET-KEY-1

# Verify key can decrypt
echo "test" | age -r "$(age-keygen -y ~/.age/key.txt)" | age -d -i ~/.age/key.txt
```

#### Permission Errors
```bash
# Check file permissions
ls -la ~/.age/
ls -la encrypted_file.age

# Fix permissions
chmod 600 ~/.age/key.txt
chmod 644 encrypted_file.age
```

#### Encryption/Decryption Errors
```bash
# Test with simple example
echo "test" | age -p > test.age
age -d test.age

# Check recipient format
age-keygen -y ~/.age/key.txt
# Should output: age1...
```

### Debugging
```bash
# Enable verbose output (if available)
age -v -r age1ql3z0hjy54pw02xpwpw7rz9pkm7dvq3h8kskj5esf0u0v6yh6mfp7x... file.txt

# Check file integrity
file encrypted_file.age
# Should show: data (encrypted data has no specific file signature)
```

## Migration from GPG

### Key Conversion
```bash
# Age doesn't directly convert GPG keys
# You need to generate new age keys

# Export GPG public keys for reference
gpg --export-options export-minimal --export user@example.com > gpg_public.key

# Generate new age key
age-keygen -o age.key

# Re-encrypt data
gpg -d old_encrypted_file.gpg | age -r "$(age-keygen -y age.key)" > new_encrypted_file.age
```

### Batch Migration
```bash
#!/bin/bash
# migrate-gpg-to-age.sh
GPG_USER="user@example.com"
AGE_KEY="$HOME/.age/key.txt"

# Create age key if it doesn't exist
if [[ ! -f "$AGE_KEY" ]]; then
    age-keygen -o "$AGE_KEY"
fi

# Migrate all .gpg files
find . -name "*.gpg" | while read -r gpg_file; do
    base_name="${gpg_file%.gpg}"
    age_file="$base_name.age"
    
    echo "Migrating $gpg_file to $age_file"
    gpg -d "$gpg_file" | age -r "$(age-keygen -y "$AGE_KEY")" > "$age_file"
    
    # Verify migration
    if age -d -i "$AGE_KEY" "$age_file" | diff - <(gpg -d "$gpg_file") > /dev/null; then
        echo "✓ Migration successful"
        # Uncomment to remove original file
        # rm "$gpg_file"
    else
        echo "✗ Migration failed"
    fi
done
```

## Integration with Your Toolkit

Age pairs excellently with:
- **tar**: Archive encryption
- **rsync**: Secure file synchronization
- **git**: Repository encryption
- **docker**: Container secrets management
- **cron**: Automated encrypted backups
- **scripts**: Secure automation

## Best Practices

1. **Key backup**: Always backup your keys securely
2. **Multiple recipients**: Use multiple keys for important data
3. **Passphrase strength**: Use strong passphrases for passphrase encryption
4. **Key rotation**: Regularly rotate encryption keys
5. **Verification**: Always verify encrypted data can be decrypted
6. **Secure storage**: Store keys in secure locations with proper permissions

## Updates and Maintenance

### Update Age
```bash
# If installed manually
curl -LO "https://github.com/FiloSottile/age/releases/latest/download/age-v1.1.1-linux-amd64.tar.gz"
tar -xzf age-v1.1.1-linux-amd64.tar.gz
sudo mv age/age age/age-keygen /usr/local/bin/

# If installed via Go
go install filippo.io/age/cmd/...@latest
```

### Maintenance Scripts
```bash
#!/bin/bash
# age-maintenance.sh
# Regular maintenance tasks

# Check key integrity
echo "Checking key integrity..."
if echo "test" | age -r "$(age-keygen -y ~/.age/key.txt)" | age -d -i ~/.age/key.txt > /dev/null; then
    echo "✓ Key integrity check passed"
else
    echo "✗ Key integrity check failed"
fi

# Backup keys
echo "Backing up keys..."
age -p ~/.age/key.txt > ~/.age/key.txt.backup.age

# Clean up old encrypted files (optional)
find ~/.age -name "*.age" -mtime +30 -exec rm {} \;
```

Age provides a simple, secure, and modern approach to file encryption that's much easier to use than traditional tools like GPG while maintaining strong security guarantees.

---

For more information:
- [Age GitHub Repository](https://github.com/FiloSottile/age)
- [Age Specification](https://age-encryption.org/)
- [Age Documentation](https://pkg.go.dev/filippo.io/age)