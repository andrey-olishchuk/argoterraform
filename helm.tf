resource "null_resource" "wait_for_cluster" {
  depends_on = []
  provisioner "local-exec" {
    command     = var.wait_for_cluster_cmd
    interpreter = var.wait_for_cluster_interpreter
    environment = {
      ENDPOINT = data.aws_eks_cluster.cluster.endpoint
    }
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  depends_on = [null_resource.wait_for_cluster]
}