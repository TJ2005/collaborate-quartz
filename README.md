# MPSTME BTech Cybersecurity - Collaborative Repository

This is the configuration repository for the MPSTME (Mukesh Patel School of Technology Management & Engineering) BTech Cybersecurity program's collaborative digital garden and notes website.

## 🚀 Deployment Commands

### Initial Setup

```bash
# Clone the repository
git clone https://github.com/TJ2005/collaborate-quartz.git
cd collaborate-quartz

# Install dependencies
npm install
```

### Local Development

```bash
# Start local development server with hot-reload
npx quartz build --serve

# The site will be available at http://localhost:8080/
```

### Build for Production

```bash
# Build the static site
npx quartz build

# Output will be in the 'public' folder
```

### Sync Content

```bash
# Add, commit, and push your changes to GitHub
npx quartz sync
```

### Full Deployment Workflow

```bash
# 1. Make your content changes in the content/ folder
# 2. Preview locally
npx quartz build --serve

# 3. Build for production
npx quartz build

# 4. Sync to GitHub (this will trigger automatic deployment if configured)
npx quartz sync
```

## 📚 Requirements

- **Node.js**: v22 or higher
- **npm**: v10.9.2 or higher

## 💬 Community

[Join our Discord Community](https://discord.gg/p8xN7T8ch6)
