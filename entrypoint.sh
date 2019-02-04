#!/bin/bash

set -e

# skip if no /revert
echo "Checking if contains '/revert' command..."
(jq -r ".comment.body" "$GITHUB_EVENT_PATH" | grep -E "/revert") || exit 78

# skip if not a PR
echo "Checking if a PR command..."
(jq -r ".issue.pull_request.url" "$GITHUB_EVENT_PATH") || exit 78

# get the SHA to revert
COMMIT_TO_REVERT=$(jq -r ".comment.body" "$GITHUB_EVENT_PATH" | cut -c 9-)

if [[ "$(jq -r ".action" "$GITHUB_EVENT_PATH")" != "created" ]]; then
	echo "This is not a new comment event!"
	exit 78
fi

PR_NUMBER=$(jq -r ".issue.number" "$GITHUB_EVENT_PATH")
REPO_FULLNAME=$(jq -r ".repository.full_name" "$GITHUB_EVENT_PATH")
echo "Collecting information about PR #$PR_NUMBER of $REPO_FULLNAME..."

if [[ -z "$GITHUB_TOKEN" ]]; then
	echo "Set the GITHUB_TOKEN env variable."
	exit 1
fi

URI=https://api.github.com
API_HEADER="Accept: application/vnd.github.v3+json"
AUTH_HEADER="Authorization: token $GITHUB_TOKEN"

pr_resp=$(curl -X GET -s -H "${AUTH_HEADER}" -H "${API_HEADER}" \
          "${URI}/repos/$REPO_FULLNAME/pulls/$PR_NUMBER")

HEAD_REPO=$(echo "$pr_resp" | jq -r .head.repo.full_name)
HEAD_BRANCH=$(echo "$pr_resp" | jq -r .head.ref)

git remote set-url origin https://x-access-token:$GITHUB_TOKEN@github.com/$REPO_FULLNAME.git
git config --global user.email "revert@github.com"
git config --global user.name "GitHub Revert Action"

set -o xtrace

git fetch origin $HEAD_BRANCH

# do the revert
git checkout -b $HEAD_BRANCH origin/$HEAD_BRANCH

# check commit exists
git cat-file -t $COMMIT_TO_REVERT
git revert $COMMIT_TO_REVERT --no-edit
git push origin $HEAD_BRANCH
