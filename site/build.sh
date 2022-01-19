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

zola build 2>&1 > LOG_build

ZOLA_STATE="$?"

if [ "$ZOLA_STATE" -eq 0 ] ; then
	# Success
	echo good
	slack_msg 'Build live @ http://orakulum.j2m.cz'

	# push to webserver
	[ -e "TARGET_WWW_DIR" ] && {
		# we need to do this in order to swap the dirs atomically

		THIS_BUILD="$(cat TARGET_WWW_DIR)/public-$GIT_LAST_COMMIT"
		TARGET_SYMLINK="$(cat TARGET_WWW_DIR)/www-public"
		NEW_SYMLINK="$(cat TARGET_WWW_DIR)/www-public-new"
		OLD_BUILD="$(readlink "$TARGET_SYMLINK")"

		rm -rf "$THIS_BUILD"
		mv public "$THIS_BUILD"
		ln -s "$THIS_BUILD" "$NEW_SYMLINK"

		# atomically swap new symlink for the oldone
		mv -T "$NEW_SYMLINK" "$TARGET_SYMLINK"

		[ "$OLD_BUILD" != "$THIS_BUILD" ] && {
			echo rm old build "$OLD_BUILD"
			rm -rf "$OLD_BUILD"
		}
	}
else
	# Error
	echo err

	slack_msg "\n$( cat LOG_build | grep -v 'Building site' )"
fi

echo $GIT_LAST_COMMIT > LAST_COMMIT

