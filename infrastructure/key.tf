resource "aws_key_pair" "hackathon-master" {
  key_name = "hackathon-master"
  public_key = "${file("ssh_key_pub")}"
}
