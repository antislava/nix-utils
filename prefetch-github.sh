# USAGE EXAMPLE:
# env owner=obsidiansystems repo=rhyolite rev=refs/heads/develop <this-file>
# env owner=obsidiansystems repo=rhyolite <this-file>
# env owner=obsidiansystems repo=rhyolite rev=refs/heads/develop uribase=$GIT_LOCAL <this-file>
# env owner=obsidiansystems repo=rhyolite rev=348e96310e62c45ada3e6e69e4bd7b0da1acbf02 uribase=$GIT_LOCAL ./prefetch-github

# TODO: There needs to be some logic around using (and creating and updating...) cache?

export branch=`basename $rev || echo ""`
# uribase=/r-cache/git
# uribase=$GIT_LOCAL
uri=${uribase:-http:/}/github.com/$owner/$repo
# echo $uri

# git --git-dir $uri fetch --all --quiet
# echo $cached
nix-prefetch-git $uri --rev $rev \
  | jq '{ owner:"$owner", repo:"$repo", branch:"$branch", rev, sha256 }' \
  | shab \
  | jq 'with_entries(select(.value != ""))' -r

# ###
# OUT
# jq '{ url: "https://github.com/$(echo $owner/$repo)", owner: "$owner", repo: "$repo", branch: "$branch", rev, sha256 }' \

# Filtering null values: https://github.com/stedolan/jq/wiki/FAQ
# jq 'walk(if type == "object" then with_entries(select(.value != null)) else . end)' -r
