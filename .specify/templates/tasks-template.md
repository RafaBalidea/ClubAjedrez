---

description: "Task list template for feature implementation"
---

# Tasks: [FEATURE NAME]

**Input**: Design documents from `/specs/[###-feature-name]/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: MANDATORY (constitution, principles I and II). Every user story includes its test tasks,
and they come BEFORE its implementation tasks. Every acceptance scenario (Dado/Cuando/Entonces) in
spec.md is covered by at least one automated test that references it (e.g. `// US1-E2`).

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **API**: `ClubAjedrez/ClubAjedrez.Api/` (`Endpoints/`, `Data/` with entities and `ClubAjedrezDbContext`)
- **Contracts**: `ClubAjedrez/ClubAjedrez.Contracts/<Entity>/` (DTOs, requests, Refit interface) + `ClubAjedrezJsonContext`
- **Shared UI**: `ClubAjedrez/ClubAjedrez.Shared/Pages/<Entity>/`
- **Schema changes**: `Database/Migrations/NNNN_<descripcion>.sql`
- **bUnit tests**: `ClubAjedrez.Test/`
- **API tests**: API test project (create it if it does not exist yet)
- **E2E tests**: `ClubAjedrez.PlaywrightTests/`

<!--
  ============================================================================
  IMPORTANT: The tasks below are SAMPLE TASKS for illustration purposes only.

  The /speckit-tasks command MUST replace these with actual tasks based on:
  - User stories from spec.md (with their priorities P1, P2, P3...)
  - Acceptance scenarios (Dado/Cuando/Entonces) from spec.md
  - Feature requirements from plan.md
  - Entities from data-model.md
  - Endpoints from contracts/

  Tasks MUST be organized by user story so each story can be:
  - Implemented independently
  - Tested independently
  - Delivered as an MVP increment

  Test tasks are NEVER optional: BDD (one automated test per acceptance scenario)
  and TDD (Red → Green → Refactor) are mandatory.

  DO NOT keep these sample tasks in the generated tasks.md file.
  ============================================================================
-->

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [ ] T001 Create project structure per implementation plan
- [ ] T002 [P] Create test projects required by the plan that do not exist yet (e.g. API test project)

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

Foundational code follows TDD too: write its test first when it has behavior.

Examples of foundational tasks (adjust based on your project):

- [ ] T003 Schema script in Database/Migrations/NNNN_[descripcion].sql (following table conventions)
- [ ] T004 Map [Entity] in ClubAjedrez/ClubAjedrez.Api/Data/ClubAjedrezDbContext.cs
- [ ] T005 [P] DTO/request + Refit interface in ClubAjedrez/ClubAjedrez.Contracts/[Entity]/
- [ ] T006 [P] Add types (and Conflicto<T>) to ClubAjedrezJsonContext and register the client in AddClubAjedrezApi
- [ ] T007 Extend E2E cleanup in ClubAjedrez.PlaywrightTests/E2EFixture.cs for the new entity

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - [Title] (Priority: P1) 🎯 MVP

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Tests for User Story 1 (MANDATORY - write FIRST) ⚠️

> **Write these tests FIRST, run them and confirm they FAIL for the expected reason before any implementation**

- [ ] T010 [P] [US1] E2E test for scenario US1-E1 ([Dado/Cuando/Entonces summary]) in ClubAjedrez.PlaywrightTests/[Entity]E2ETests.cs
- [ ] T011 [P] [US1] API test for [endpoint/business rule] (scenario US1-E2) in [API test project]/[Entity]EndpointsTests.cs
- [ ] T012 [P] [US1] bUnit test for [component behavior] in ClubAjedrez.Test/[Entity]Tests.cs
- [ ] T013 [US1] Run the new tests and confirm they fail (Red)

### Implementation for User Story 1

- [ ] T014 [US1] Implement [endpoint] in ClubAjedrez/ClubAjedrez.Api/Endpoints/[Entity]Endpoints.cs until T011 passes
- [ ] T015 [US1] Implement [page] in ClubAjedrez/ClubAjedrez.Shared/Pages/[Entity]/[Page].razor until T012 passes
- [ ] T016 [US1] Validation and error handling (400, 409 Conflicto<T>, ApiExceptionBase in UI)
- [ ] T017 [US1] Run all tests of the story (Green) and refactor with tests green

**Checkpoint**: All US1 acceptance scenarios pass as automated tests; the story works independently

