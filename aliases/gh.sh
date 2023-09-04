gh::pr_to_md() {
  pr_link=$1
  gh_host=$(echo "${pr_link}" | awk -F'/' '{print $3}')
  pr_path=$(echo "${pr_link}" | awk -F'/' '{print "repos/"$4"/"$5"/pulls/"$7}')
  pr_num=$(echo "${pr_link}" | awk -F'/' '{print $7}')
  gh_repo=$(echo "${pr_link}" | awk -F'/' '{print $4"/"$5}')

  # Api docs: https://docs.github.com/en/free-pro-team@latest/rest/pulls/pulls?apiVersion=2022-11-28#get-a-pull-request
  pr_title=$(GH_HOST="${gh_host}" gh api "${pr_path}" --jq '.title')
  echo "[${gh_repo}#${pr_num}](${pr_link}): ${pr_title}"
  echo "[${gh_repo}#${pr_num}](${pr_link}): ${pr_title}" | pbcopy
}
