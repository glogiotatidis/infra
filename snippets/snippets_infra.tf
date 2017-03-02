provider "aws" {
  region = "${var.region}"
}

resource "aws_elasticache_cluster" "snippets-redis" {
  cluster_id = "snippets-redis"
  engine = "redis"
  node_type = "${var.cache-node-size}"
  port = "${var.cache-port}"
  num_cache_nodes = "${var.cache-num-nodes}"
  parameter_group_name = "${var.cache-param-group}"
}
