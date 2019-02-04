# GitHub Action to revert a commit via a comment

After installation, comment `/revert <commit_sha>` to trigger the action.

## Installation

```hcl
workflow "Automatic Revert" {
  on = "issue_comment"
  resolves = "Revert"
}

action "Revert" {
  uses = "srt32/revert@master"
  secrets = ["GITHUB_TOKEN"]
}
```

This Action is heavily inspired by [rebase](https://github.com/cirrus-actions/rebase).
