import sys, os
import openai
from github import Github

# Inputs from GitHub Action
issue_title = sys.argv[1]
issue_body = sys.argv[2]

user_prompt = f"User requested VM:\nTitle: {issue_title}\nBody: {issue_body}\n\nConvert this into a new Terraform variable block (HCL) that can be appended to terraform.tfvars."

# Call OpenAI
openai.api_key = os.getenv("OPENAI_API_KEY")

response = openai.chat.completions.create(
    model="gpt-4o-mini",
    messages=[
        {"role": "system", "content": "You are an assistant that updates terraform.tfvars with new VM entries in HCL."},
        {"role": "user", "content": user_prompt}
    ]
)

new_vm_block = response.choices[0].message.content.strip()

# GitHub Repo
g = Github(os.getenv("GITHUB_TOKEN"))
repo = g.get_repo(os.getenv("GITHUB_REPOSITORY"))

file = repo.get_contents("terraform.tfvars", ref="main")
updated_content = file.decoded_content.decode() + f"\n{new_vm_block}\n"

branch_name = f"openai-vm-{issue_title.lower().replace(' ', '-')}"
repo.create_git_ref(ref=f"refs/heads/{branch_name}", sha=repo.get_branch("main").commit.sha)
repo.update_file("terraform.tfvars", f"Add VM from OpenAI: {issue_title}", updated_content, file.sha, branch=branch_name)
repo.create_pull(
    title=f"Add VM: {issue_title}",
    body=f"Automated update from OpenAI request:\n\n{issue_body}\n\nAdded block:\n```\n{new_vm_block}\n```",
    head=branch_name,
    base="main"
)
