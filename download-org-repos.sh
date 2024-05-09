#!/bin/bash

ORG="$1"
DEST_DIR="$2"
GITHUB_API="https://api.github.com"

( mkdir -p "$DEST_DIR" && cd "$DEST_DIR"

repos=$(curl "$GITHUB_API/orgs/$ORG/repos" | jq -r '.[].clone_url')

printf "\nRepositories data recovered"

for repo in $repos; do
  repo_name=$(basename "$repo" .git)
  if [ -d "$repo_name" ]; then
    printf "\nUpdating $repo_name"
    cd "$repo_name"

    git fetch origin master || git fetch origin main
    git checkout master || git checkout main
    git pull
    cd ..
  else
    printf "\nCloning $repo_name"
    git clone "$repo"
  fi
done

printf "\nProcess completed."
)