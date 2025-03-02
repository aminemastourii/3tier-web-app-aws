resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-sg.id]
  subnet_mapping {
    subnet_id = aws_subnet.public-subnet-az1.id
  }
  subnet_mapping {
    subnet_id = aws_subnet.public-subnet-az2.id
  }

  enable_deletion_protection = false


 }
#alb target group 
resource "aws_lb_target_group" "alb-tg" {
  name     = "alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.dev.id
  health_check {
    healthy_threshold   = 3
    interval            = 10
    matcher             = "200,301,302"
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}






# http target group on port 80
resource "aws_lb_target_group" "http_tg" {
  name     = "alb-http-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.dev.id
}

# http target group on port 443 
resource "aws_lb_target_group" "https_tg" {
  name     = "alb-https-tg"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = aws_vpc.dev.id
}


# http listener (redirect to https)
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"

    }
  }
}

# http listner (forward to the alb target group )
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08" # Recommended SSL Policy
  #waiting for the domain name creation 
  certificate_arn = aws_acm_certificate.ssl_certificate.arn # Replace with your ACM SSL certificate

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg.arn
  }
}


