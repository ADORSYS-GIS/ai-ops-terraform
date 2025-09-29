output "image_pipeline_arn" {
  description = "The ARN of the EC2 Image Builder pipeline."
  value       = aws_imagebuilder_image_pipeline.this.arn
}

output "ami_id" {
  description = "The ID of the latest custom AMI."
  value       = data.aws_ami.latest_custom_ami.id
}
