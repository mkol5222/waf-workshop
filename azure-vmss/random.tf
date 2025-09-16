# random 6 digit number
resource "random_id" "waf" {
  byte_length = 4
}