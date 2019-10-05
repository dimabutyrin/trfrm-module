# %YAML

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

data "aws_ami" "latest-ubuntu" {
most_recent = true
owners = ["099720109477"] # Canonical

  filter {
      name   = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
      name   = "virtualization-type"
      values = ["hvm"]
  }
}

resource "aws_security_group" "test-instance" {
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_spot_instance_request" "vm_micro" {
  ami = "${data.aws_ami.latest-ubuntu.id}"
  instance_type = "t2.micro"
  spot_price = "0.003"
  tags = {
      Name = "trfm-module-vm-test"
      Environment = "Development"
  }
  user_data = "${file("./user-data.sh")}"
  vpc_security_group_ids = ["${aws_security_group.test-instance.id}"]
}

resource "aws_ebs_volume" "data" {
  availability_zone = "${aws_spot_instance_request.vm_micro.availability_zone}"
  size = 1
  tags = {
    Snapshot = "true"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.data.id}"
  instance_id = "${aws_spot_instance_request.vm_micro.id}"
}
