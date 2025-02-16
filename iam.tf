# Create (4) IAM users: Adam, Devin, Audrey, and Seth
resource "aws_iam_user" "admin_user" {
  name = "Adam"
  path = "/admin/"
}

resource "aws_iam_user" "dev_user" {
  name = "Devin"
  path = "/dev/"
}

resource "aws_iam_user" "audit_user" {
  name = "Audrey"
  path = "/audit/"
}

resource "aws_iam_user" "security_user" {
  name = "Seth"
  path = "/security/"
}

# Create (4) IAM groups: Admin, Dev, Audit, and Security
resource "aws_iam_group" "admin_group" {
  name = "Admin"
  path = "/admin/"
}

resource "aws_iam_group" "dev_group" {
  name = "Dev"
  path = "/dev/"
}

resource "aws_iam_group" "audit_group" {
  name = "Audit"
  path = "/audit/"
}

resource "aws_iam_group" "security_group" {
  name = "Security"
  path = "/security/"
}

# Associate IAM users with IAM groups
resource "aws_iam_group_membership" "admin_team" {
  name  = "admin-team-membership"
  users = [aws_iam_user.admin_user.name]
  group = aws_iam_group.admin_group.name
}

resource "aws_iam_group_membership" "dev_team" {
  name  = "dev-group-membership"
  users = [aws_iam_user.dev_user.name]
  group = aws_iam_group.dev_group.name
}

resource "aws_iam_group_membership" "audit_team" {
  name  = "audit-team-membership"
  users = [aws_iam_user.audit_user.name]
  group = aws_iam_group.audit_group.name
}

resource "aws_iam_group_membership" "security_team" {
  name  = "security-team-membership"
  users = [aws_iam_user.security_user.name]
  group = aws_iam_group.security_group.name
}

# Assign IAM Group Policies

## Assign IAM Group Policies to Admin Group
resource "aws_iam_group_policy_attachment" "admin_policy" {
  group      = aws_iam_group.admin_group.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

## Assign IAM Group Policies to Dev Group
resource "aws_iam_group_policy_attachment" "power_user_policy" {
  group      = aws_iam_group.dev_group.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_group_policy_attachment" "ec2_full_access_policy" {
  group      = aws_iam_group.dev_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_group_policy_attachment" "lambda_full_access_policy" {
  group      = aws_iam_group.dev_group.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
}

resource "aws_iam_group_policy_attachment" "s3_full_access_policy" {
  group      = aws_iam_group.dev_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_group_policy_attachment" "cloudwatch_full_policy" {
  group      = aws_iam_group.dev_group.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

## Assign IAM Group Policies to Audit Group
resource "aws_iam_group_policy_attachment" "read_only_policy" {
  group      = aws_iam_group.audit_group.name
  policy_arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
}

resource "aws_iam_group_policy_attachment" "cloutrail_read_policy" {
  group      = aws_iam_group.audit_group.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCloudTrail_ReadOnlyAccess"
}

resource "aws_iam_group_policy_attachment" "sec_audit_policy" {
  group      = aws_iam_group.audit_group.name
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}

## Assign IAM Group Policies to Security Group
resource "aws_iam_group_policy_attachment" "sec_audit_policy2" {
  group      = aws_iam_group.security_group.name
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}

resource "aws_iam_group_policy_attachment" "guardduty_full_policy" {
  group      = aws_iam_group.security_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonGuardDutyFullAccess"
}

resource "aws_iam_group_policy_attachment" "sec_hub_full_policy" {
  group      = aws_iam_group.security_group.name
  policy_arn = "arn:aws:iam::aws:policy/AWSSecurityHubFullAccess"
}

resource "aws_iam_group_policy_attachment" "ir_full_policy" {
  group      = aws_iam_group.security_group.name
  policy_arn = "arn:aws:iam::aws:policy/AWSSecurityIncidentResponseFullAccess"
}

resource "aws_iam_group_policy_attachment" "iam_full_access_policy2" {
  group      = aws_iam_group.security_group.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

resource "aws_iam_group_policy_attachment" "inspector_full_policy" {
  group      = aws_iam_group.security_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonInspectorFullAccess"
}