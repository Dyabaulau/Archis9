resource "aws_instance" "mongo_server_primary" {
  ami                         = "ami-02b01316e6e3496d9"
  instance_type               = "t2.micro"
  key_name                    = ""
  vpc_security_group_ids      = [aws_security_group.back.id]
  associate_public_ip_address = true

  user_data = filebase64("${path.root}/deployment_scripts/database.sh")
}
