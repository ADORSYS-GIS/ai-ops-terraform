locals {
  namespace        = coalesce(var.namespace, "librechat")
  creds_secret     = coalesce(var.creds_secret, "${local.namespace}-creds-env")
  meili_master_key = coalesce(var.meili_master_key, random_string.meilisearch_secret.result)
  tags             = merge({}, var.tags)
}
