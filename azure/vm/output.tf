output "ip_address" {
  description = "IP address of our new instance"
  value       = azurerm_linux_virtual_machine.myterraformvm.public_ip_addresses
}