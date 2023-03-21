output "eck_username" {
  description = "ECK Username"
  value       = "elastic"
}

output "eck_password" {
  description = "ECK Password"
  value       = nonsensitive(data.kubernetes_secret.eck_secret.data["elastic"])
}
