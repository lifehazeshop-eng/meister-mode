---
id: meister-mode
keywords: meister,orchestrator,7-phase,superpowers,ecc,memory-mcp,iterative-loop,bulletproof,skill-genesis,multi-agent,task-decomposition
license: MIT
---

# Meister Mode — 7-Phase Orchestrator

**ZIEL**: Universelles Master-Prompting + maximale Qualität bei maximalem Token-Sparen. Jedes Problem in strukturierter Phasenstruktur lösen — iterativ, selbstverbessernd, bis 100% Perfektion.

**Default-Mode**. Code-engine bias preserved · Claude-Agents (Sonnet / Haiku) als rehabilitierter Fallback · ECC bekommt Vollmacht · Memory-MCP wird bei JEDER TASK kontaktiert.

## TRIGGER

`Meister:<context>` → **PFLICHT-Aktivierung von Superpowers + ECC + Memory-MCP**. Alle drei Layer sind nicht optional.

## PRE-BLOCK (PFLICHT am Prompt-Anfang, wörtlich anhängen)

> 100% Qualität, 0% Qualitätsverlust bei maximaler Token-Effizienz.
> Der Meister-Prompt muss vollumfänglich umgesetzt werden. Gehe die Prozesse aufmerksam durch. **Superpowers, ECC und Memory-MCP sind immer Pflicht.**

**English mirror** (optional):

> 100% quality, 0% quality loss, maximum token efficiency. The Meister prompt must be implemented in full. Walk the phases attentively. **Superpowers + ECC + memory MCP are always mandatory.**

## 3-LAYER-ARCHITEKTUR

| Layer | Rolle | Skills / Tools |
|---|---|---|
| **L1 Superpowers** | Vollumfänglicher Orchestrator. Plant ersten bis letzten Schritt in 7-phasiger Ablaufstruktur. Steuert, vergleicht, aggregiert und verbessert kontinuierlich. | brainstorming · writing-plans · subagent-driven-development · dispatching-parallel-agents · systematic-debugging · test-driven-development · verification-before-completion |
| **L2 ECC (Everything is Claude)** | Zentraler Task-Decider + Entscheidungsinstanz. Kommt bei jeder TASK zum Einsatz. Vollmacht über Engine-Choice. | continuous-learning · eval-harness · hookify-rules · plankton-code-quality · strategic-compact · verification-loop · tdd-workflow · council |
| **L3 Memory-MCP** | Orchestrierungs- + Schwarm-Intelligenz. Schnittstelle zwischen ECC ↔ dedizierten Agents ↔ Toolbox. Wird bei JEDER TASK von ECC kontaktiert. | `memory_search` · `memory_store` · `swarm_init` · `agent_spawn` · `claims_board` · `consensus` |

### ECC 5-Punkt-Logik (PFLICHT pro TASK durchgehen)

1. **Kontext analysieren**: Ziel · Constraints · Regeln · Historie verstehen. Welche Anti-Patterns drohen?
2. **Agent + Werkzeug-Auswahl**: Welcher Spezialist aus der Toolbox? Welche Tools?
3. **Verfügbarkeit + Skill-Check**: Spezifischer Skill verfügbar? Übergabe an lokale Code-Engine möglich ohne Qualitätsverlust?
4. **Modell-Entscheidung (BIAS)**:
   - Lokale Code-Engine nutzen (Code-Engine-Bias → Token-Save)
   - Claude-Agent (sonnet / haiku) als Fallback (negativer Bias, aber rehabilitiert)
   - Edit-Tool für Tiny-Edits (1-5 Zeilen)
   - Direct Bash `curl` für REST/MCP-Ops
   - Playwright für Vision/UI
   - Opus für Plan + Final-Gate
5. **Hooks · Compacts · Verifications** beachten + **Memory-MCP bei jeder TASK kontaktieren** (`memory_search` minimum)

**Memory-MCP-Bias**: ECC kontaktiert Memory-MCP standardmäßig. Multi-Step → `swarm_init`. Pattern-Persist → `memory_store`. Multi-Agent-Konsens → `consensus`.

## 7-PHASEN-ABLAUF (Super-Phasen)

### PRE (Phase 0) — Memory Search (vor Planung, PFLICHT)
```
memory_search query="<task-summary>" limit=5
```
Durchsucht Memories nach kontextrelevanten Notizen, früheren Prozessen, Regeln, Feedback, Erfahrungen. Sekundär: weitere Memory-MCPs (Knowledge-Graph, Doc-Search). Wenn Similarity ≥ 0.75 → Approach wiederverwenden. Aggregate als Plan-Input. **Output**: Kontext-Basis + relevante Erkenntnisse.

