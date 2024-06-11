resource "aws_key_pair" "vpn" {
  key_name   = "vpn"
  # you can paste the public key directly like this
  #public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCVPzOv0I9Pak9L1PYuC0+HvaSlApVEI3U3MTcuD6xeFWp7DPg5s1fz9cdxR2vCmVn4VjS4yDot1SQK/OY57B6VpDsjOwvRD0Tikxj7bfNEXER6llUpQkro1FWP5W3SBRGtHovehGpHofTL/tgNPLuGVQCLX1loCfjD91rTiMbSkKpBAO652/z+TH8m7bv7WVpYDixWp11Pn2cwf/jVnsqyLpPEuiDICwaPJ54QkA2/kYgt+fGE1deBKqIZstVHGW2ta33WVH1A6uUNrEqUhDf8wqT5cQ3mbYGlGvG3x2BcOGrcTzTa+6WVwSirLoAvlYuS387oYZ1RaAA5bZ2nrgXvg4Ge6E1+bCbFch6sbaK4uQJeqqEEX4Yo4tiue7OyEa+6c0mcRvv9u6Gd7pOrrNI8y9CJ5ECizVLr5CD9pkda5kQk7/t0IRq8UeiP+V/qWMwxyH0OnlFG+ZTq+TAUVP9pRBWVR2cZFbBUg1C3vygYD5FOMxcR+/cvVrkppdDVseE= Sindu@DESKTOP-0VTM1K8"

  public_key = file("~/.ssh/openvpn.pub")
  # ~ means windows home directory
}

module "vpn" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  key_name = aws_key_pair.vpn.key_name
  name = "${var.project_name}-${var.environment}-vpn"

  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
  # convert StringList to list and get first element
  subnet_id = local.public_subnet_id
  ami = data.aws_ami.ami_info.id
  
  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-vpn"
    }
  )
}