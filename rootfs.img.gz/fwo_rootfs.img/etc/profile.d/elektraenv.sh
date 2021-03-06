#!/bin/sh

###########################################################################
##
## This is a /etc/profile.d script to set user environment and aliases
## based on Elektra keys under 'user/env'.
##
## Bellow user/env there must be three priorities for environment
## variables:
##
##     user/env/env1
##     user/env/env2
##     user/env/env3
##
## You should distribute your environment variables according to their
## dependencies. For example, if we want to
## set PATH as $JAVA_HOME/bin:$PATH, we'll have to set
##
##     user/env/env1/JAVA_HOME
##     user/env/env2/PATH
##
## This way it is guaranteed that the variables under user/env/env1 are
## set before those under user/env/env2, and before those under
## user/env/env3
##
## The folder user/env/alias contains keys to define shell aliases.
## For instance user/env/alias/ls may contain 'ls -Fh', to set an alias
## to the 'ls' command.
##
## Avi Alkalay <avi at unix dot sh>
## April 2004
##
## $Id$
##
###########################################################################


if [ -z "$KDB" ]; then
	KDB=kdb
fi

FILE="`mktemp -t elektraenv.XXXXXXXXX`"


readEnvTree() {
	local keysAvailable=0
	local stage=0
	local key

	for stage in 1 2 3; do
		echo "# Stage $stage"
		$KDB ls $1/env$stage 2>/dev/null | while read key; do
			if [ -z $keysAvailable ]; then
				keysAvailable=1
				echo "echo Setting environment from the Elektra key database under '$1'"
			fi
			# This stuff is so complicated, with sed etc, because
			# we need to superescape a '\$' for envs like PS1
			echo -n "export "
			$KDB get -s $key | sed -e 's/\([^\\]\)\\\$/\1\\\\\$/g;'
		done
	done

	echo
	echo "# Aliases"
	$KDB ls $1/alias 2>/dev/null | while read key; do
		echo alias `$KDB get -s $key`
	done
}



########################
##
##  Main block
##

# set -vx

readEnvTree system/env > $FILE
(echo; echo; echo) >> $FILE
readEnvTree user:$USER/env >> $FILE

# Execute it
[ -f $FILE ] && . $FILE

# Remove it
[ -f $FILE ] && rm -f $FILE

# Clean temporary environment
unset readEnvTree
unset FILE
unset KDB

