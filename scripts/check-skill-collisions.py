#!/usr/bin/env python3
"""check-skill-collisions.py — Cross-skill description-collision detector
and SKILL.md size report.

A single-skill trigger test proves a skill fires on the right prompts, but it
cannot catch TWO skills whose descriptions are similar enough that a prompt
routes ambiguously between them. This gate computes pairwise similarity across
every skill's frontmatter `description:` and flags near-duplicates:

  - WARN  at Jaccard >= 0.50 (printed; does NOT fail CI)
  - FAIL  at Jaccard >= 0.75 (printed; exits non-zero)

Similarity is Jaccard over distinguishing content tokens: descriptions are
lowercased, tokenized on non-alphanumerics, and stripped of stopwords plus the
shared "trigger this skill when ..." boilerplate, so the score reflects what
separates two skills, not the template they share.

The same run also prints a warn-only size report: each SKILL.md's body (the
file content after its frontmatter — the part that loads into every triggered
conversation) is measured against the 8,192-byte budget from writing-skills,
with a second, more urgent tier at 16,384 bytes. The size report never
affects the exit code — it is informational, the same as the WARN tier above.

Usage: check-skill-collisions.py [repo-root]   (default: parent of this script's dir)
Exit:  0 = no collisions >= FAIL · 1 = collision(s) >= FAIL · 2 = no skills found
"""
import os
import re
import sys
import glob

WARN = 0.50
FAIL = 0.75

# SKILL.md body size budget (bytes after frontmatter), from writing-skills'
# Token Efficiency section. Both tiers are warn-only — see print_size_report.
SIZE_WARN = 8192
SIZE_WARN2 = 16384

# Stopwords: generic English + the skill-description boilerplate that every
# description shares ("trigger this skill when the user ..."). Removing these
# keeps the comparison on distinguishing terms.
STOP = set("""
a an the this that these those and or but if when while for to of in on at by with from into
your you they it its their them then than as is are be being been was were will would should
skill trigger use used using need needs needed want wants any even seems doesn t don even
before after during about over under out up down off no not only just more most other some
such can may might must shall do does did done here there where which who whom what how why
""".split())

TOKEN = re.compile(r"[a-z0-9]+")


def tokens(text):
    toks = [t for t in TOKEN.findall(text.lower()) if len(t) >= 3 and t not in STOP]
    return set(toks)


def jaccard(a, b):
    if not a or not b:
        return 0.0
    inter = len(a & b)
    union = len(a | b)
    return inter / union if union else 0.0


def description(path):
    text = open(path, encoding="utf-8").read()
    m = re.search(r"^---\s*\n(.*?)\n---", text, re.DOTALL)
    if not m:
        return None
    fm = m.group(1)
    d = re.search(r"^description:[ \t]*(.*)$", fm, re.MULTILINE)
    if not d:
        return None
    val = d.group(1).strip()
    # YAML block scalar ('>' folded or '|' literal, with optional +/- chomping): the
    # real text is on the following more-indented lines. Gather them so a folded
    # description is still compared instead of collapsing to the indicator character
    # (which would token-empty and silently drop the skill from collision detection).
    if re.fullmatch(r"[>|][0-9]*[+-]?", val):
        block = []
        for ln in fm[d.end():].split("\n"):
            if ln.strip() == "":
                continue
            if ln[:1] in (" ", "\t"):
                block.append(ln.strip())
            else:
                break
        joined = " ".join(block).strip()
        return joined or None
    return val.strip("\"'") or None


def body_bytes(path):
    """Byte length of a SKILL.md's body — everything after the frontmatter,
    which is what actually loads into a triggered conversation."""
    text = open(path, encoding="utf-8").read()
    m = re.match(r"^---\s*\n.*?\n---\s*\n?", text, re.DOTALL)
    body = text[m.end():] if m else text
    return len(body.encode("utf-8"))


def print_size_report(paths):
    """Warn-only report of SKILL.md bodies over the byte budget. Never
    appended to the warns/fails lists — it cannot affect the exit code."""
    tier1, tier2 = [], []
    for p in paths:
        name = os.path.basename(os.path.dirname(p))
        size = body_bytes(p)
        if size > SIZE_WARN:
            tier1.append((size, name))
        if size > SIZE_WARN2:
            tier2.append((size, name))
    tier1.sort(reverse=True)
    tier2.sort(reverse=True)
    if tier1:
        print("\n  WARN size (body over %d bytes — move phase procedures to references/, don't squeeze sentences):" % SIZE_WARN)
        for size, name in tier1:
            print("    %d bytes  %s" % (size, name))
    if tier2:
        print("\n  WARN size (body over %d bytes — second tier, split these first):" % SIZE_WARN2)
        for size, name in tier2:
            print("    %d bytes  %s" % (size, name))


def main():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    repo = sys.argv[1] if len(sys.argv) > 1 and sys.argv[1] else os.path.dirname(script_dir)
    skills_glob = os.path.join(repo, "plugins/claude-code-blueprint/skills/*/SKILL.md")
    paths = sorted(glob.glob(skills_glob))

    if not paths:
        print("check-skill-collisions: no SKILL.md files found under %s — refusing to pass vacuously" % skills_glob)
        return 2

    skills = []
    for p in paths:
        name = os.path.basename(os.path.dirname(p))
        d = description(p)
        if not d:
            print("  WARN: %s has no frontmatter description" % name)
            continue
        skills.append((name, tokens(d)))

    warns, fails = [], []
    for i in range(len(skills)):
        for j in range(i + 1, len(skills)):
            s = jaccard(skills[i][1], skills[j][1])
            if s >= FAIL:
                fails.append((s, skills[i][0], skills[j][0]))
            elif s >= WARN:
                warns.append((s, skills[i][0], skills[j][0]))

    warns.sort(reverse=True)
    fails.sort(reverse=True)

    print("Skill-collision gate — %d skills compared" % len(skills))
    if warns:
        print("\n  WARN (>= %.0f%% similar — review for routing ambiguity, non-blocking):" % (WARN * 100))
        for s, a, b in warns:
            print("    %.0f%%  %s  <->  %s" % (s * 100, a, b))
    if fails:
        print("\n  FAIL (>= %.0f%% similar — near-duplicate descriptions will mis-route):" % (FAIL * 100))
        for s, a, b in fails:
            print("    %.0f%%  %s  <->  %s" % (s * 100, a, b))
        print("\nDisambiguate the FAILing pairs' descriptions (narrow their trigger conditions).")
        print_size_report(paths)
        return 1

    print("\n  No skill-description collisions at or above the %.0f%% fail threshold." % (FAIL * 100))
    if not warns:
        print("  No pairs above the %.0f%% warn threshold either." % (WARN * 100))
    print_size_report(paths)
    return 0


if __name__ == "__main__":
    sys.exit(main())
