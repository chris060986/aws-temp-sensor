provider "aws" {
  region = "eu-central-1"
}

resource "aws_iot_thing" "example" {
  name = "first_test"
  attributes {
    First = "temp"
  }
}
