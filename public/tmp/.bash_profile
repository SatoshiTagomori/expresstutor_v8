# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

export LINE_CLIENT_ID="1655604727"
export LINE_REDIRECT_URL="https://expresstutor.tokyo/profile"
export LINE_SCOPE="profile openid"
export LINE_SECRET="9bf7eeb456791ccd36b8c775531f9ecf"

export STRIPE_API_KEY="sk_test_51IO2yXHz8Iexb7QlB3PD7lhs16sD6gTrbq7gVvpG5jJiuaCBvoQ6rpnviHnIL5YR0fHW2q7Wg6Lb2dLymFAAQx4R006zDe0lCk"
export STRIPE_API_PUBLIC_KEY="pk_test_51IO2yXHz8Iexb7QllOTPoCp44ZNVFFG9HoXrFI5OChYLWmnOPkcuHGQ1zWiQikRFrcbTjk0thkSPceT4lRVIZ5v100UfdRukPo"


#export SECRET_KEY_BASE="sk_test_51IO2yXHz8Iexb7QlB3PD7lhs16sD6gTrbq7gVvpG5jJiuaCBvoQ6rpnviHnIL5YR0fHW2q7Wg6Lb2dLymFAAQx4R006zDe0lCk"
#export RUBYOPT='-W:no-deprecated -W:no-experimental'
alias udevrestart="sh ~/.unicorn_restart_dev.sh"
alias urestart="sh ~/.unicorn_restart.sh"
alias project="cd /home/gakuto/workspace/expresstutor_v7"

