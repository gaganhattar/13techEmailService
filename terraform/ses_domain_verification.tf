provider "aws" {
  region = "us-east-1"
}

resource "aws_ses_domain_identity" "domain" {
  domain = "13techs.com"
}

resource "aws_ses_domain_dkim" "dkim" {
  domain = aws_ses_domain_identity.domain.id
}

resource "aws_route53_record" "dkim" {
  for_each = {
    for dkim in aws_ses_domain_dkim.dkim_tokens :
    dkim => dkim
  }
  zone_id = aws_route53_zone.main.zone_id
  name    = "${each.key}._domainkey.13techs.com"
  type    = "CNAME"
  ttl     = 300
  records = [each.value]
}

resource "aws_route53_record" "ses_verification" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "_amazonses.13techs.com"
  type    = "TXT"
  ttl     = 300
  records = [aws_ses_domain_identity.domain.verification_token]
}


output "domain" {
  value = aws_ses_domain_identity.domain.domain
}
