data "aws_iam_policy_document" "ec2" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "ec2" {
  assume_role_policy = data.aws_iam_policy_document.ec2.json
  name               = "${var.name}-role"
}

resource "aws_iam_role_policy_attachment" "ec2" {
  role       = aws_iam_role.ec2.name
  policy_arn = var.policy_arn != "" ? var.policy_arn : aws_iam_policy.policy.arn
}

resource "aws_iam_policy" "policy" {
  name        = "${var.name}-instance-policy"
  description = "Policy used by the instance"

  policy = file("${path.module}/templates/policy.json")
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.ec2.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_instance_profile" "ec2" {
  name = "${var.name}-instance-profile"
  role = aws_iam_role.ec2.name
}
