---
name: scaffold
description: "Scaffold — incremental building framework: Survey, Skeleton, Wire, Flesh, Verify. Use for building features, creating projects, or implementing complex changes layer by layer from structure to detail."
---

# /endless:scaffold — Incremental Building Framework

Build anything layer by layer — from skeleton to working code. Prevents the trap of writing everything at once and losing track of structure.

**Pair with `/endless:ooda`**: OODA decides WHAT to do → Scaffold builds HOW to do it.

## Usage

```
/endless:scaffold                        # scaffold from current conversation context
/endless:scaffold <description>          # scaffold a specific feature or task
/endless:scaffold --from-ooda            # continue from a completed OODA decision
/endless:scaffold --layer <N>            # resume from a specific layer (1-5)
/endless:scaffold --dry                  # plan all layers without executing
```

## The 5 Layers

Build in strict order. Each layer MUST be verified before moving to the next. Never jump ahead.

---

### Layer 1: SURVEY

**Goal**: Define scope and boundaries. What are we building? What already exists?

Actions:
- **Requirements**: Extract clear deliverables from the task
- **Inventory**: Scan existing codebase for related code, patterns, conventions
- **Boundaries**: Define what is IN scope and OUT of scope
- **Dependencies**: Identify external libraries, APIs, services needed

**Output format**:
```
## SURVEY

**Building:** [one-line description]

**Deliverables:**
- [ ] [deliverable 1]
- [ ] [deliverable 2]

**Existing code to reuse/extend:**
- [file] — [what it provides]

**Out of scope:**
- [exclusion 1]

**Dependencies:**
- [dependency] — [why needed]
```

**Rules**:
- Use Glob and Grep to scan the actual codebase — do NOT assume structure
- If requirements are ambiguous, ask the user NOW before proceeding
- Keep scope tight — resist feature creep

---

### Layer 2: SKELETON

**Goal**: Create the structural bones — files, types, interfaces, exports. NO implementation yet.

Actions:
- **File structure**: Create new files, establish directory layout
- **Types/Interfaces**: Define data shapes, function signatures, API contracts
- **Exports**: Wire up module boundaries (index files, barrel exports)
- **Stubs**: Empty functions with correct signatures that throw `not implemented`

**Output format**:
```
## SKELETON

**Files created/modified:**
- [path] — [purpose]

**Types defined:**
- [TypeName] — [what it represents]

**Interfaces/Contracts:**
- [function signature or API endpoint]

**Stub count:** [N] functions to implement in FLESH layer
```

**Rules**:
- Write REAL code — types, interfaces, file structure. Not pseudocode
- Every function has a signature but throws `new Error('not implemented')` or `TODO`
- Follow existing codebase conventions (naming, file organization, patterns)
- Run type checker / linter after this layer to catch structural errors early
- This layer should compile/parse without errors even though nothing works yet

---

### Layer 3: WIRE

**Goal**: Connect the skeleton parts together. Routing, data flow, dependency injection. Still minimal logic.

Actions:
- **Imports**: Wire up dependencies between modules
- **Routing**: Connect endpoints, navigation, event handlers
- **Data flow**: Pipe data from source to destination (DB → service → controller → response)
- **Configuration**: Environment variables, config files, provider setup

**Output format**:
```
## WIRE

**Connections made:**
- [A] → [B] — [what flows between them]

**Routes/Handlers registered:**
- [route/event] → [handler]

**Config required:**
- [env var or config key] — [purpose]
```

**Rules**:
- Focus on HOW parts connect, not WHAT they do internally
- Use dependency injection / constructor patterns from existing codebase
- After wiring, the app should start without crashing (even if endpoints return stubs)
- Verify: app boots, routes are registered, imports resolve

---

### Layer 4: FLESH

**Goal**: Implement the actual business logic. Fill every stub with working code.

Actions:
- **Implement**: Replace every stub/TODO with real logic
- **Validate**: Add input validation at system boundaries
- **Handle errors**: Add error handling for external calls and edge cases
- **Test**: Write tests alongside implementation (or right after each function)

**Output format**:
```
## FLESH

**Implemented:**
1. [function/component] — [what it does]
2. [function/component] — [what it does]

**Validation added:**
- [where] — [what is validated]

**Error handling:**
- [scenario] — [how handled]

**Tests written:**
- [test file] — [what it covers]
```

**Rules**:
- Implement ONE function at a time, verify it works, then move to next
- Follow immutability patterns — create new objects, never mutate
- Keep functions small (<50 lines)
- Write tests for each piece as you go — do not defer all testing to Verify
- If a function grows complex, extract helpers NOW, not later

---

### Layer 5: VERIFY

**Goal**: Confirm everything works end-to-end. Run all tests. Check quality.

Actions:
- **Test suite**: Run full test suite — unit, integration, e2e
- **Manual check**: Test critical paths manually if applicable
- **Quality scan**: Check against code quality checklist
- **Deliverables**: Verify all Survey deliverables are complete

**Output format**:
```
## VERIFY

**Test results:**
- Unit: [pass/fail] ([coverage]%)
- Integration: [pass/fail]
- E2E: [pass/fail]

**Quality checklist:**
- [ ] Code is readable and well-named
- [ ] Functions are small (<50 lines)
- [ ] Files are focused (<800 lines)
- [ ] No deep nesting (>4 levels)
- [ ] Proper error handling
- [ ] No hardcoded values
- [ ] Immutable patterns used
- [ ] Input validation at boundaries

**Deliverables status:**
- [ ] [deliverable 1]: DONE/PARTIAL/MISSING
- [ ] [deliverable 2]: DONE/PARTIAL/MISSING

**Outcome:** [COMPLETE / NEEDS WORK]
```

**Rules**:
- Run ACTUAL tests — do not claim "tests pass" without running them
- If any deliverable is MISSING → go back to the appropriate layer and fix
- If NEEDS WORK → identify which layer needs rework and resume from there
- Do NOT mark complete until all deliverables are DONE

---

## Layer Navigation

### Resuming from a layer (`--layer`)
If interrupted or if Verify reveals issues:
```
/endless:scaffold --layer 4    # resume from FLESH
```
Skip completed layers but re-verify the current layer's prerequisites.

### `--from-ooda` mode
When following an OODA decision:
- OODA's Act phase output becomes Scaffold's Survey input
- Skip re-analysis — trust the OODA decision
- Map OODA options/criteria to Scaffold deliverables

### `--dry` mode
Plan all 5 layers without writing code:
```
## SCAFFOLD DRY RUN

**Layer 1 - SURVEY**: [scope summary]
**Layer 2 - SKELETON**: [files and types to create]
**Layer 3 - WIRE**: [connections to make]
**Layer 4 - FLESH**: [functions to implement]
**Layer 5 - VERIFY**: [tests to run]

**Estimated complexity:** [LOW / MEDIUM / HIGH]
```

## Anti-patterns (DO NOT)

- Skip SKELETON and write implementation directly ("I'll just code it")
- Create files without types/interfaces ("I'll add types later")
- Wire everything before the skeleton compiles ("It'll work once connected")
- Implement all functions before testing any ("I'll test at the end")
- Mark VERIFY complete without running tests ("Should be fine")
- Gold-plate in FLESH — add only what Survey defined, nothing more
