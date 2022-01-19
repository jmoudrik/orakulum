#!/bin/sh

git pull

GIT_LAST_COMMIT=$(git rev-parse HEAD)
echo build $GIT_LAST_COMMIT

# do nothing if the work is done for this commit
[ -e LAST_COMMIT -a "$(cat LAST_COMMIT)" = "$GIT_LAST_COMMIT" ] && { echo work done ; return ; }

GIT_INFO=$(git log --pretty=format:'%h - *%an*, %ar : `%s`' | head -n 1)

slack_msg () {
	DATA="{'text':'$GIT_INFO $1'}" 
	echo sending to slack: "$DATA"
	curl -X POST -H 'Content-type: application/json' --data "$DATA" "$(cat SLACK_SECRET)"
}

zola build 2>&1 > LOG_build && {
	# Success
	echo good

	slack_msg 'Build live!'
	# push to webserver

	# TODO
} || {
	# Error
	echo err

	slack_msg "\n$( cat LOG_build | grep -v 'Building site' )"
} 

echo $GIT_LAST_COMMIT > LAST_COMMIT

