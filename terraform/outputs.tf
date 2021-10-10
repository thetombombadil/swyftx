output "lb_dns_name" {
  value = module.web_stack.lb_dns_name
  description = "The DNS record for the loadbalancer in front of the nginx servers."
}
