output "ip_address" {
  description = "IP address of our new instance"
  value       = vsphere_virtual_machine.vm.default_ip_address
}