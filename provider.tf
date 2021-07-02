provider "kubernetes" {
  config_context_cluster = "minikube"
  config_path            = "~/.kube/config"
}

locals {
  hello_labels = {
    App  = "hello"
    Tier = "frontend"
  }
}

resource "kubernetes_service" "hello-service" {
 metadata {
   name = "hello-service"
 }
 spec {
   selector = local.hello_labels
   port {
     port        = 80
     target_port = 8080
   }
 }
}

resource "kubernetes_deployment" "hello" {
  metadata {
    name = "hello"
    labels = local.hello_labels
  }
  spec {
    replicas = 1
    selector {
     match_labels = local.hello_labels
    }
    template {
      metadata {
        labels = local.hello_labels
      }
      spec {
        container {
          image = "httpd"
          name  = "hello"
        }
      }
    }
  }
}
