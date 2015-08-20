# Bash start-up file, created by chaplocal
# Used only for development.

export PROMPT_DIRTRIM=2
cd $APPS_DIR

# I typically work in the Emacs process buffer.  Your mileage may vary
if [ "$EMACS" == "t" ]; then
  stty -echo
  alias ls='ls --color=never'
fi

alias apps="cd $APPS_DIR"
alias NE="stty -echo"

export PATH=$JAVA_HOME/bin:$PATH
