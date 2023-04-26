output "eck" {
  description = "ECK_Info"
  value = {
    username = "elastic",
    password = nonsensitive(data.kubernetes_secret.eck_secret.data["elastic"]),
    url      = var.eck_config.hostname,
  }
}
