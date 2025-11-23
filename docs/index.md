---
title: MPSTME BTech Cybersecurity
---

Welcome to the MPSTME (Mukesh Patel School of Technology Management & Engineering) BTech Cybersecurity collaborative digital garden. This platform is designed for students, faculty, and the cybersecurity community to share notes, resources, and knowledge.

## 🚀 Deployment Guide

### Prerequisites

Before you begin, ensure you have the following installed:
- **Node.js** v22 or higher
- **npm** v10.9.2 or higher

You can verify your installations by running:
```shell
node --version
npm --version
```

### Getting Started

#### 1. Clone and Install

```shell
git clone https://github.com/TJ2005/collaborate-quartz.git
cd collaborate-quartz
npm install
```

#### 2. Initialize Content (First Time Only)

```shell
npx quartz create
```

This will guide you through setting up your content directory.

#### 3. Local Development

Start a local development server to preview your changes:

```shell
npx quartz build --serve
```

Visit `http://localhost:8080/` in your browser to see your site.

#### 4. Add Your Content

All content goes in the `content/` folder. You can:
- Create new markdown files (`.md`)
- Edit existing content
- Add images and attachments
- Use [[wikilinks]] to link between pages

#### 5. Build for Production

When ready to deploy:

```shell
npx quartz build
```

This creates static files in the `public/` folder.

#### 6. Deploy Your Changes

Sync your changes to GitHub (which can trigger automatic deployment):

```shell
npx quartz sync
```

## 📝 Content Management

### Writing Content

- Place all content in the `content/` folder
- Use Markdown syntax
- Add frontmatter for metadata:

```markdown
---
title: Your Page Title
date: 2025-11-23
tags:
  - cybersecurity
  - networking
---

Your content here...
```

### Configuration

- **Site Config**: Edit `quartz.config.ts` for general settings
- **Layout**: Modify `quartz.layout.ts` to change page layout
- **Styling**: Customize in `quartz/styles/`

## 🛠️ Useful Commands

| Command | Description |
|---------|-------------|
| `npx quartz build --serve` | Start local development server |
| `npx quartz build` | Build for production |
| `npx quartz sync` | Sync changes to GitHub |
| `npx quartz create` | Initialize content (first time) |
| `npx quartz update` | Update to latest version |

## 🌐 Hosting Options

After building, you can deploy the `public/` folder to:
- GitHub Pages
- Netlify
- Vercel
- Cloudflare Pages
- Any static hosting service

For detailed hosting instructions, see the [[hosting]] page.

## 💬 Community & Support

- **Discord**: [Join our community](https://discord.gg/p8xN7T8ch6)
- **Issues**: [Report bugs or request features](https://github.com/TJ2005/collaborate-quartz/issues)

## 📚 Additional Resources

- [[authoring content|Content Authoring Guide]]
- [[configuration|Configuration Options]]
- [[layout|Layout Customization]]
- [[features/index|All Features]]

---

**MPSTME BTech Cybersecurity** | Building knowledge together
