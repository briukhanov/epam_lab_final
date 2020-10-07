
resource "github_repository_webhook" "biotestmine" {
  repository = "intermine"
  id         = "253428445"
  url        = "https://api.github.com/repos/briukhanov/intermine/hooks/253428445"
  active     = true
  events     = ["push"]

  configuration {
    url          = "http://${aws_instance.docker_instance.public_dns}:8080/github-webhook/"
    content_type = "form"
    insecure_ssl = false
  }
}
