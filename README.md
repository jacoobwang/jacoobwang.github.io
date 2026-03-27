## Personal Blog
recording some funny tools and some interesting things.

### Some Funny Tools
- [Fake Text Message Generator](https://www.faketextmeassage.com/)
- [Aigc With Me](https://aigcwith.me/)

## Post Workflow

Source files live in `content/post/*.md`.
Generated output lives in `public/`.
Root-level static files exist for GitHub Pages compatibility, and `.nojekyll` prevents Pages from parsing source files with Jekyll.

Create a new post:

```bash
./scripts/new-post.sh your-post-slug "Your Post Title"
```

Build locally:

```bash
hugo --minify
```

Deploy:

```bash
git add content/post .github/workflows/deploy.yml .nojekyll scripts README.md public
git commit -m "feat: add new post"
git push origin master
```

Recommended GitHub Pages setting:

Use `GitHub Actions` as the Pages source so the Hugo workflow in `.github/workflows/deploy.yml` is the only deployment path.