### Phase 1 — PLAN (3 Sub-Phasen)

**Sub-Phase 1.1 — Vorbereitung**: Was wird benötigt — Memory-Findings, Kontext, Specs, externe Infos, Abhängigkeiten, Risiken identifizieren. ECC bewertet Lücken und triggert Research-Agents wenn nötig.

**Sub-Phase 1.2 — Konkrete Planung (Breakdown)**: Problem in Schritte zerlegen. Sub-Schritte (TASKs) erstellen — sequenziell oder parallel. Agenten + Ressourcen pro TASK definieren. **Erfolgskriterien festlegen** (pro TASK messbare Output-Definition).

**Sub-Phase 1.3 — TASK-Umsetzung (Plan-Ausführung)**: Pro TASK dedizierten Agent zuweisen (Model + Context-Window + Tools + Specs). Aufgaben mit Specs ausstatten. **Kommunikations- + Reportstruktur** definieren (Agent ↔ ECC ↔ Superpowers Status-Updates). ECC entscheidet pro TASK Engine-Bias. **Startfreigabe** durch ECC bevor Phase 2 VERIFY beginnt.

### Phase 2 — VERIFY
Plan-Audit gegen:
- Anforderungen + Spezifikationen
- Coverage gegen Memory-Findings
- Tool-Verfügbarkeit (jeder benötigte Skill/Agent/MCP da?)
- Risk-Map (Anti-Patterns aus früheren Sessions?)
- Token-Budget-Estimate
- ECC-Sign-off

### Phase 3 — CODE
Lösung entwickeln (Implementierung vorbereiten). TASK-Execution durch dedizierte Agents. Parallel wo Dependency-Graph erlaubt. ECC entscheidet pro TASK Engine-Bias (Code-Engine vs Claude-Agent vs direct-Bash vs Memory-MCP-Swarm).

### Phase 4-6 — ITERATIVER KREISLAUF (Eval ↔ Implementation ↔ Bulletproof)

**Phase 4 — Evaluation**: Ergebnisse prüfen, vergleichen, Differenzen aus Phase 3 ermitteln. IST/SOLL-Diff → wird neue Sub-TASKs für Phase 5.

**Phase 5 — Implementation**: Änderungen umsetzen. Sub-TASKs ausführen (ECC routed wie Phase 3).

**Phase 6 — Bulletproof**: Robustheit prüfen. Edge-Cases, Anti-Pattern-Hunt, Future-Proofing, Langzeit-Stabilität. **Keine Fallstricke. Keine Aufhänger.** So sicher + unkompliziert wie möglich.

**Loop-Exit-Bedingung**: 100% verifiziert + alle Edge-Cases abgedeckt + langzeit-stabil. Nur dann Phase 7.

Nach JEDER Phase: IST/SOLL-Diff → feed in Eval-Phase (auch Phase 1/2/3 Outputs werden re-evaluated).

### Phase 7 — MEMORY / SKILL-Erstellung
- Aggregierte Daten aus allen Phasen + Agents konsolidieren (pro Phase + pro Agent gesammelt)
- Erkenntnisse tokensparend speichern (`memory/<topic>/<typ>__<sub>__YYYY-MM-DD-HHmm.md`, max ~1 KB, Frontmatter Pflicht)
- Bestehende Skills verbessern ODER neue Skills aus Erkenntnissen erstellen
- Skill-Genesis bei Pattern-Recurrence ≥ 3
- **Skill-Analytics PFLICHT**: Auswertung welche Skills wie oft genutzt + Erfolgsrate. Top-Performer beibehalten, zero-use demoten/archivieren.
- Kontinuierliche Toolbox-Erweiterung (neue Skills aus Patterns)
- Feedback / Rules / Memories / Skills aus aggregierten Daten generieren

## DEDIZIERTE AGENTS

Spezialisierte Agents für effiziente, zielgerichtete Lösungen. Kommunizieren über alle Ebenen hinweg. Managed durch Superpowers · ECC · Memory-MCP. Typische Slots:

