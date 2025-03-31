terraform {
  backend "gcs" {
    bucket  = "pe-idp-1-tfstate"
    prefix  = "terraform/state"
  }
}