---
name: whiteboard-review
description: "Explain a branch, PR, or working change in a living Whiteboard page so the human can review it. Use for Whiteboard review walkthroughs and follow-up discussion, with diagrams checked against code, review questions, and yellow boxes marking only the latest round's changes."
metadata-source: https://github.com/SidG2k1/dotfiles/blob/main/agents/skills/whiteboard-review/SKILL.md
---

# Whiteboard Review

Help the human understand and review the change. Keep one living Whiteboard page throughout the discussion. Explain what the code does, highlight decisions that need scrutiny, and revise the page as the human asks questions.

Use the agentish-to-english skill. Focus on clarity and completeness.

For open design choices, use the design-decisions skill for comparison criteria, recommendations, and how to label subjective probabilities. In Whiteboard, number questions `Q1`, `Q2`, etc. Present options in a table with columns `Option`, `Pros`, `Cons`, `Effort`, and `P(right in hindsight)`, including an "Other" row. The probability estimates need not sum to 1.

## Start the review

Read `session_get_instructions` and `session_capabilities` from the Whiteboard plugin before authoring. Follow its current workflow and component schemas for target selection, source pins, activity, and Diff-view lenses. Use native subagents when the plugin requests delegation, and pass along the review scope and permissions. If the plugin is unavailable, report the missing dependency and stop authoring.

Use the requested change and repository. Reuse the existing review for follow-ups; create a review session for a new change. This workflow uses a review document, not the scratchpad. Keep repository files and the Git index unchanged unless the user separately authorizes edits; report untracked files omitted from the review rather than silently staging them.

Follow the plugin's initial authoring order, then deepen the explanation as you inspect the code. The first page is round 1: an unmarked baseline. Keep a small page note with the round number and whether the page is being updated or is ready for the human to read. This lets an interrupted update resume in the same round.

## Explain with code and diagrams

Lead with the behavior that changes and the known reason for it. Walk one concrete example from the user or caller's entry point through the changed behavior, including unchanged code needed to understand it. Separate observed behavior from intent, inference, and unanswered questions.

Use native diagrams liberally. Show the overall design and add focused diagrams for interactions, branching, state transitions, data ownership, or before/after behavior that deserve separate attention. Choose the plugin's components to fit the explanation. Keep each diagram readable; use prose for rationale and details the picture cannot convey.

Cross-check diagrams and prose against the actual source at the review's pinned revisions. Follow callers, callees, data reads/writes, and relevant tests beyond the changed lines. Verify each depicted interaction, ordering claim, branch, and old/new comparison; distinguish conceptual arrows from actual calls. Attach verified source ranges to diagram elements and link code claims so the human can inspect the evidence. Check returned anchor quotations against the lines you intended. A rendered diagram or passing test alone does not prove the explanation is correct.

Use the plugin's decision-log and trace-link capabilities when available. For consequential behavior, connect the user's requirement or accepted decision to the implementing code and the relevant trace. Distinguish user-approved requirements and assumptions from proposals, conditional deferrals, and choices the agent made itself. Include the rationale and unresolved alternatives when they matter to the review; verify any claimed approval against its original source rather than an agent's summary.

Read existing traces through the plugin's supported APIs and attach links using its current schemas. If a trace is unavailable, state the missing provenance and explain what the code establishes. Do not invent a decision history or enable trace uploads or sharing merely to supply a link.

Inspect the complete raw diff as well as the semantic view. Expand collapsed tests and documentation, and check generated or configuration changes that affect behavior. A summarized function or hidden file is still part of the review scope.

Highlight a few concrete review questions near the relevant explanation, with an easy-to-find list of the remaining questions. State the behavior or tradeoff at issue and what code or evidence informs it. Resolve factual questions by investigation when possible; identify questions requiring human judgment or missing context. Keep open questions visually distinct from the yellow change markers. Incorporate answers in the explanation and remove resolved questions from the active list.

## Iterate on the living page

Treat each user-requested page update as one review round. Clarifications, corrected explanations, new diagrams, and code updates all count. Incremental writes within that update share the same round; a chat-only reply does not start another round. After presenting a round, wait for the human's feedback rather than inventing further rounds.

For each new round:

1. Read the complete current page with `session_get({sessionId, full: true})`; use JSON form when you need child IDs and placement. Record the previous source pins and identify this skill's change markers before editing. If the page note says an update is in progress, resume that round and preserve its markers.
2. Investigate the feedback and relevant code. If the code changed, compare against the previous reviewed source, update the same session's target, and recheck affected anchors, diagrams, claims, and lenses. Keep the review's overall comparison scope unless the human changes it.
3. Begin the plugin's authoring activity before editing. For a new round, advance the page note and mark it in progress. Clear markers from earlier rounds, preserving their content and order; on a resumed round, keep the current round's markers and finish clearing any older ones.
4. Edit the relevant components in place. Preserve unaffected explanations, diagrams, user contributions, and component IDs where possible. Mark substantive additions and revisions with the yellow boxes described below. For removed content, place a short marked explanation at the relevant location when the deletion matters to the review.
5. Read the whole page back, cross-check revised explanations and sources, and fix contradictions. Confirm that only this round's edits have change markers and older reviewed content is still present. Mark the round ready and end authoring activity before handing it back to the human.

### Yellow change boxes

Use native `callout` components with `tone: "warning"` for Whiteboard's yellow/amber boxes. Title each one `Changed in round N: <specific change>`. Reserve that title prefix for this skill's markers; leave ordinary warnings and user-authored callouts alone. The title makes the purpose clear even when a theme changes the color.

Put the updated content inside the box: a paragraph, question, diagram, or small related group. For an existing component, insert an empty marker at its position and move the component inside it using its durable ID. For a diagram with a small internal edit, box the diagram and explain which part changed. Do not highlight whole unchanged sections for a local revision, nest change markers, or mark bookkeeping and mere reformatting.

To clear an old box, move its children back to the box's parent at the same position, in their original order, then remove the empty callout. Removing a populated callout would also remove the reviewed explanation. Move components with `session_edit`; do not rebuild the page or edit Whiteboard storage directly.

Use activity and edit receipts as the plugin instructs. If interrupted or an edit outcome is uncertain, reread the page before continuing; recover the current round instead of duplicating content or clearing its markers.

Keep the final chat message short: identify the page, point out what to inspect this round, and invite answers to the most important open questions. The living page holds the explanation. Continue the review loop when the human responds; review feedback alone does not authorize implementation or approval of the code.
