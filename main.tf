############################################
# frontend Security group                 #
############################################

resource "aws_security_group" "frontend" {
  name        = "${var.project_name}-${var.project_env}-frontend"
  description = "${var.project_name}-${var.project_env}-frontend"

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    "Name" = "${var.project_name}-${var.project_env}-frontend"
  }
}

#################################
# Launch template for LB        #
#################################

resource "aws_launch_template" "Auto_scaling_template" {
  name = var.project_name
  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 10
    }
  }

  image_id               = data.aws_ami.shopping_ami.id
  instance_type          = var.instance_type
  key_name               = "morning-keypair"
  vpc_security_group_ids = [aws_security_group.frontend.id]

}

####################################
# Auto scaling group for LB        #
####################################

resource "aws_autoscaling_group" "Auto_scaling_grp" {
  availability_zones = ["ap-south-1a", "ap-south-1b"]
  desired_capacity   = 2
  max_size           = 3
  min_size           = 1
  load_balancers = [
    "${aws_elb.web_elb.id}"
  ]
  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }

  launch_template {
    id = aws_launch_template.Auto_scaling_template.id
  }
}

##############################
# Target group for LB        #
##############################

resource "aws_lb_target_group" "web_tg" {
  name        = "${var.project_name}-${var.project_env}-TG"
  target_type = "alb"
  port        = 80
  protocol    = "TCP"
  vpc_id      = "vpc-0b854d8eefb150436"
}

########################
# classic LB           #
########################

resource "aws_elb" "web_elb" {
  name = "web-elb"
  security_groups = [
    "${aws_security_group.frontend.id}"
  ]
  subnets = [
    "subnet-0356826dddc04e5d6",
    "subnet-06ead9a219a5367a1"
  ]
  cross_zone_load_balancing = true
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:80/"
  }

  listener {          
    lb_port            = 443
    lb_protocol        = "https"
    instance_port      = "80"
    instance_protocol  = "http"
    ssl_certificate_id = aws_acm_certificate.mario.arn
  }


}


###################################
# load balancer attachment        #
###################################

resource "aws_autoscaling_attachment" "zomato" {
  autoscaling_group_name = aws_autoscaling_group.Auto_scaling_grp.id
  elb                    = aws_elb.web_elb.id
}

###################################
# add dns record for mario        #
###################################

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.zone-details.id
  name    = "${var.hostname}.${var.hosted_zone_name}"
  type    = "A"

  alias {
    name                   = aws_elb.web_elb.dns_name
    zone_id                = aws_elb.web_elb.zone_id
    evaluate_target_health = true
  }
}

#########################
# SSL for mario         #
#########################

resource "aws_acm_certificate" "mario" {
  domain_name       = "${var.hostname}.${var.hosted_zone_name}"
  validation_method = "DNS"
}

resource "aws_route53_record" "mario" {
  for_each = {
    for dvo in aws_acm_certificate.mario.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.zone-details.id
}

resource "aws_acm_certificate_validation" "mario" {
  certificate_arn         = aws_acm_certificate.mario.arn
  validation_record_fqdns = [for record in aws_route53_record.mario : record.fqdn]
}