---

## Phase 4: User Story 2 - [Title] (Priority: P2)

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Tests for User Story 2 (MANDATORY - write FIRST) ⚠️

- [ ] T018 [P] [US2] E2E test for scenario US2-E1 in ClubAjedrez.PlaywrightTests/[Entity]E2ETests.cs
- [ ] T019 [P] [US2] API / bUnit test for scenario US2-E2 in [test file]
- [ ] T020 [US2] Run the new tests and confirm they fail (Red)

### Implementation for User Story 2

- [ ] T021 [US2] Implement [endpoint/feature] in [file] until the tests pass
- [ ] T022 [US2] Integrate with User Story 1 components (if needed)
- [ ] T023 [US2] Run all tests (Green) and refactor with tests green

**Checkpoint**: At this point, User Stories 1 AND 2 should both work independently

---

## Phase 5: User Story 3 - [Title] (Priority: P3)

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Tests for User Story 3 (MANDATORY - write FIRST) ⚠️

- [ ] T024 [P] [US3] E2E test for scenario US3-E1 in ClubAjedrez.PlaywrightTests/[Entity]E2ETests.cs
- [ ] T025 [P] [US3] API / bUnit test for scenario US3-E2 in [test file]
- [ ] T026 [US3] Run the new tests and confirm they fail (Red)

### Implementation for User Story 3

- [ ] T027 [US3] Implement [endpoint/feature] in [file] until the tests pass
- [ ] T028 [US3] Run all tests (Green) and refactor with tests green

**Checkpoint**: All user stories should now be independently functional

---

[Add more user story phases as needed, following the same pattern]

---

## Phase N: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [ ] TXXX [P] Documentation updates (CLAUDE.md, readme.md) if the design changed
- [ ] TXXX Code cleanup and refactoring (with all tests green)
- [ ] TXXX Security hardening (permissions, validation of ids and relations in the API)
- [ ] TXXX Verify every acceptance scenario in spec.md is covered by an automated test
- [ ] TXXX Quality gates: web build, `dotnet test ClubAjedrez.Test/ClubAjedrez.Tests.csproj`, API tests and `dotnet test ClubAjedrez.PlaywrightTests` all green

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - User stories can then proceed in parallel (if staffed)
  - Or sequentially in priority order (P1 → P2 → P3)
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P2)**: Can start after Foundational (Phase 2) - May integrate with US1 but should be independently testable
- **User Story 3 (P3)**: Can start after Foundational (Phase 2) - May integrate with US1/US2 but should be independently testable

### Within Each User Story (BDD + TDD)

- Acceptance tests (one per Dado/Cuando/Entonces scenario) are written first
- Unit tests for the internal pieces are written before each piece
- Tests MUST be run and seen to FAIL before implementation (Red)
- Implement the minimum code to make them pass (Green), then refactor with tests green
- Schema script and mapping before endpoints; endpoints before pages
- Story complete (all its scenarios green) before moving to next priority

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel
- All Foundational tasks marked [P] can run in parallel (within Phase 2)
- Once Foundational phase completes, all user stories can start in parallel (if team capacity allows)
- All tests for a user story marked [P] can be written in parallel
- Different user stories can be worked on in parallel by different team members

---

## Parallel Example: User Story 1

```bash
# Write all tests for User Story 1 together:
Task: "E2E test for scenario US1-E1 in ClubAjedrez.PlaywrightTests/[Entity]E2ETests.cs"
Task: "API test for scenario US1-E2 in [API test project]/[Entity]EndpointsTests.cs"
Task: "bUnit test for [component behavior] in ClubAjedrez.Test/[Entity]Tests.cs"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1 (tests first)
4. **STOP and VALIDATE**: all US1 scenarios green
5. Deploy/demo if ready

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Scenarios green → Deploy/Demo (MVP!)
3. Add User Story 2 → Scenarios green → Deploy/Demo
4. Add User Story 3 → Scenarios green → Deploy/Demo
5. Each story adds value without breaking previous stories (whole suite stays green)

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: User Story 1
   - Developer B: User Story 2
   - Developer C: User Story 3
3. Stories complete and integrate independently

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Scenario ids (US1-E1, US1-E2…) map tests to acceptance scenarios in spec.md
- Each user story should be independently completable and testable
- Verify tests fail before implementing; never disable or delete a test to get green
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Avoid: vague tasks, same file conflicts, cross-story dependencies that break independence
