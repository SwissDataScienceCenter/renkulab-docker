
# Setup git user
if [[ -z "$(git config --global --get user.name)" && -v GIT_AUTHOR_NAME ]]; then
    git config --global user.name "$GIT_AUTHOR_NAME"
fi
if [[ -z "$(git config --global --get user.email)" && -v EMAIL ]]; then
    git config --global user.email "$EMAIL"
fi
