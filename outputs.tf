# %YAML

output "instance_ip" {
  value = "${aws_spot_instance_request.vm_micro.public_ip}"
  description = "The public IP address of the test vm instance."
}
