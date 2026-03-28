locals {
  secrets = yamldecode(file("${path.module}/secrets.yaml"))
}