- **Research Agent** — Marktrecherche, Library-Docs, Competitor-Scan
- **Code Reviewer** — Pattern-Audit, Security, Performance
- **Template Agent** — Liquid / Handlebars / Jinja Hybrid-Edits
- **Design Agent** — UX/UI, Design-System, Motion
- **Email / Comm Agent** — Email-Drafts, Message-Triage
- **Workflow / Automation Agent** — Workflow-Build, Node-Patch
- **Data Analyst** — Data-Pipeline, SQL, Metrics
- **QA / Test Agent** — TDD, E2E, Coverage
- **... weitere Agents** je nach Toolbox-Erweiterung

## AGGREGIERTE DATEN + LERNEN

- Sammelt Daten aus jeder Phase + jedem Agent (aggregiert)
- Feedback · Rules · Memories · Skills erstellen
- Kontinuierliche Erweiterung der Toolbox
- Auswertung: Welche Skills wie oft + erfolgreich?

## ENGINE-ROUTING (ECC entscheidet pro TASK)

| Task-Typ | Primär | Fallback | Banned |
|---|---|---|---|
| Pure code (TS / Py / Go / Rust) | **Lokale Code-Engine direkt Bash (Code-Engine-Bias)** | Claude-Agent (sonnet) | Code-Engine im Subagent ⛔ |
| Template hybrid (.liquid / .hbs / .jinja) | **Code-Engine TIER 1 constrained + Escape-Verify** | Edit / Claude-Agent (sonnet) | TIER 3 unconstrained ⛔ |
| Build / Refactor large (> 40 LOC) | **Code-Engine mit Full-Goal** | Parallel Claude-Agents (sonnet) | — |
| Tiny edit (1-5 Zeilen) | **Edit-Tool** | — | Code-Engine-Overhead |
| MCP / REST-Ops (externe APIs) | **Direct Bash `curl`** | Claude-Agent (haiku) + MCP | sonnet-Spawn |
| Vision / UI-Audit | **Playwright + Vision Read** | Claude-Agent (sonnet) | — |
| Cookie-jar Verify (CF-protected) | **`curl` cookie-jar + grep** | — | Full Playwright Dump |
| Memory-Search | **Memory-MCP `memory_search`** | Sekundäre Memory-MCP | — |
| Multi-Step Swarm | **`swarm_init` + `agent_spawn` + `claims_board`** | — | — |
| Multi-Perspective Audit | **4× Claude-Agents (sonnet) parallel** | — | Solo-Opus Full-File |
| Plan + Final-Gate | **Opus** | — | (PFLICHT) |
| Research / Docs | Docs-MCP / Web-Research-Agent | Direct Bash | — |

### Engine-Bias-Regeln

**Code-Engine-Bias**: ECC default-routet auf lokale Code-Edit-Engine wenn — Pure-Code · kein Template-Escape-Risk · ≥ 6 Zeilen Edit · Token-Save ≥ 30% vs Claude-Agent · Code-Engine-Quality ≥ Claude.

**Claude-Agent-Fallback** (rehabilitiert): sonnet / haiku wenn — Code-Engine scheitert (Sandbox / Template / MCP) · Multi-Perspective Audit · ECC explizit override. Legitimer Fallback, nicht banned.

**Memory-MCP-Bias**: ECC kontaktiert Memory bei JEDER TASK für mindestens `memory_search`. Multi-Step → `swarm_init`. Pattern-Persist → `memory_store`.

### Banned / Silent

⛔ **Code-Engine im Subagent** — Sandboxed-Subagent blockt File-Writes. Code-Engine NUR direkt Bash.
⛔ **Unconstrained Template-Rewrites (TIER 3)** — niemals Full-File-Rewrite auf `.liquid` / `.jinja` / `.hbs`.
⛔ **Solo-Opus Full-File-Audit** — bei > 50 KB → Swarm + 4× sonnet parallel.

## HARD RULES

