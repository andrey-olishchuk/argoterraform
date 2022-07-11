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
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  depends_on = [null_resource.wait_for_cluster, kubernetes_namespace.argocd]
}

resource "kubectl_manifest" "argoapp1" {
  depends_on = [helm_release.argocd]
  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: guestbook
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/andrey-olishchuk/argocd-examples
    targetRevision: HEAD
    path: guestbook
  destination:
    server: https://kubernetes.default.svc
    namespace: guestbook
  syncPolicy:
    syncOptions:
    - CreateNamespace=true
    automated:
      selfHeal: true
      prune: true 
      allowEmpty: false 
YAML
}

resource "kubectl_manifest" "argosecret" {
  depends_on = [helm_release.argocd]
  yaml_body = <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: private-repo
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  type: git
  url: https://github.com/andrey-olishchuk/argocd-examples
  password: ghp_frvrfrffaPFHF4OB888PPDSXC2BfwIe
  username: andrey-olishchuk
YAML
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_namespace" "guestbook" {
  metadata {
    name = "guestbook"
  }
}