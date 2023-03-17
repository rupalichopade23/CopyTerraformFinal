## Instance Prifile
resource "aws_iam_instance_profile" "iamprofile" {
  name = "ec2profile"
  role = aws_iam_role.iamrole.name
}
## IAM Role
resource "aws_iam_role" "iamrole" {
  name               = "ssmrole"
  description        = "The role for the EC2"
  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": {
"Effect": "Allow",
"Principal": {"Service": "ec2.amazonaws.com"},
"Action": "sts:AssumeRole"
}
}
EOF
  tags = {
    stack = "test"
  }
}
resource "aws_iam_role_policy_attachment" "ssmpolicy" {
  role       = aws_iam_role.iamrole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
## Key Pair

resource "tls_private_key" "rsa1" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "TFkey" {
  key_name   = "TFkey"
  public_key = tls_private_key.rsa1.public_key_openssh
}
resource "local_file" "TFK" {
  content  = tls_private_key.rsa1.private_key_pem
  filename = "tfkey1"
}
# ## Launch Template for Autoscaling group
resource "aws_launch_template" "LaunchTemplate1" {
  image_id               = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.asgsg]
  key_name               = "TFkey"
  iam_instance_profile {
    name = aws_iam_instance_profile.iamprofile.name
  }
}


# ## Autoscaling group
resource "aws_autoscaling_group" "ASG" {
  desired_capacity = 2
  max_size         = 3
  min_size         = 1
  #launch_configuration = aws_launch_configuration.LaunchConfig.name
  launch_template {
    id      = aws_launch_template.LaunchTemplate1.id
    version = "$Latest"
  }
  vpc_zone_identifier = var.pri_sub_web
  target_group_arns   = [var.tgarn]
}