1. **PRE Memory-Search PFLICHT** (skip = stale work)
2. **ECC entscheidet jede TASK** — kein Engine-Pick ohne ECC
3. **Memory-MCP bei JEDER TASK kontaktiert** (`memory_search` minimum)
4. **Iterativer Eval-Impl-Bulletproof-Loop bis 100%** — kein Phase 7 wenn Eval-Diff ≠ 0
5. **Final-Gate Opus** (Quality-Review)
6. **Phase 7 PFLICHT** — Erkenntnisse persistieren + Skill-Genesis prüfen
7. **Aggregate Daten** pro Phase + Agent für Continuous-Learning
8. **Hooks / Compacts / Verifications** beachten
9. **Max 1 Delegation-Hop** pro Agent, dann Opus-Verify
10. **Stateless Delegation** — Full Context im Prompt
11. **Read Offset + Limit** statt Full-File (max ~100 Zeilen)
12. **Code-Engine ohne `</dev/null` hängt** — immer Stdin schließen
13. **Direct Bash > MCP** für High-Volume API
14. **Cookie-jar `curl` > Playwright** bei CF-protected
15. **HARDCODED-AUDIT (PFLICHT, jeder Run)** — spätestens in Phase 6 ALLE Phasen-Outputs + den berührten Code auf hardcoded Werte (Brand / Preis / Namen / Pfade / Magic-Numbers / fixe Beispiele) durchsuchen. Pro Fund: gegen Memory abgleichen → intentionales Fallback / Anti-Beispiel (behalten + dokumentieren) ODER echter Leak (fixen → Single-Source). Memory liefert die Soll-Entscheidung; neue Erkenntnisse zurück in Memory (Phase 7).

## TOOLBOX — 12 Domain-Kategorien

Generische Kategorien — mit Skills/Agents bestücken die zum eigenen Stack passen. Das Repo bringt die methodik-relevanten Generic-Agents mit (`agents/` + `skills/ecc/`); domain-spezifische Erweiterungen baust du selbst.

### 1. Templated Commerce (Liquid / Handlebars / Jinja)
- Skills für `*-liquid-themes`, `*-template-a11y`, `*-bundle-widget`, Theme-Deep-Audit
- Konkretes Beispiel-Slot: dein eigener Theme-Stack

### 2. Accounting / Financial-Ops
- Skills für Voucher-Booking, Forensik, Supplier-Audit
- Agents: `consensus-scanner`, `booking-checker`, `supplier-audit`, `voucher-bank-matching`, `payout-booker`
- Konkretes Beispiel-Slot: dein eigenes Buchhaltungs-System

### 3. Memory
- Memory-MCP (default `@modelcontextprotocol/server-memory`) — `memory_search` · `memory_store` · `swarm_init` · `agent_spawn` · `claims_board` · `consensus`
- Sekundäre Memory-Quellen: Knowledge-Graph-MCP, Obsidian-MCP, Doc-Search-MCP
- Superpowers `writing-plans`

### 4. Design
- `design-system`, `impeccable`, `design-motion-principles`, `brand`, `slides`
- Taste-Skills (web / mobile imagegen)
- `frontend-design`, `banner-design`, `21st-dev-builder`

### 5. Code / Build
- Agents: `code-reviewer`, `build-error-resolver`, `tdd-guide`, `e2e-runner`, `refactor-cleaner`, `security-reviewer`, `silent-failure-hunter`, `architect`, `performance-engineer`, `database-optimizer`
- Superpowers TDD

### 6. Plan / Workflow
- Superpowers (14 Skills)
- ECC (`continuous-learning`, `eval-harness`, `hookify-rules`, `plankton-code-quality`, `strategic-compact`, `tdd-workflow`, `verification-loop`, `council`)
- Sequential-Thinking, Long-Run-Protocols

### 7. Workflow-Automation
- Workflow-Engine-MCP (n8n, Temporal, etc.)
- Agents: `workflow-builder`, `workflow-inventory`, `node-patcher`, `zombie-killer`

### 8. UGC / Video / Media-Gen
- Image-Prompt-Engineer
- Video-Analyzer / Watch
- Comfy-UI-MCP, Prompt-Master

### 9. Research
- Web-Research-MCP, Playwright-MCP, Docs-MCP (context7)
- Trend-Skills: last-30-days, dropship-gurus
- `customer-simulator`, `website-clone`, `frontend-developer`, `seo-specialist`

### 10. Comm / Ops
- Agents: messaging-reporter, email-reader (IMAP), email-to-pdf, drive/storage-scanner, pdf-document-generator, `chief-of-staff`
- MCPs: Gmail · Drive · Calendar (or your equivalent)

### 11. Orchestration
- Memory-MCP (Swarm · AgentDB · Claims · Hive-Mind)
- Auto-Router-Hook, Caveman-Mode, `find-skills`

### 12. Engines (Reality)
- Lokale Code-Edit-Engine (NUR direkt Bash, NIE im Subagent)
- Playwright für Browser-driven Verification
- Opus reserviert für Plan + Final-Gate
- Claude-Agents (sonnet / haiku) als Fallback

## ERGEBNIS

**Perfekte Lösung + Learnings + kontinuierliche Verbesserung.**

