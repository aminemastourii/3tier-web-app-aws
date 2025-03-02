resource "aws_acm_certificate" "ssl_certificate" {
  domain_name       = "aminemastouri.click"
  validation_method = "DNS"

  tags = {
    Name = "acm-cert"
  }
}