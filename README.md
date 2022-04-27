# GitHub action to automatically cherry-pick PRs

> This project was inspired by [cirrus-actions/rebase](https://github.com/cirrus-actions/rebase) and started as a fork of rebase project.

<img width="709" alt="CleanShot 2022-04-26 at 19 12 22@2x" src="https://user-images.githubusercontent.com/707561/165401173-18c1593d-d40f-4e02-abe8-0879c4558cd1.png">

# Installation

To configure the action simply add the following lines to your `.github/workflows/comment-cherry-pick.yml` workflow file:

```yaml
name: Cherry Pick On Comment
on:
  issue_comment:
    types: [created]
jobs:
  cherry-pick:
    name: Cherry Pick
    if: github.event.issue.pull_request != '' && contains(github.event.comment.body, '/cherry-pick')
    runs-on: ubuntu-latest
    steps:
      - name: Checkout the latest code
        uses: actions/checkout@v2
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          fetch-depth: 0 # otherwise, you will fail to push refs to dest repo
      - name: Automatic Cherry Pick
        uses: vendoo/gha-cherry-pick@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```


After installation simply comment `/cherry-pick <target_branch>` to trigger the action:


> NOTE: To ensure GitHub Actions is automatically re-run after a successful cherry-pick action use a [Personal Access Token](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token) for `actions/checkout@v2` and `vendoo/cherry-pick@v1`. See the following [discussion](https://github.community/t/triggering-a-new-workflow-from-another-workflow/16250/37) for more details.

Example

```yaml

...
    - name: Checkout the latest code
      uses: actions/checkout@v2
      with:
        token: ${{ secrets.PAT_TOKEN }}
        fetch-depth: 0 # otherwise, you will fail to push refs to dest repo
    - name: Automatic Cherry Pick
      uses: vendoo/gha-cherry-pick@v1
      env:
        GITHUB_TOKEN: ${{ secrets.PAT_TOKEN }}
```

You can also optionally specify the PR number of the branch to cherry-pick,
if the action you're running doesn't directly refer to a specific
pull request:

```yaml
    - name: Automatic Cherry Pick
      uses: vendoo/gha-cherry-pick@v1
      env:
        GITHUB_TOKEN: ${{ secrets.PAT_TOKEN }}
        PR_NUMBER: 1245
```


## Restricting who can call the action

It's possible to use `author_association` field of a comment to restrict who can call the action and skip the cherry-pick for others. Simply add the following expression to the `if` statement in your workflow file: `github.event.comment.author_association == 'MEMBER'`. See [documentation](https://developer.github.com/v4/enum/commentauthorassociation/) for a list of all available values of `author_association`.
