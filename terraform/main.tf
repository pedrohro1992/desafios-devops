// Configurando o Provider do GCP 
provider "google" {
 credentials = "${file("PROD-ENV-2b6ce9a713ea.json")}"
 project     = "prod-env-224202"
 region      = "us-west1"
}
//Setando a variavel para extração do IP 
output "ip" {
 value = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
}
//Setando as regras de Firewall para acesso SSH 
resource "google_compute_firewall" "ssh" {
  name    = "port-22-rule"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
} 
// Setando as Regras de Firwewall para acesso as portas 80 e 443
resource "google_compute_firewall" "http" {
  name = "http-acces-rule"
  network = "default"

  allow {
    protocol ="tcp"
    ports = ["80", "443"]
  }  
}
// Deployando a maquina no GCP 
resource "google_compute_instance" "default" {
 name         = "terraform-teste1"
 machine_type = "n1-standard-1"
 zone         = "us-west1-a"

 boot_disk {
   initialize_params {
     image = "ubuntu-os-cloud/ubuntu-1404-trusty-v20160602"
   }
 }
 metadata {
   sshKeys = "pedrooliveira:${file("~/.ssh/id_rsa.pub")}"

 }
 network_interface {
   network = "default"

   access_config {
     // Include this section to give the VM an external ip address
   }
 }
   
  }

 






