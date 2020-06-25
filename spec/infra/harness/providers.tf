provider "aws" {
  region = var.region
  version = "~> 2.67"
}

provider "random" {
  version = "~> 2.2"
}

provider "template" {
  version = "~> 2.1"
}
