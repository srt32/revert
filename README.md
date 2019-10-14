# GitHub Action to revert a commit via a comment

After installation, comment `/revert <commit_sha>` to trigger the action.

![revert](https://user-images.githubusercontent.com/2181356/52225171-027d0100-2867-11e9-90a5-84073c790f0b.gif)


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

## If you are using new yml format for workflow file

```
name: Automatic Revert

on:
  issue_comment:
    types: [created]

jobs:
  revert-commit:

    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v1
    - name: Automatic Revert
      uses: srt32/revert@v0.0.1
      with:
       username: ${{ secrets.TOKEN }}
 ```      

This Action is heavily inspired by [rebase](https://github.com/cirrus-actions/rebase).
