---
name: flow
description: "Full thinking-to-building pipeline: OODA (analyze + decide) → Scaffold (build layer by layer). Use when unsure how to approach a task — this command thinks first, then builds."
---

# /endless:flow — Think Then Build

Complete pipeline from "ไม่รู้จะทำยังไง" to "เสร็จแล้ว" in one command. Combines OODA analysis with Scaffold building as a single seamless flow.

```
/endless:flow                          # run on current task
/endless:flow <description>            # run on a specific task
/endless:flow --fast                   # compressed analysis + build
/endless:flow --research               # force research in OBSERVE regardless of task size
```

## When to Use

- You have a goal but no clear path
- The problem needs analysis before building
- You want a single command from start to finish

**If you already know exactly what to build** → use `/endless:scaffold` directly instead.
**If you only need to analyze, not build** → use `/endless:ooda` directly instead.

---

## The Pipeline

9 phases total: 4 Think + 5 Build. Execute in order. Do NOT skip phases.

```
 THINK                              BUILD
┌──────────────────────┐    ┌──────────────────────┐
│ 1. OBSERVE           │    │ 5. SURVEY            │
│ 2. ORIENT            │    │ 6. SKELETON          │
│ 3. DECIDE            │ ──>│ 7. WIRE              │
│ 4. BRIDGE            │    │ 8. FLESH             │
│                      │    │ 9. VERIFY            │
└──────────────────────┘    └──────────────────────┘
```

---

## THINK Phase (from OODA)

### 1. OBSERVE

Gather raw facts in 3 steps — in order:

**Step 1: Scan local**
- Read relevant files, check git status/log
- Collect error signals: logs, stack traces, test failures
- If new project with no codebase → skip to Step 2

**Step 2: List unknowns**
- What is still missing after local scan?
- Classify: `critical` (blocks decision) or `minor` (can assume)

**Step 3: Resolve critical unknowns via Research**

Research is proportional to task complexity:
- Simple task → skip unless `--research` flag
- New project / architecture decision / library upgrade → always research

Research process:
```
critical unknown → WebSearch("<specific query> <current year>")
                        ↓
               if snippet resolves unknown → done
               if need more detail → WebFetch(most relevant URL)
                        ↓
               extract only facts relevant to this task
```

**Output**:
```
## 1/9 OBSERVE

**Facts (local):**
- [fact from codebase or environment]

**Facts (research):**
- [fact — source: URL]

**Unknowns resolved:**
- [unknown] → [resolution]

**Unknowns remaining (minor):**
- [unknown] — assuming [assumption]
```

**Rules**:
- Research is goal-directed — resolve a specific unknown then stop
- If critical unknown cannot be resolved → ask user before ORIENT
- No assumptions without flagging them explicitly

---

### 2. ORIENT

Analyze observations. Build understanding.

- Pattern recognition — what does this look like?
- Root cause analysis — ask "why" 3-5 times
- Map constraints (time, tech, compatibility)
- Assess risks for different approaches

**Output**:
```
## 2/9 ORIENT

**Analysis:**
- [insight 1]
- [insight 2]

**Root cause:** [hypothesis]

**Constraints:**
- [constraint 1]

**Risks:**
- [risk 1 → mitigation]
```

**Rules**:
- Most important thinking phase — do not rush
- Consider at least 2 alternative interpretations
- If new unknowns appear, loop back to OBSERVE

---

### 3. DECIDE

Choose approach with rationale.

- List 2-3 viable options
- Compare on effort, risk, reversibility
- Pick one with justification

**Output**:
```
## 3/9 DECIDE

**Options:**
1. [Option A] — [pros] / [cons]
2. [Option B] — [pros] / [cons]

**Selected: Option [X]**
**Rationale:** [why]
**Rollback plan:** [if it fails]
```

**Rules**:
- Never pick without considering alternatives
- If confidence <70%, loop back to OBSERVE
- Prefer reversible over irreversible actions

---

### 4. BRIDGE

**This phase is unique to flow.** Translate the OODA decision into Scaffold-ready deliverables. This is the handoff point from thinking to building.

- Convert decision into concrete deliverables
- Map constraints to scope boundaries
- Identify what to build, what to reuse, what to skip
- Set success criteria that Verify will check

