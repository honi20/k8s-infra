# TLS 프라이빗 키 생성 (공개 키 포함)
resource "tls_private_key" "example" {
    algorithm = "RSA"
    rsa_bits  = 2048
}

# AWS에서 키 페어 생성
resource "aws_key_pair" "ec2_key" {
    key_name   = "ec2-key" # AWS에서 사용할 키 페어 이름
    public_key = tls_private_key.example.public_key_openssh
}

# EC2 인스턴스 생성
resource "aws_instance" "nginx_instance" {
    ami             = "ami-08b09b6acd8d62254" # Amazon Linux 2 AMI (리전별로 AMI ID가 다를 수 있음)
    instance_type   = "t2.micro"
    key_name        = aws_key_pair.ec2_key.key_name # AWS에서 생성한 SSH 키 적용
    security_groups = [aws_security_group.nginx_sg.name]

    # 인스턴스를 다시 만들때 빠르게 교체 하기 위한 옵션
    lifecycle {
        create_before_destroy = true
    }

    # User 데이터 변경시에 인스턴스 재생성 옵션
    user_data_replace_on_change = true

    # EC2 시작 시 Nginx 설치 및 실행을 위한 User Data
    user_data = <<-EOF
                #!/bin/bash
                yum update -y

                # Ruby 설치
                yum install -y ruby wget

                # CodeDeploy Agent 설치
                cd /home/ec2-user
                wget https://aws-codedeploy-ap-northeast-2.s3.ap-northeast-2.amazonaws.com/latest/install
                chmod +x ./install
                ./install auto

                # CodeDeploy Agent 서비스 시작
                systemctl start codedeploy-agent
                systemctl enable codedeploy-agent

                # nginx 설치
                amazon-linux-extras install nginx1 -y
                systemctl start nginx
                systemctl enable nginx
                EOF
    tags = {
      Name = "nginx-server"
      Environment = "Production"
    }
}


# 출력: EC2 인스턴스의 퍼블릭 IP 주소
output "nginx_instance_public_ip" {
    value       = aws_instance.nginx_instance.public_ip
    description = "Public IP of the Nginx EC2 instance"
}

# 출력: SSH 접속에 사용할 Private Key
output "ssh_private_key_pem" {
    value       = tls_private_key.example.private_key_pem
    description = "Private key for SSH access"
    sensitive   = true
}