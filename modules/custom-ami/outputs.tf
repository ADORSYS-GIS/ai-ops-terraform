output "image_pipeline_arn" {
  description = "The ARN of the EC2 Image Builder pipeline."
  value       = aws_imagebuilder_image_pipeline.this.arn
}
