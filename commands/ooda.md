---
name: ooda
description: "OODA Loop — structured decision-making framework: Observe, Orient, Decide, Act. Use for debugging, feature implementation, incident response, or any task requiring systematic analysis before action."
---

# /endless:ooda — OODA Loop Decision Framework

Structured reasoning loop that prevents premature action. Forces systematic observation and analysis before committing to a solution.

## Usage

```
/endless:ooda                          # run OODA on current task/conversation context
/endless:ooda <description>            # run OODA on a specific problem or task
/endless:ooda --loop                   # continuous OODA — re-observe after each Act cycle
/endless:ooda --fast                   # compressed single-pass (skip deep analysis)
/endless:ooda --research               # force research in OBSERVE regardless of task size
```

## The Loop

Execute each phase **in order**. Do NOT skip phases. Output each phase under its header.

---

### Phase 1: OBSERVE

**Goal**: Gather raw facts. No interpretation yet.

Collect information relevant to the task in 3 steps — in order:

**Step 1: Scan local**
- Read relevant files, check git status/log, identify recent changes
- Collect error signals: logs, stack traces, test failures, linter warnings
- Map constraints from existing code: dependencies, versions, patterns in use

**Step 2: List unknowns**
- What information is still missing after scanning local?
- Classify each unknown: `critical` (blocks decision) or `minor` (can assume)

**Step 3: Resolve critical unknowns**
For each `critical` unknown — choose resolution method:
- **Local resolvable** → Read more files, Grep deeper, check package.json
- **External resolvable** → Research (see below)
- **Unresolvable** → flag to user before proceeding

**Research (triggered by critical unknowns OR --research flag)**

Research is proportional to task complexity:
- Simple task (fix typo, rename variable) → skip unless `--research`
- Complex task (new project, library upgrade, architecture decision) → always research

Research process:
```
critical unknown → WebSearch("<specific query> <current year>")
                        ↓
               evaluate results (title + snippet)
                        ↓
               if snippet resolves unknown → done
               if need more detail → WebFetch(most relevant URL)
                        ↓
               extract only facts relevant to this task
               discard the rest
```

Trusted sources (prefer in order): official docs, GitHub repo, changelog, Stack Overflow

**Output format**:
```
## OBSERVE

**Facts (local):**
- [fact from codebase]

**Facts (research):**
- [fact from web — source: URL]

**Unknowns resolved:**
- [unknown] → [how resolved]

**Unknowns remaining (minor):**
- [unknown] — assuming [assumption]
```

**Rules**:
- Use tools (Read, Grep, Glob, Bash) to gather real data — do NOT rely on assumptions
- Research goal-directed only — search to resolve a specific unknown, then stop
- List facts, not opinions
- If critical unknown cannot be resolved → ask user before proceeding to ORIENT

---

### Phase 2: ORIENT

**Goal**: Analyze and make sense of observations. Build a mental model.

- **Pattern recognition**: What does this look like? Similar past problems?
- **Root cause analysis**: Why is this happening? (Ask "why" 3-5 times)
- **Constraint mapping**: What are the boundaries? (time, tech, compatibility, user preferences)
- **Risk assessment**: What could go wrong with different approaches?
- **Mental models**: Apply relevant frameworks (dependency analysis, data flow tracing, etc.)

**Output format**:
```
## ORIENT

**Analysis:**
- [insight 1]
- [insight 2]

**Root cause hypothesis:**
[Most likely root cause and reasoning]

**Constraints:**
- [constraint 1]
- [constraint 2]

**Risks:**
- [risk 1 -> mitigation]
- [risk 2 -> mitigation]
```

**Rules**:
- This is the MOST IMPORTANT phase — spend the most effort here
- Challenge your first instinct. Consider at least 2 alternative interpretations
- If Orient reveals new unknowns, loop back to Observe

---

### Phase 3: DECIDE

**Goal**: Choose a specific course of action with clear rationale.

- **Options**: List 2-3 viable approaches (never just one)
- **Trade-offs**: Compare options on effort, risk, reversibility, quality
- **Selection**: Pick one with clear justification
- **Success criteria**: How will you know it worked?
- **Rollback plan**: What if it doesn't work?

**Output format**:
```
## DECIDE

**Options considered:**
1. [Option A] — [pros] / [cons]
2. [Option B] — [pros] / [cons]
3. [Option C] — [pros] / [cons]

**Selected: Option [X]**
**Rationale:** [why this option wins]

**Success criteria:**
- [ ] [criterion 1]
- [ ] [criterion 2]

**Rollback plan:** [what to do if this fails]
```

**Rules**:
- Never select the first option without considering alternatives
- Prefer reversible actions over irreversible ones
- If no option reaches >70% confidence, loop back to Observe for more data

---

### Phase 4: ACT

**Goal**: Execute the decision. Then verify.

- **Execute**: Implement the chosen approach step by step
- **Verify**: Run tests, check output, confirm success criteria
- **Document**: Note what was done and the outcome

**Output format** (after execution):
```
## ACT

**Actions taken:**
1. [action 1] -> [result]
2. [action 2] -> [result]

**Verification:**
- [ ] [criterion 1]: PASS/FAIL
- [ ] [criterion 2]: PASS/FAIL

**Outcome:** [SUCCESS / PARTIAL / FAILED]
```

**Rules**:
- Execute ONE step at a time, verify before proceeding to next
- If any step fails unexpectedly -> STOP -> start a new OODA loop from Observe
- Do not "fix forward" blindly — re-observe first

---

## Loop Control

### When to re-loop (`--loop` mode)
After Act phase, if outcome is PARTIAL or FAILED:
1. Feed Act results back into a new Observe phase
2. Orient with updated information
3. Decide on adjusted approach
4. Act again

Maximum 3 loops before escalating to user.

### `--fast` mode
Compress all 4 phases into a single block. Use for low-risk, well-understood tasks:

```
## OODA Fast

**Observe**: [1-2 lines]
**Orient**: [1-2 lines]
**Decide**: [chosen approach]
**Act**: [executing...]
```

## Integration with Other Skills

- After OODA Decide phase, use `/plan` if the implementation is complex
- During OODA Act phase, use `/tdd` for test-driven implementation
- If debugging, OODA Orient naturally leads to root cause analysis

## Anti-patterns (DO NOT)

- Skip Observe and jump to Act ("I know what this is")
- Orient with only one hypothesis ("It must be X")
- Decide without alternatives ("The only option is...")
- Act without verification ("Should be fixed now")
- Ignore unknowns ("Probably fine")
