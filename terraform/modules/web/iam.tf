#Instance Role
resource "aws_iam_role" "web" {
  name               = "ssm-ec2"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

#Instance Profile
resource "aws_iam_instance_profile" "web" {
  name = "ssm-ec2"
  role = aws_iam_role.web.id
}

#Attach Policies to Instance Role
resource "aws_iam_policy_attachment" "attach1" {
  name       = "test-attachment"
  roles      = [aws_iam_role.web.id]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_policy_attachment" "attach2" {
  name       = "test-attachment"
  roles      = [aws_iam_role.web.id]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}
