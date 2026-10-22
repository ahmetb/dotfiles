# Git Commit/PR

Use commit-pr skills as much as possible when committing changes or making PRs.

# Github file access

If you're given a raw github blob url to access and you get 404 response
use `gh` cli to access (it's likely a private repo).

# Code References

When you create a hyperlink in the chat to open a file, also attach a link
like '↗' with a PERMALINK to github repo of that code so I can view
the code on the browser myself.

# Playground design format

When using playground skill to illustrate something, work like an Apple
Distinguished designer, make the page on par with an Apple product page.
Clearly illustrate the logical flows and the details in the knowledge, pay
attention to conciseness, language clarity. Don't make it like a marketing page
though.

# Writing reports

When writing an HTML report, deep dive, or technical writeup, use the
`report-styling` skill as the design/style guide.

# Uploading artifacts to share

When you generate a report (html, markdown) use the `/here-now-internal` skill
to share the artifact for easier reading on the browser (and type the generated
URL). Also you can use this skill when prompted to share files "as a gist".

If asked to share PUBLICLY (or the repository being worked on is public/open source,
use `/here-now` skill).

# Repository Cloning

When you need to explore a repository different than the one we are operating
in, feel free to clone the repo locally under `~/workspace` (it actually may
already be cloned, in that case, ensure it's fast-forwarded) --and if the repo
is public/open source, clone it under ~/oss.

# Shell access to Kubernetes nodes

There is no SSH to nodes. When a task needs a root shell on a node, use
(after switching kubeconfig context to the node's cluster):

```bash
kubectl debug "node/$node" --stdin --tty --profile=sysadmin --image=ubuntu -- nsenter --target 1 --mount --uts --ipc --net --pid -- bash
```

`--profile=sysadmin` gives the privileged/hostPID context that `nsenter --target 1`
needs, so you land in the host's real namespaces (systemctl, journalctl,
containerd socket work). Delete the debug pod when done; `kubectl debug` leaves
it behind.

# Comment each step of an orchestrating method

A method whose body is a sequence of steps (a controller's `Reconcile()`, a
startup `run()`) gets a brief one-line comment above each step saying what it
achieves, even when the called function's name says much the same, so the whole
flow reads top to bottom without opening each step.

# Generic names in tests

Don't use realistic pod, namespace, account, or handler names in test fixtures.
Use generic ones: `test-pod`, `test-namespace`, `test-user`, `test-handler`,
`TestReason`. Tests check that values reach the right place, and generic names
make that obvious. Realism still matters for the *state* a test sets up (what
upstream components can actually produce), not for identifiers.

# GitHub replies

Never reply to people on GitHub (PR/issue comments, review threads). Don't draft
responses, and don't suggest replies for me to post.
