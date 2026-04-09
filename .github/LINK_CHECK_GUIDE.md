# Link Check Workflow Guide

## Overview

This document explains the automated link checking workflow for the Repository Service for TUF (RSTUF) project. This workflow addresses [Issue #945](https://github.com/repository-service-tuf/repository-service-tuf/issues/945) by automatically detecting broken or outdated links in the repository.

## Problem Statement

The RSTUF repository contains numerous links across:
- Documentation files (`.rst`, `.md`)
- Configuration files (`.yaml`, `.yml`)
- Root-level documentation files

Manually verifying these links is impractical and error-prone. This workflow automates the detection of broken or outdated links.

## Solution Architecture

### Two-Mode Strategy

#### 1. **PR/Push Mode (Fast)**
- **Trigger:** On every push to `main` and pull requests
- **Scope:** Only changed documentation files
- **Performance:** Completes in seconds
- **Failure Behavior:** ❌ **FAILS** the workflow if broken links are found
- **Purpose:** Catch issues early before they reach the main branch

**Files Checked:**
- `docs/**/*.md`
- `docs/**/*.rst`
- `*.md` (root level)
- `*.rst` (root level)

#### 2. **Scheduled Mode (Full Scan)**
- **Trigger:** Every Monday at 2 AM UTC
- **Scope:** Entire repository documentation
- **Performance:** Complete coverage
- **Failure Behavior:** ✅ **DOES NOT FAIL** - only creates an issue
- **Purpose:** Detect link degradation over time

**Files Checked:**
- `docs/` (entire directory)
- `README.rst`
- `CONTRIBUTING.rst`
- `CODE_OF_CONDUCT.rst`
- `ROADMAP.rst`
- `TAC.rst`
- `MAINTAINERS.rst`
- `SECURITY.md`

## Configuration

### Workflow File: `.github/workflows/link-check.yml`

**Key Features:**
- Uses `lychee` link checker (fast, reliable, multi-format support)
- Detects changed files using `tj-actions/changed-files`
- Creates GitHub issues for scheduled scan failures
- Clear logging with emoji indicators

### Configuration File: `lychee.toml`

**Settings:**

| Setting | Value | Purpose |
|---------|-------|---------|
| `timeout` | 30 seconds | Timeout for each link check |
| `retries` | 3 | Retry failed requests |
| `user_agent` | Chrome | Identify as browser |
| `check_fragments` | true | Validate URL anchors |
| `follow_redirects` | true | Follow HTTP redirects |
| `ignore_status_codes` | [429] | Ignore rate limiting |

**Excluded URLs:**
- `localhost`, `127.0.0.1`, `0.0.0.0` - Local development
- `mailto:` - Email addresses
- `zoom.lfx.platform.linuxfoundation.org` - Dynamic Zoom links
- `hackmd.io` - Collaborative docs with access restrictions
- `git@` - Git SSH URLs
- Submodule references

**Excluded Paths:**
- `docs/build/` - Generated HTML
- `docs/diagrams/` - PlantUML source
- `tests/` - Test files
- `.git/` - Git metadata
- Build artifacts (`__pycache__`, `*.egg-info`, `.venv`, etc.)

## Usage

### Automatic Triggers

The workflow runs automatically in these scenarios:

1. **Pull Request with documentation changes**
   ```bash
   git checkout -b fix/update-docs
   # Edit docs/guide.rst
   git push origin fix/update-docs
   # PR created → workflow runs automatically
   ```

2. **Push to main with documentation changes**
   ```bash
   git push origin main
   # Workflow runs automatically
   ```

3. **Weekly scheduled scan**
   - Runs every Monday at 2 AM UTC
   - Creates issue if broken links found

### Manual Trigger

Run the workflow manually from GitHub UI:

1. Go to **Actions** tab
2. Select **Link Check** workflow
3. Click **Run workflow**
4. Choose branch (usually `main`)
5. Click **Run workflow**

## Output and Reporting

### PR/Push Mode Output

**Success:**
```
✅ Checking changed files for broken links...
docs/guide.rst
docs/deployment.md
README.rst

✅ All links are valid!
```

**Failure:**
```
❌ Checking changed files for broken links...
docs/guide.rst
docs/deployment.md

❌ Broken links found:
  File: docs/guide.rst
  URL: https://example.com/broken-page
  Error: 404 Not Found
  
  File: docs/deployment.md
  URL: https://old-domain.com/docs
  Error: Connection Timeout
```

### Scheduled Mode Output

**Issue Created:**
```
Title: 🔗 Broken Links Detected in Documentation (Weekly Scan)

Body:
## Broken or Outdated Links Found

The weekly link check detected broken or outdated links in the repository.

**Action Required:**
- Review the workflow run for details
- Check the error logs for specific URLs and error types
- Update or remove broken links

**Common Issues:**
- 404 errors: URL no longer exists
- Timeout errors: Server not responding
- SSL errors: Certificate issues
```

## Troubleshooting

### Issue: Workflow fails on valid links

**Cause:** Server might be blocking automated requests or rate limiting

**Solution:**
1. Add URL to `exclude` list in `lychee.toml`
2. Increase `timeout` value
3. Check if server requires specific headers

### Issue: False positives (links marked broken but work)

**Cause:** 
- Server rate limiting (429 status)
- Temporary server issues
- Access restrictions

**Solution:**
1. Check `ignore_status_codes` in `lychee.toml`
2. Increase `retries` value
3. Add to exclude list if necessary

### Issue: Workflow takes too long

**Cause:** Too many links or slow servers

**Solution:**
1. Reduce `timeout` value (but not too low)
2. Increase `retries` (paradoxically helps with timeouts)
3. Exclude slow/unreliable domains

## Extending the Configuration

### Adding URLs to Exclude List

Edit `lychee.toml`:

```toml
exclude = [
  # ... existing patterns ...
  "^https://my-internal-domain\\.com",
  "my-slow-server\\.example\\.com",
]
```

### Adding Paths to Exclude

Edit `lychee.toml`:

```toml
exclude_path = [
  # ... existing paths ...
  "my-custom-build-dir",
  "vendor/**",
]
```

### Changing Schedule

Edit `.github/workflows/link-check.yml`:

```yaml
schedule:
  # Run every day at 3 AM UTC
  - cron: '0 3 * * *'
```

### Changing Timeout

Edit `lychee.toml`:

```toml
timeout = 60  # Increase to 60 seconds
```

## Performance Metrics

### PR/Push Mode
- **Average execution time:** 10-30 seconds
- **Scope:** Only changed files
- **Impact:** Minimal (fast feedback)

### Scheduled Mode
- **Average execution time:** 2-5 minutes
- **Scope:** Entire repository
- **Impact:** Runs during off-peak hours

## Best Practices

1. **Keep exclusions minimal** - Only exclude when necessary
2. **Review scheduled issues** - Don't ignore weekly reports
3. **Fix links promptly** - Don't let broken links accumulate
4. **Test locally** - Run lychee locally before pushing
5. **Update documentation** - Keep links current

## Local Testing

### Install lychee locally

```bash
# macOS
brew install lychee

# Linux
curl -L https://github.com/lycheeverse/lychee/releases/download/lychee-v0.15.1/lychee-v0.15.1-x86_64-unknown-linux-gnu.tar.gz | tar xz
sudo mv lychee /usr/local/bin/

# Windows
# Download from: https://github.com/lycheeverse/lychee/releases
```

### Run locally

```bash
# Check specific file
lychee --config lychee.toml docs/guide.rst

# Check entire docs directory
lychee --config lychee.toml docs/

# Check with verbose output
lychee --config lychee.toml --verbose docs/
```

## Related Issues and PRs

- **Issue:** [#945 - Automate detection of outdated or broken links](https://github.com/repository-service-tuf/repository-service-tuf/issues/945)
- **Workflow:** `.github/workflows/link-check.yml`
- **Configuration:** `lychee.toml`

## References

- [Lychee Documentation](https://github.com/lycheeverse/lychee)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Sphinx Link Check Extension](https://www.sphinx-doc.org/en/master/usage/extensions/linkcheck.html)

## Support

For issues or questions about the link check workflow:

1. Check this guide first
2. Review workflow logs in GitHub Actions
3. Open an issue with the `documentation` label
4. Ask in the [#repository-service-for-tuf](https://openssf.slack.com/archives/C052QF5CZFH) Slack channel
