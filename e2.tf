resource "aws_instance" "public" {

    ami = "${var.AMI}"
    instance_type = "t2.micro"

    # VPC
    subnet_id = "${aws_subnet.dev-subnet-public.id}"

    # Security Group
    vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]

    # the Public SSH key
    key_name = "${aws_key_pair.keypair.id}"

    connection {
        user = "${var.ubuntu}"
        private_key = "${file("${var.PRIVATE_KEY_PATH}")}"
    }
}

resource "aws_key_pair" "keypair" {
    key_name = "keypair"
    public_key = "${file(var.PUBLIC_KEY_PATH)}"
}
