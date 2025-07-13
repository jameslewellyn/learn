# NerdFont Installation Guide for Ubuntu

This guide explains how to install a single NerdFont on Ubuntu. NerdFonts are essential for getting the best visual experience with modern CLI tools like Starship, LSD, and many others that use icons and symbols.

## What are NerdFonts?

NerdFonts are fonts that have been patched with a high number of glyphs (icons and symbols) from popular icon collections like:
- Font Awesome
- Devicons  
- Octicons
- Material Design Icons
- Weather Icons
- Powerline symbols

## Why Install a NerdFont?

Many modern CLI tools use these symbols for:
- File type icons in `lsd`
- Git status indicators in `starship`
- Directory icons in terminal file managers
- Status symbols in various TUI applications
- Powerline-style prompts

## Choosing a NerdFont

### Popular NerdFont Recommendations

**For Programming:**
- **JetBrains Mono Nerd Font** - Excellent for coding, great ligatures
- **Fira Code Nerd Font** - Popular programming font with ligatures
- **Hack Nerd Font** - Clean, readable monospace font
- **Source Code Pro Nerd Font** - Adobe's clean programming font

**For Terminal Use:**
- **Meslo LG Nerd Font** - Great for terminals, recommended by Starship
- **DejaVu Sans Mono Nerd Font** - Widely compatible
- **Ubuntu Mono Nerd Font** - Matches Ubuntu's design language
- **Cascadia Code Nerd Font** - Microsoft's modern programming font

**For Style:**
- **Fantasque Sans Mono Nerd Font** - Quirky and fun
- **Victor Mono Nerd Font** - Cursive italics for comments
- **Iosevka Nerd Font** - Narrow, space-efficient

## Installation Methods

### Method 1: Download and Install (Recommended)

This is the most straightforward method for installing a single font.

#### Step 1: Choose Your Font

