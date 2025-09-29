output "interruption_queue_name" {
  description = "The name of the SQS queue created for interruption handling."
  value       = module.karpenter.queue_name
}