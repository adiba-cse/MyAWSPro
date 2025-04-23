resource "aws_iam_user" "the-accounts" {
  for_each = var.setprac
  name     = each.key
}
// Working with import
# import {
#   to = aws_security_group.newtestimp
#   id = "sg-02ce7038ec0563464"
# }
# resource "aws_security_group" "newtestimp" {

# }
//use the following command in the portal
// terraform import aws_security_group.newtestimp sg-02ce7038ec0563464