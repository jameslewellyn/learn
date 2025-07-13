# Security Tools

Tools for encryption, secure file handling, and security-focused workflows.

## Available Tools

### **[Age](./age.md)** - Modern Encryption Tool
- **Purpose**: Simple, modern, and secure file encryption
- **Key Features**: Modern cryptography, SSH key support, streaming encryption
- **Use Case**: File encryption, secure backups, secret management
- **Installation**: `curl -LO "https://github.com/FiloSottile/age/releases/latest/download/age-v1.1.1-linux-amd64.tar.gz" && tar -xzf age-v1.1.1-linux-amd64.tar.gz && sudo mv age/age age/age-keygen /usr/local/bin/`

## Quick Start

```bash
# Install age
curl -LO "https://github.com/FiloSottile/age/releases/latest/download/age-v1.1.1-linux-amd64.tar.gz"
tar -xzf age-v1.1.1-linux-amd64.tar.gz
sudo mv age/age age/age-keygen /usr/local/bin/
rm -rf age age-v1.1.1-linux-amd64.tar.gz

# Generate key pair
age-keygen -o key.txt

# Basic encryption/decryption
age -r age1... file.txt > file.txt.age
age -d -i key.txt file.txt.age > file.txt
```

## Key Features

### **Modern Encryption**
- **Cryptography**: Uses ChaCha20-Poly1305 and X25519
- **Simplicity**: Clean, minimal interface without complex configuration
- **Performance**: Fast encryption/decryption with streaming support
- **Security**: Modern cryptographic primitives and best practices

### **Flexible Key Management**
- **X25519 keys**: Native age key format
- **SSH keys**: Use existing SSH keys for encryption
- **Passphrases**: Simple passphrase-based encryption
- **Multiple recipients**: Encrypt for multiple recipients

## Configuration Tips

### Key Management
```bash
# Create secure key directory
mkdir -p ~/.age
chmod 700 ~/.age

# Generate key with proper permissions
age-keygen -o ~/.age/key.txt
chmod 600 ~/.age/key.txt

# Extract public key
age-keygen -y ~/.age/key.txt
```

### Recipients File
```bash
# Create recipients file for team encryption
cat > ~/.age/recipients.txt << 'EOF'
# Team members
age1ql3z0hjy54pw02xpwpw7rz9pkm7dvq3h8kskj5esf0u0v6yh6mfp7x...  # alice
age1another...  # bob

# Backup keys
age1backup...  # backup system
EOF
```

## Common Use Cases

### Secure File Backup
```bash
# Encrypt backup with multiple recipients
tar -czf - ~/documents | age -R ~/.age/recipients.txt > backup-$(date +%Y%m%d).tar.gz.age

# Decrypt backup
age -d -i ~/.age/key.txt backup-20231215.tar.gz.age | tar -xzf -
```

### Secret Management
```bash
# Store API keys securely
echo "secret-api-key" | age -r $(age-keygen -y ~/.age/key.txt) > api-key.age

# Retrieve secret
age -d -i ~/.age/key.txt api-key.age
```

### Development Workflow
```bash
# Encrypt sensitive config files
age -R .age/recipients.txt .env > .env.age

# Decrypt for use
age -d -i ~/.age/key.txt .env.age > .env
```

### Database Backups
```bash
# Encrypted database backup
mysqldump myapp | age -r $(age-keygen -y ~/.age/key.txt) > myapp-$(date +%Y%m%d).sql.age

# Restore from encrypted backup
age -d -i ~/.age/key.txt myapp-20231215.sql.age | mysql myapp
```

## Integration with Other Tools

### Works well with:
- **tar**: Archive encryption
- **rsync**: Secure file synchronization
- **git**: Repository encryption (with careful implementation)
- **docker**: Container secrets management
- **cron**: Automated encrypted backups

### Backup Workflow
```bash
# Complete backup with age
tar -czf - ~/important-files | age -R ~/.age/recipients.txt > secure-backup.tar.gz.age

# Sync encrypted backups
rsync -av *.age backup-server:/backups/
```

## Best Practices

### Security Best Practices
1. **Key backup**: Always backup your keys securely
2. **Multiple recipients**: Use multiple keys for important data
3. **Proper permissions**: Secure key files with appropriate permissions
4. **Key rotation**: Regularly rotate encryption keys
5. **Verification**: Always verify encrypted data can be decrypted

### Operational Best Practices
1. **Recipients file**: Use recipients files for team encryption
2. **Automation**: Include in backup and deployment scripts
3. **Documentation**: Document key management procedures
4. **Testing**: Regularly test encryption/decryption workflows
5. **Monitoring**: Monitor for encryption failures

## Troubleshooting

### Common Issues
- **Key not found**: Check key file paths and permissions
- **Decryption fails**: Verify correct key is being used
- **Permission errors**: Ensure proper file permissions

### Performance
- **Streaming**: Age streams data for efficient large file handling
- **Memory usage**: Minimal memory footprint
- **Speed**: Fast encryption/decryption performance

## Comparison with Traditional Tools

### vs GPG
```bash
# GPG (complex)
gpg --gen-key
gpg --armor --export user@example.com
gpg --encrypt --recipient user@example.com file.txt

# Age (simple)
age-keygen -o key.txt
age -r age1... file.txt > file.txt.age
```

**Advantages of age:**
- Simpler interface and commands
- Modern cryptography
- No complex configuration
- Better performance
- Cleaner key management

## Migration from GPG

### Key Migration
```bash
# Age doesn't directly convert GPG keys
# Generate new age key
age-keygen -o age.key

# Re-encrypt existing data
gpg -d old_file.gpg | age -r $(age-keygen -y age.key) > new_file.age
```

### Workflow Migration
```bash
# Replace GPG commands with age
# Old: gpg --encrypt --recipient user@example.com file.txt
# New: age -r age1... file.txt > file.txt.age

# Old: gpg --decrypt file.txt.gpg
# New: age -d -i key.txt file.txt.age
```

## Automation Examples

### Backup Script
```bash
#!/bin/bash
# Automated encrypted backup
BACKUP_DIR="/backups"
RECIPIENTS_FILE="$HOME/.age/recipients.txt"

# Create encrypted backup
tar -czf - /home/user/documents | age -R "$RECIPIENTS_FILE" > "$BACKUP_DIR/backup-$(date +%Y%m%d).tar.gz.age"

# Verify backup
if age -d -i ~/.age/key.txt "$BACKUP_DIR/backup-$(date +%Y%m%d).tar.gz.age" | tar -tzf - > /dev/null; then
    echo "Backup verified successfully"
else
    echo "Backup verification failed"
fi
```

### CI/CD Integration
```bash
# Decrypt secrets in CI/CD
age -d -i "$CI_SECRET_KEY" secrets.age > .env

# Encrypt deployment artifacts
tar -czf - build/ | age -R recipients.txt > deployment.tar.gz.age
```

---

**Next Steps**: Follow the detailed [age installation guide](./age.md) for comprehensive setup instructions, key management, and advanced usage examples.