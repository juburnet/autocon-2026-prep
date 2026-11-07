# -*- coding: utf-8 -*-

# Copyright: (c) 2023, Daniel Schmidt <danischm@cisco.com>

# Expects the following environment variables:
# - GITLAB_TOKEN
# - CI_API_V4_URL
# - CI_PROJECT_ID
# - CI_MERGE_REQUEST_IID
# - CI_SERVER_TLS_CA_FILE (set by the runner when GitLab uses a private CA)

import json
import os
import requests
import sys

def main():
    if os.getenv("CI_MERGE_REQUEST_IID") in ["", None]:
        return
    with open("./plan.txt", "r") as in_file:
        plan = in_file.read()
    message = "<details><summary>Terraform Plan</summary>\n\n```terraform\n"
    message += plan
    message += "\n```\n</details>\n"

    body = {"body": message}
    headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer {}".format(os.getenv("GITLAB_TOKEN")),
    }
    url = "{}/projects/{}/merge_requests/{}/notes".format(
        os.getenv("CI_API_V4_URL"),
        os.getenv("CI_PROJECT_ID"),
        os.getenv("CI_MERGE_REQUEST_IID"),
    )
    resp = requests.post(
        url,
        headers=headers,
        data=json.dumps(body),
        verify=os.getenv("CI_SERVER_TLS_CA_FILE") or True  # lab CA provided by the runner
    )
    if resp.status_code not in [200, 201]:
        print(f"Adding GitLab comment failed, status code: {resp.status_code}, "
              f"response: {resp.text}.")

if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"Adding GitLab comment failed, error: {e}.")
        sys.exit(0)  # do not fail the pipeline because of comment issues
