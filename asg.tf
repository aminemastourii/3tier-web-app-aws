resource "aws_iam_role" "ec2-readS3" {
  
  name = "ec2-readonly-s3"

  
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*",
                "s3:Describe*",
                "s3-object-lambda:Get*",
                "s3-object-lambda:List*"
            ],
            "Resource": "*"
        }
    ]
})

}


resource "aws_iam_instance_profile" "instance-asg" {
  name = "server-profile"
  role = aws_iam_role.ec2-readS3.name
}








resource "aws_launch_template" "asg-lt" {
  name          = "asg-launch-template"
  image_id      = "ami-04b4f1a9cf54c11d0"
  instance_type = "t2.micro"

  description   = "ASG Launch template"
  monitoring {
    enabled = true
  }
  vpc_security_group_ids = [aws_security_group.asg-sg.id]
  #installing LAMP stack on the ec2 instances 
  user_data = base64encode(<<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl enable httpd
              sudo systemctl start httpd

              sudo yum install -y \
              php \
              php-pdo \
              php-openssl \
              php-mbstring \
              php-exif \
              php-fileinfo \
              php-xml \
              php-ctype \
              php-json \
              php-tokenizer \
              php-curl \
              php-cli \
              php-fpm \
              php-mysqlnd \
              php-bcmath \
              php-gd \
              php-cgi \
              php-gettext \
              php-intl \
              php-zip

              sudo wget https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm
              sudo dnf install -y mysql80-community-release-el9-1.noarch.rpm
              sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2023
              sudo dnf install -y mysql-community-server
              sudo systemctl start mysqld
              sudo systemctl enable mysqld

              sudo sed -i '/<Directory "\\/var\\/www\\/html">/,/<\\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/httpd/conf/httpd.conf

              # Install aws-cli if not already installed
              sudo yum install -y aws-cli

              # Download and unzip the application code from S3
              aws s3 cp s3://zipped-guessthenumber/GuessTheNumber.zip /var/www/html/GuessTheNumber.zip
              sudo unzip /var/www/html/GuessTheNumber.zip -d /var/www/html/
              sudo rm -rf /var/www/html/GuessTheNumber.zip
              sudo chmod -R 777 /var/www/html
              sudo chmod -R 777 /var/www/html/storage/

              sudo service httpd restart
              EOF
)
}


resource "aws_autoscaling_group" "asg" {
  name                      = "asg-servers"
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  vpc_zone_identifier       = [aws_subnet.private-subnet-server-az1.id, aws_subnet.private-subnet-server-az2.id]
  launch_template {
    id      = aws_launch_template.asg-lt.id
    version = "$Latest"
  }
  tag {
    key                 = "asg"
    value               = "asg-servers"
    propagate_at_launch = true
  }

#   lifecycle {
#     ignore_changes      = [target_group_arns]         we need this argument to prevent recreation of the asg
#   }                                                   in case the target groups changed , but since we are using
#                                                       an attachement resource for the asg and tg , we do not need it .

}
    # separate ASG-ALB attachment
resource "aws_autoscaling_attachment" "asg-alb-tg-attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg.id
  lb_target_group_arn    = aws_lb_target_group.alb-tg.arn
}