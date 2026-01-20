#!/usr/bin/env python3
import json
import re
from pathlib import Path

PATTERNS = [
    re.compile(r"\bstart(?:s|ing)?\b.*\bletter\b", re.IGNORECASE),
    re.compile(r"\bbegin(?:s|ning)?\b.*\bletter\b", re.IGNORECASE),
    re.compile(r"\bends?\b.*\bletter\b", re.IGNORECASE),
    re.compile(r"\bstarts?\b.*\bwith\b.*\bletter\b", re.IGNORECASE),
    re.compile(r"\bbegin\b.*\bwith\b.*\bletter\b", re.IGNORECASE),
    re.compile(r"\bletter\b\s+[A-Z]", re.IGNORECASE),
]


def is_sensitive(prompt: str) -> bool:
    return any(pattern.search(prompt) for pattern in PATTERNS)


def main() -> int:
    cards_path = Path("assets/cards.json")
    cards = json.loads(cards_path.read_text(encoding="utf-8"))
    flagged = [
        card for card in cards
        if is_sensitive(card.get("promptEn", ""))
    ]

    if not flagged:
        print("No language-sensitive prompts detected.")
        return 0

    print(f"Flagged {len(flagged)} card(s):")
    for card in flagged:
        scope = ",".join(card.get("languageScope", []))
        print(f"- id={card.get('id')} scope=[{scope}] promptEn={card.get('promptEn')}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
