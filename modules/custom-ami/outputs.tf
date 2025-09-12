output "image_pipeline_arn" {
  description = "The ARN of the EC2 Image Builder pipeline."
  value       = aws_imagebuilder_image_pipeline.this.arn
}

output "ami_id" {
  description = "The ID of the built AMI."
  value       = try(aws_imagebuilder_image.this.output_resources[0].amis[0].image, null)
}

output "ami_name" {
  description = "The name of the built AMI."
  value       = try(aws_imagebuilder_image.this.output_resources[0].amis[0].name, null)
}
