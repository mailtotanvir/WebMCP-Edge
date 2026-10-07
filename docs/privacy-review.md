# Privacy preparation

## Changes

- Replaced local home-directory paths in documentation and test logs with generic checkout placeholders throughout Git history.
- Replaced author, committer, and tagger email addresses with the account's GitHub noreply address.
- Removed the withdrawn article's canonical URL and corrected its current draft status.
- Preserved original local history outside the sanitized publication checkout.

## Verification

An all-object scan of the sanitized checkout covered every stored blob, commit, and tag, including historical revisions. Before this report was added, it covered 34 blobs, six commits, and one annotated tag. It found no original personal email, home-directory paths, common GitHub/OpenAI/AWS credential patterns, private-key headers, explicit hostname/machine-ID fields, or IPv4 strings. This is a focused pattern audit, not proof that all possible secrets are absent.

Public attribution remains intentional: author name, GitHub username, public project links, and the GitHub noreply email. Generic temporary-directory examples and localhost development URLs are instructions, not captured machine identity.

README links, article JavaScript syntax, and patch reproduction were checked. Reproduction fetched the upstream repository, checked out the pinned base, and applied the sanitized patch successfully.

## Limits and release gate

The research repository remains private. Publication and the withdrawn article require owner review. A history rewrite changes commit and tag IDs; consumers of old clones must use a fresh checkout or reconcile their history before pushing.

Previously published objects can remain in GitHub caches, inaccessible object storage, external clones, or forks. Rewriting branch/tag refs does not guarantee erasure. The public blog repository and encyclopedia repository are separate and have not had their history rewritten by this cleanup.
