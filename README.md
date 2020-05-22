# GitHub Action to revert a commit via a comment

After installation, comment `/revert <commit_sha>` to trigger the action.

![revert](https://user-images.githubusercontent.com/2181356/52225171-027d0100-2867-11e9-90a5-84073c790f0b.gif)


## Installation

```
name: Automatic Revert

on:
  issue_comment:
    types: [created]

jobs:
  revert-commit:

    runs-on: ubuntu-latest

    if: contains(github.event.comment.body, '/revert')

    steps:
      - name: Checkout latest code
        uses: actions/checkout@v2
      - name: Automatic Revert
        uses: srt32/revert@v0.0.1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
 ```      

This Action is heavily inspired by [rebase](https://github.com/cirrus-actions/rebase).
