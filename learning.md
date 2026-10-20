# Learning

## Git

### Mental model
- [ ] Commits are snapshots pointing to a parent; branches are labels; `HEAD` is where you are
- [ ] Play through learngitbranching.js.org (main + remote levels)
- [ ] Watch `git lg` while merging, rebasing and resetting until the label moves feel obvious

### Commands to try in the terminal
- [ ] `git reflog`: recover from a bad `reset --hard` or rebase in a throwaway repo
- [ ] `git rebase -i HEAD~N`: squash, reword and reorder commits before a PR
- [ ] `git cherry-pick <hash>`: copy one commit onto another branch
- [ ] `git blame` and `git log -p <file>` / `git log -S "<text>"`: trace why code exists
- [ ] `git bisect`: find the commit that introduced a bug
- [ ] `git worktree`: two branches checked out in separate folders
- [ ] `git reset` modes: `--soft` vs default (`--mixed`) vs `--hard`

### Team workflow
- [ ] Commit messages that say why; Conventional Commits (`feat:`, `fix:`)
- [ ] Small, focused PRs
- [ ] Merge strategies: merge commit vs squash vs rebase, and when teams pick each
- [ ] Enable `pull.rebase` and `diff.algorithm = histogram` in `git/.gitconfig` once rebase feels comfortable

## Engineering fundamentals

### Code and design
- [ ] Read "A Philosophy of Software Design" (Ousterhout): deep modules, complexity
- [ ] Refactoring in small, safe steps; recognise code smells
- [ ] Write tests that catch real bugs: unit vs integration, what not to mock
- [ ] Read good open-source code in your stack and note how it is structured

### Debugging
- [ ] Debug with hypotheses and evidence, not random changes
- [ ] Use a real debugger (breakpoints, stepping) instead of only `console.log`
- [ ] Read stack traces and error messages fully before searching

### How systems work
- [ ] HTTP in depth: methods, status codes, caching headers, CORS, cookies vs tokens
- [ ] Databases: indexes, transactions, N+1 queries, reading a query plan
- [ ] Auth: sessions, JWT, OAuth flow; common security mistakes (OWASP Top 10)
- [ ] Performance: measure first (profilers, devtools), then optimise
- [ ] Read "Designing Data-Intensive Applications" (Kleppmann)

### Shipping and operating
- [ ] CI/CD: what a pipeline does, write one from scratch
- [ ] Logging, metrics and error tracking in production
- [ ] Linux and shell basics: processes, permissions, pipes, `ssh`
- [ ] Docker basics: images, containers, compose

## Senior habits
- [ ] Explain trade-offs out loud: why this option and not the other
- [ ] Review others' PRs carefully; give specific, kind feedback
- [ ] Write short design notes before big changes
- [ ] Estimate, then compare with what actually happened
- [ ] Ask "what problem are we solving?" before building
- [ ] Find people better than you: open source, communities, senior colleagues
