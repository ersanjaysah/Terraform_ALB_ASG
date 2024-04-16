# Create a launch template
resource "aws_launch_template" "myLaunchTP" {
  name_prefix            = "asg-launch-template"
  image_id               = "ami-0914547665e6a707c" # Replace with your desired AMI ID
  instance_type          = "t3.micro"
  key_name               = "murlikey"               # Replace with your key pair name
  vpc_security_group_ids = ["sg-0eab5703bd414ff4a"] # Replace with your security group ID

  # Configure instance storage
  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 20
    }
  }

  # Configure instance monitoring
  monitoring {
    enabled = true
  }

  # Configure instance placement
  placement {
    availability_zone = "eu-north-1a" # Replace with your desired Availability Zone
  }

  # Configure instance user data
  user_data = filebase64("ec2-init.sh") # Provide a userdata script

  # Configure instance tags
  tags = {
    Name        = "asg_launch-template"
    Environment = "production"
  }
}


resource "aws_autoscaling_group" "myasg" {
  name             = "my-asg"
  min_size         = 1
  desired_capacity = 2
  max_size         = 4

  vpc_zone_identifier = ["subnet-0f080ef2f97c4938e", "subnet-09f7bc1b7fdf84943", "subnet-05bbc4ce3965a1197"] # Replace with your subnet IDs

  launch_template {
    id = aws_launch_template.myLaunchTP.id
    //version = "$Latest"
    version = aws_launch_template.myLaunchTP.latest_version
  }

  health_check_type = "ELB"

  # Configure instance tags
  tag {
    key                 = "Environment"
    value               = "production"
    propagate_at_launch = true
  }
}


resource "aws_autoscaling_attachment" "example" {
  autoscaling_group_name = aws_autoscaling_group.myasg.id
  lb_target_group_arn    = aws_lb_target_group.mytg.arn //coming from targetgp.tf file
}
