# otf-iac-aws-iam
OpenTofu IAM Management


This repository contains Terraform configurations for managing IAM users, policies, groups, and roles in AWS. Below are the definitions for each section, including the expected structure for YAML and JSON files.

## Table of Contents

- [IAM Users](#iam-users)
- [IAM Policies](#iam-policies)
- [IAM Groups](#iam-groups)
- [IAM Roles](#iam-roles)

## IAM Users

### YAML Structure

Create a directory named `resources/users` and define user information in separate YAML files. Each file should contain user properties.

**Example: `resources/users/user1.yaml`**

```yaml
user1:
  create_user: true
  email: user1@example.com
```
Other Options
```yaml
user1:
    ...
    create_iam_access_key: true
    create_iam_user_login_profile: true
    create_user: true
    force_destroy: false
    iam_access_key_status: null
    password_length: 20
    password_reset_required: true
    path: "/"
    permissions_boundary: ""
    pgp_key: ""
    policy_arns:
    - "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
    tags:
      company: example.com
      dept: devops
```

| Inputs                      | Description                                    | Required | Default |
|-----------------------------|------------------------------------------------|----------|---------|
| create_user                 | Flag for creating the user resource            | true     | true    |
| create_iam_access_key       | Flag to create an IAM access key               | false    | false   |
| create_iam_user_login_profile| Flag to create a login profile for the user   | false    | true    |
| force_destroy                | Flag to forcefully delete the user             | false    | false   |
| iam_access_key_status        | Status of the IAM access key                   | false    | null    |
| password_length              | Length of the user password                    | false    | 20      |
| password_reset_required      | Flag indicating if password reset is required  | false    | true    |
| path                         | Path for the IAM user                          | false    | "/"     |
| permissions_boundary         | ARN for the permissions boundary                | false    | ""      |
| pgp_key                     | PGP key for IAM user                           | false    | ""      |
| policy_arns                 | List of policy ARNs attached to the user       | false    | []      |
| tags                        | Key-value pairs for tagging the user           | false    | {}      |



## IAM Policies

### YAML Structure

Under the directory named `resources/policies` and define policy information in separate YAML files. Each file should contain policy properties.

**Example: `resources/policies/policy1.yaml`**

```yaml
policy1:
  create_policy: true
  description: "This is a sample policy."
```

Other Options
```yaml
policy1:
    ...
    create_policy: true
    description: "This is a sample policy."
    name_prefix: "sample-"
    path: "/"
    tags:
      company: example.com
      dept: devops
```

| Inputs              | Description                                    | Required | Default |
|---------------------|------------------------------------------------|----------|---------|
| create_policy       | Flag for creating the IAM policy               | true     | true    |
| description         | Description of the policy                      | false    | "Custom IAM Policy" |
| name_prefix         | Prefix for the policy name                     | false    | null    |
| path                | Path for the IAM policy                        | false    | "/"     |
| tags                | Key-value pairs for tagging the policy         | false    | {}      |

### Json Structure
Under the directory named `resources/policies/json` and define json policy file.

**Example: `resources/groups/policy1.json`**

```json
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:ListAllMyBuckets",
          "s3:ListBucket"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:ListBucketVersions"
        ],
        "Resource": [
          "arn:aws:s3:::*",
          "arn:aws:s3:::*/*"
        ]
      }
    ]
}
  
```

Here’s the section for IAM Groups, formatted with the table wrapped in Markdown code blocks:

## IAM Groups

### YAML Structure

Create a directory named `resources/groups` and define group information in separate YAML files. Each file should contain group properties.

**Example: `resources/groups/group1.yaml`**

```yaml
group1:
  create_group: true
  users:
    - "user1"
    - "user2"
```

Other Options
```yaml
group1:
    ...
    create_group: true
    custom_group_policy_arns:
      - "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
    users:
      - "user1"
      - "user2"
    policies:
      - "policy1"
    tags:
      company: example.com
      dept: devops
```

| Inputs                       | Description                                      | Required | Default |
|------------------------------|--------------------------------------------------|----------|---------|
| create_group                 | Flag for creating the IAM group                  | true     | true    |
| custom_group_policy_arns     | List of policy ARNs attached to the group        | false    | []      |
| users                        | List of users in the group                       | false    | []      |
| policies                     | List of policy names attached to the group       | false    | []      |
| tags                         | Key-value pairs for tagging the group            | false    | {}      |


## IAM Roles

### JSON Structure

Create a directory named `resources/roles/json` and define each role's assume role policy in JSON files.

**Example: `resources/roles/json/role1.json`**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::123456789012:role/service-role/MyServiceRole"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```


### YAML Structure

Create a directory named `resources/roles` and define role information in separate YAML files. Each file should contain role properties.

**Example: `resources/roles/role1.yaml`**

```yaml
role1:
  create_role: true
  description: "This is a test role."
```

Other Options
```yaml
role1:
    ...
    create_role: true
    description: "This is a test role."
    inline_policies:
      policy1:
        Version: "2012-10-17"
        Statement:
          - Effect: "Allow"
            Action: "s3:ListBucket"
            Resource: "*"
    managed_policy_arns:
      - "arn:aws:iam::aws:policy/AWSLambdaBasicExecutionRole"
    permissions_boundary: ""
    force_detach_policies: false
    max_session_duration: 3600
    tags:
      company: example.com
      dept: devops
```

| Inputs                      | Description                                       | Required | Default |
|-----------------------------|---------------------------------------------------|----------|---------|
| create_role                 | Flag for creating the IAM role                    | true     | true    |
| description                 | Description of the IAM role                       | false    | ""      |
| inline_policies             | Inline policies for the role                      | false    | {}      |
| managed_policy_arns         | List of managed policy ARNs attached to the role  | false    | []      |
| permissions_boundary         | ARN for the permissions boundary                   | false    | ""      |
| force_detach_policies       | Flag to force detach policies when deleting the role| false    | false   |
| max_session_duration        | Maximum duration for the role session in seconds  | false    | 3600    |
| tags                        | Key-value pairs for tagging the role              | false    | {}      |