Visit the [NerdFonts releases page](https://github.com/ryanoasis/nerd-fonts/releases) and decide which font you want. For this example, we'll use **JetBrains Mono**.

#### Step 2: Download the Font

```bash
# Create a temporary directory
mkdir -p ~/tmp/nerdfonts
cd ~/tmp/nerdfonts

# Download JetBrains Mono Nerd Font (replace with your chosen font)
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip

# Alternative fonts (uncomment the one you want):
# wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
# wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip
# wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/SourceCodePro.zip
# wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip
# wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/DejaVuSansMono.zip
# wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/UbuntuMono.zip
# wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip
```

#### Step 3: Extract and Install

```bash
# Extract the font files
unzip JetBrainsMono.zip

# Create font directory for user
mkdir -p ~/.local/share/fonts

# Copy font files (TTF files are preferred)
cp *.ttf ~/.local/share/fonts/

# Update font cache
fc-cache -fv

# Clean up
cd ~
rm -rf ~/tmp/nerdfonts
```

### Method 2: Using curl (One-liner)

```bash
# Example for JetBrains Mono (adjust font name as needed)
mkdir -p ~/.local/share/fonts && \
cd ~/.local/share/fonts && \
curl -L https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip -o JetBrainsMono.zip && \
unzip JetBrainsMono.zip && \
rm JetBrainsMono.zip && \
fc-cache -fv
```

### Method 3: System-wide Installation

If you want the font available for all users:

```bash
# Download and extract as before, then:
sudo mkdir -p /usr/local/share/fonts/nerdfonts
sudo cp *.ttf /usr/local/share/fonts/nerdfonts/
sudo fc-cache -fv
```

## Verification

### Check Font Installation

```bash
# List installed fonts with "Nerd" in the name
fc-list | grep -i nerd

# Search for specific font family
fc-list | grep -i "jetbrains"

# More detailed font information
fc-list : family | grep -i jetbrains
```

### Test Font Rendering

Create a test file to verify the font displays symbols correctly:

```bash
cat > ~/test-nerdFont.txt << 'EOF'
NerdFont Test File
===================

File Type Icons:
  TypeScript
  Python
  Rust
 ﬧ Haskell
  JavaScript
  Markdown
  JSON
  YAML

Git Symbols:
  Branch
  Commit
  Modified
  Added
  Deleted
  Renamed
  Untracked

Powerline Symbols:
       

Arrows and Indicators:
  ❯ ❮ ➜      

Weather:
        

Folder Icons:
      

Numbers in Circles:
          

EOF

# View the test file (should show icons if font is working)
cat ~/test-nerdFont.txt
```

## Terminal Configuration

### Configure Your Terminal

#### GNOME Terminal
1. Open Terminal
2. Go to **Preferences** (Ctrl+,)
3. Select your profile
4. Go to **Text** tab
5. Uncheck "Use the system fixed width font"
6. Click the font button and select your NerdFont (e.g., "JetBrainsMono Nerd Font")
7. Click **Close**

#### Alacritty
Edit `~/.config/alacritty/alacritty.yml`:

```yaml
font:
  normal:
    family: "JetBrainsMono Nerd Font"
    style: Regular
  bold:
    family: "JetBrainsMono Nerd Font"
    style: Bold
  italic:
    family: "JetBrainsMono Nerd Font"
    style: Italic
  size: 12.0
```

#### Kitty
Edit `~/.config/kitty/kitty.conf`:

```bash
font_family JetBrainsMono Nerd Font
bold_font JetBrainsMono Nerd Font Bold
italic_font JetBrainsMono Nerd Font Italic
bold_italic_font JetBrainsMono Nerd Font Bold Italic
font_size 12.0
```

#### Wezterm
Edit `~/.config/wezterm/wezterm.lua`:

```lua
local wezterm = require 'wezterm'

return {
  font = wezterm.font('JetBrainsMono Nerd Font'),
  font_size = 12.0,
}
```

#### VS Code
Add to your settings.json:

```json
{
  "terminal.integrated.fontFamily": "JetBrainsMono Nerd Font",
  "editor.fontFamily": "JetBrainsMono Nerd Font, 'Droid Sans Mono', monospace"
}
```

## Testing with CLI Tools

Once your font is installed and configured, test it with some CLI tools:

### Test with Starship
```bash
# If you have starship installed
starship prompt
```

### Test with LSD
```bash
# If you have lsd installed
lsd -la
```

### Test with Exa (alternative)
```bash
# If you have exa installed
exa -la --icons
```

## Font Variants and Styles

Most NerdFonts come in multiple variants:

### Weight Variants
- **Regular** - Standard weight
- **Bold** - Bold weight
- **Light** - Light weight
- **Medium** - Medium weight

### Style Variants
- **Regular** - Normal style
- **Italic** - Italic/oblique style

### Choose Specific Variants

When installing, you can be selective about which variants to install:

```bash
# Install only regular and bold variants
cp *Regular*.ttf *Bold*.ttf ~/.local/share/fonts/

# Install all variants
cp *.ttf ~/.local/share/fonts/
```

## Troubleshooting

### Font Not Appearing in Terminal

1. **Restart your terminal** after installation
2. **Check font name**: Use `fc-list | grep -i fontname` to see exact name
3. **Update font cache**: Run `fc-cache -fv` again
4. **Check installation path**: Ensure fonts are in `~/.local/share/fonts/`

### Icons Not Displaying

1. **Verify font selection** in terminal settings
2. **Check terminal compatibility** - some terminals have limited font support
3. **Test with different applications** to isolate the issue
4. **Verify font has symbols**: Check with the test file above

### Permission Issues

```bash
# Fix permissions if needed
chmod 644 ~/.local/share/fonts/*.ttf
fc-cache -fv
```

### Multiple Font Versions

If you have multiple versions of a font:

```bash
# Remove old versions
rm ~/.local/share/fonts/*old-font-name*
fc-cache -fv
```

## Advanced Configuration

### Font Configuration File

Create `~/.config/fontconfig/fonts.conf` for advanced font configuration:

```xml
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <alias>
    <family>monospace</family>
    <prefer>
      <family>JetBrainsMono Nerd Font</family>
    </prefer>
  </alias>
</fontconfig>
```

### System Default Monospace

To set your NerdFont as the system default monospace font:

```bash
# Create or edit fontconfig
mkdir -p ~/.config/fontconfig
cat > ~/.config/fontconfig/fonts.conf << 'EOF'
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <alias>
    <family>monospace</family>
    <prefer>
      <family>JetBrainsMono Nerd Font</family>
      <family>DejaVu Sans Mono</family>
    </prefer>
  </alias>
</fontconfig>
EOF

fc-cache -fv
```

## Maintenance

### Updating Your Font

To update to a newer version:

```bash
# Remove old version
rm ~/.local/share/fonts/JetBrainsMono*

# Download and install new version (same steps as installation)
# ... follow installation steps ...

# Update cache
fc-cache -fv
```

### Managing Multiple NerdFonts

If you later want to install additional NerdFonts:

```bash
# Create organized directories
mkdir -p ~/.local/share/fonts/nerdfonts/jetbrains
mkdir -p ~/.local/share/fonts/nerdfonts/firacode

# Install fonts to specific directories
cp JetBrainsMono*.ttf ~/.local/share/fonts/nerdfonts/jetbrains/
cp FiraCode*.ttf ~/.local/share/fonts/nerdfonts/firacode/

fc-cache -fv
```

## Quick Reference

### Installation One-liners

```bash
# JetBrains Mono
curl -L https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip | funzip | fc-cache -fv

# Fira Code
mkdir -p ~/.local/share/fonts && cd ~/.local/share/fonts && curl -L https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip -o fc.zip && unzip fc.zip && rm fc.zip && fc-cache -fv

# Meslo (recommended for Starship)
mkdir -p ~/.local/share/fonts && cd ~/.local/share/fonts && curl -L https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip -o meslo.zip && unzip meslo.zip && rm meslo.zip && fc-cache -fv
```

### Verification Commands

```bash
# Check installation
fc-list | grep -i nerd

# Test symbols
echo " "

# Check specific font
fc-list | grep -i "jetbrains"
```

---

**Your terminal will look amazing with NerdFonts!** 🎨

For related guides, see:
- [Starship Configuration](./rust-cli-tools/starship.md)
- [Alacritty Setup](./rust-cli-tools/alacritty.md)
- [LSD Configuration](./rust-cli-tools/lsd.md)