---
# Blueprint Per-Project Configuration
# Customize which agents are active for this project's tech stack.
# This file is gitignored — each developer can have their own config.

# Review agents dispatched by /review-swarm
# Comment out agents that aren't relevant to your stack.
review-agents:
  # Always active (language-agnostic)
  - code-reviewer
  - security-sentinel
  - performance-oracle
  - code-simplicity-reviewer
  - convention-enforcer
  - test-coverage-reviewer

  # Activate based on project type
  # - architecture-strategist    # Uncomment for large/complex codebases
  # - frontend-reviewer          # Uncomment for projects with UI
  # - data-integrity-guardian    # Uncomment for projects with database migrations
  # - schema-drift-detector      # Uncomment for projects with ORM schemas

# Research agents dispatched by /deep-research
research-agents:
  - learnings-researcher
  - best-practices-researcher
  - framework-docs-researcher
  - git-history-analyzer
  - codebase-context-mapper

# Project type (used for agent selection hints)
# Options: web-fullstack, api-backend, cli-tool, library, mobile, data-pipeline
project-type: web-fullstack

# Tech stack (informational — helps agents focus)
# languages: [typescript, python, ruby, go, rust, etc.]
# frameworks: [next.js, rails, django, express, etc.]
# databases: [postgresql, mysql, sqlite, mongodb, etc.]
---

# Project-Specific Notes

_Add project-specific configuration notes here. This section is read by agents for additional context._

## Stack Details

<!-- Uncomment and fill in relevant sections -->
<!-- - Primary language: TypeScript -->
<!-- - Framework: Next.js 15 (App Router) -->
<!-- - Database: PostgreSQL via Prisma -->
<!-- - Testing: Vitest + Playwright -->
<!-- - CI: GitHub Actions -->

## Review Focus Areas

<!-- Add areas that reviewers should pay extra attention to -->
<!-- - Authentication flows (OAuth + JWT) -->
<!-- - Data privacy (PII handling, GDPR compliance) -->
<!-- - Performance for endpoints with > 1000 req/min -->