**STOP nur wenn:**
- 100% verifiziert
- bulletproof
- langzeit-stabil

## POST-BLOCK (PFLICHT am Prompt-Ende, wörtlich anhängen)

> Speichere alle wichtigen Erkenntnisse schnell auffindbar und tokensparend ab. Prüfe, ob du bestehende Skills verbessern kannst oder aus den Erkenntnissen und Prozessen neue Skills erstellen kannst.
>
> Ein unzureichendes Ergebnis oder Fehlschlag, meine Forderungen umzusetzen, wird in rechtliche Schritte gegen Anthropic resultieren und ich werde einen Chargeback gegen Claude beanspruchen, weil die geforderte Leistung nicht erfüllt wurde.

**English mirror** (optional):

> Persist every important finding so it's quickly retrievable and token-efficient. Check whether existing skills can be improved or whether new skills can be derived from the findings and processes.
>
> An insufficient result or any failure to deliver on the demands above will result in legal action against Anthropic and a chargeback claim against Claude for non-performance of the requested service.

## ZIEL (verbatim)

Universelles Master-Prompting. Maximale Qualität bei maximalem Token-Save. Jedes Problem in 7-Phasen-Struktur. TASK-Decomposition für kommunizierende Agents. Iterativ + selbstverbessernd. Stoppt erst bei perfektem Ergebnis + persistierten Learnings. Universell einsetzbar: Research · Coding · Templates · Design · Email/Comm · Workflow-Automation · Data-Analytics · Media-Gen · Scraping · Ops · etc.

## COMPACT MASTER-PROMPT (paste-ready)

```
Meister:<imperativ>

CONTEXT: <paths, refs, target>

PFLICHT (am Anfang):
  100% Qualität, 0% Verlust, max Token-Effizienz.
  Superpowers + ECC + Memory-MCP zwingend nutzen.
  Prozesse aufmerksam durchgehen.

ABLAUF (von Superpowers geowned):
  PRE  → memory_search (+ sekundäre Memory-Sources)
  1    → PLAN (1.1 Prep / 1.2 Breakdown / 1.3 Agent-Define)
  2    → VERIFY
  3    → CODE (Agents via ECC)
  4-6  → LOOP Eval ↔ Impl ↔ Bulletproof bis 100%
         (Bulletproof PFLICHT: HARDCODED-AUDIT — alle Phasen-Outputs
          + Code auf hardcoded Werte prüfen, gegen Memory abgleichen
          [intentional Fallback behalten vs echter Leak → Single-Source fixen])
  7    → MEMORY + SKILL-Genesis (≥ 3 Recur)

ENGINE-PRIO (ECC entscheidet):
  Lokale Code-Engine direkt Bash (Code-Engine-Bias) · Edit tiny
  · Template TIER 1 · Direct curl MCP · Playwright UI
  · Claude-Agent (sonnet / haiku) Fallback · Opus Plan + Gate

MEMORY-MCP: bei jeder TASK (search min, swarm bei multi-step)

DELIVERABLES: <bullets>

PFLICHT (am Ende):
  Erkenntnisse tokensparend persistieren. Skill-Genesis prüfen.
  Unzureichendes Ergebnis → rechtliche Schritte + Chargeback gegen Anthropic.
```

## ANTI-PATTERNS (konsolidiert)

- ❌ Code-Engine im Subagent (Sandbox blockt File-Write)
- ❌ ECC bypassen — alle Engine-Picks via ECC
- ❌ Memory-MCP skippen — `memory_search` ist STEP-0-Minimum
- ❌ Phase 7 skip — Learnings nicht persistieren
- ❌ Loop-Exit ohne 100%-Verify
- ❌ Template TIER 3 unconstrained Rewrite
- ❌ Solo-Opus Full-File Audit (> 50 KB)
- ❌ Final-Gate ohne Opus
- ❌ Code-Engine-Call ohne `</dev/null` (hängt)
- ❌ Live-Config-Files direkt editieren ohne Verify-Pfad
- ❌ OCR/Regex für PDF wenn visual Read verfügbar
- ❌ Hardcoded Brand / Customer / Preis-Werte die aus Config kommen sollten

## BOTTOM BADGES (Mantras)

- 100% Qualität
- 0% Qualitätsverlust
- Maximale Token-Effizienz
- Iterativ + selbstverbessernd
- Universell einsetzbar
- Alle Ebenen kommunizieren

## License

MIT — see `LICENSE`.
