resource "aws_ecr_repository" "lampserver" {
  name                 = "lampserver"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
