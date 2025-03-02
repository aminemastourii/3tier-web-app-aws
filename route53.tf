# read hosted zone details
data "aws_route53_zone" "hosted_zone" {
  name = "aminemastouri.click"
}

# create A-record for the site domain  in route 53
resource "aws_route53_record" "site_domain" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = "guessthenumber" # this will be added to the domain.
                            #  now its gonna be "guessthenumber.aminemastouri.clik"
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}
resource "aws_route53_record" "cert_validation" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = "_d6dd5605fe44c2c40a34e9949325c59f.aminemastouri.click"
  type    = "CNAME"
  ttl     = 60
  records = ["_8be3342ad5790f9ce0c3230ad33eee0e.xlfgrmvvlj.acm-validations.aws."]
}

