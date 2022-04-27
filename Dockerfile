FROM alpine:latest

LABEL version="1.0.0"
LABEL repository="http://github.com/vendoo/gha-cherry-pick"
LABEL homepage="http://github.com/vendoo/gha-cherry-pick"
LABEL maintainer="Vendoo Inc."
LABEL "com.github.actions.name"="Automatic Cherry Pick"
LABEL "com.github.actions.description"="Automatically Cherry Pick PR on '/cherry-pick <target>' comment"
LABEL "com.github.actions.icon"="git-pull-request"
LABEL "com.github.actions.color"="purple"

RUN apk --no-cache add jq bash curl git git-lfs github-cli

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
