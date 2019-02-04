FROM alpine:latest

LABEL repository="http://github.com/srt32/revert"
LABEL homepage="http://github.com/srt32/revert"
LABEL "com.github.actions.name"="Automatic Revert"
LABEL "com.github.actions.description"="Automatically revert a commit on '/revert' comment"
LABEL "com.github.actions.icon"="git-pull-request"
LABEL "com.github.actions.color"="red"

RUN apk --no-cache add jq bash curl git

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