**Output**:
```
## 4/9 BRIDGE

**Decision → Deliverables:**
- [ ] [deliverable 1]
- [ ] [deliverable 2]

**Reuse from existing code:**
- [file/module] — [what to reuse]

**Out of scope:**
- [exclusion]

**Success criteria (for final Verify):**
- [ ] [criterion 1]
- [ ] [criterion 2]
```

**Rules**:
- Every decision point from DECIDE must map to at least one deliverable
- Success criteria must be testable — no vague "works well"
- This replaces Scaffold's SURVEY phase — do NOT repeat survey work

---

## BUILD Phase (from Scaffold)

### 5. SURVEY

**Skipped in flow** — already covered by OBSERVE + BRIDGE. Proceed directly to SKELETON.

If BRIDGE output is missing critical information (e.g. didn't scan existing code), run a quick inventory:
```
## 5/9 SURVEY (supplemental)

**Additional existing code found:**
- [file] — [relevance]
```

---

### 6. SKELETON

Create structural bones — files, types, interfaces. NO implementation.

- Create file structure and directory layout
- Define types, interfaces, function signatures
- Stub functions with correct signatures

**Output**:
```
## 6/9 SKELETON

**Files created:**
- [path] — [purpose]

**Types defined:**
- [TypeName] — [what it represents]

**Stubs:** [N] functions to implement
```

**Rules**:
- Write real code — types, interfaces, stubs
- Must compile/parse without errors
- Follow existing codebase conventions

---

### 7. WIRE

Connect parts together. Routing, data flow, imports.

- Wire dependencies between modules
- Register routes, handlers, events
- Set up configuration

**Output**:
```
## 7/9 WIRE

**Connections:**
- [A] → [B] — [what flows]

**Routes registered:**
- [route] → [handler]
```

**Rules**:
- App should start without crashing after this layer
- Focus on connections, not internal logic

---

### 8. FLESH

Implement business logic. Fill every stub.

- Replace stubs with real implementation
- Add input validation at boundaries
- Add error handling for external calls
- Write tests alongside each function

**Output**:
```
## 8/9 FLESH

**Implemented:**
1. [function] — [what it does]
2. [function] — [what it does]

**Tests written:**
- [test file] — [coverage]
```

**Rules**:
- One function at a time, verify before next
- Immutable patterns — no mutation
- Functions <50 lines, files <800 lines

---

### 9. VERIFY

Confirm everything works. Check all success criteria from BRIDGE.

- Run full test suite
- Check quality standards
- Verify every deliverable and criterion from BRIDGE

**Output**:
```
## 9/9 VERIFY

**Tests:** [pass/fail] ([coverage]%)

**Success criteria (from BRIDGE):**
- [ ] [criterion 1]: PASS/FAIL
- [ ] [criterion 2]: PASS/FAIL

**Deliverables:**
- [ ] [deliverable 1]: DONE/PARTIAL/MISSING

**Outcome:** [COMPLETE / NEEDS WORK]
```

**Rules**:
- Run actual tests — never claim pass without evidence
- Check criteria from BRIDGE phase, not invented ones
- If NEEDS WORK → identify which phase to revisit

---

## `--fast` mode

Compress THINK into a single block, then build normally:

```
## THINK (fast)

**Observe**: [1-2 lines]
**Orient**: [1-2 lines]
**Decide**: [chosen approach]
**Bridge**: [deliverables list]

## BUILD

[proceed with SKELETON → WIRE → FLESH → VERIFY]
```

## Revisiting Phases

If any phase reveals the decision was wrong:

| Problem found in | Go back to |
|-----------------|------------|
| SKELETON fails to compile | BRIDGE — wrong deliverables? |
| WIRE — parts don't connect | SKELETON — missing interfaces? |
| FLESH — logic doesn't work | ORIENT — wrong root cause? |
| VERIFY — criteria fail | DECIDE — wrong approach? |

Maximum 2 revisits before escalating to user.

## Anti-patterns (DO NOT)

- Skip THINK and jump straight to BUILD ("I already know")
- Skip BRIDGE and start coding without deliverables ("I'll figure it out")
- Rush ORIENT to get to BUILD faster ("Analysis looks fine")
- Add deliverables during FLESH that weren't in BRIDGE ("While I'm here...")
- Skip VERIFY because "it compiled" ("Should work")
