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
```

## The Loop

Execute each phase **in order**. Do NOT skip phases. Output each phase under its header.

---

### Phase 1: OBSERVE

**Goal**: Gather raw facts. No interpretation yet.

Collect information relevant to the task:

- **Codebase state**: Read relevant files, check git status/log, identify recent changes
- **Error signals**: Logs, stack traces, test failures, linter warnings
- **Context**: User's request, constraints, environment, dependencies
- **Unknowns**: What information is missing? What assumptions are being made?

**Output format**:
```
## OBSERVE

**Facts gathered:**
- [fact 1]
- [fact 2]
- ...

**Unknowns / Missing info:**
- [unknown 1]
- ...
```

**Rules**:
- Use tools (Read, Grep, Glob, Bash) to gather real data — do NOT rely on assumptions
- If critical unknowns exist, resolve them NOW before moving to Orient
- List facts, not opinions

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
