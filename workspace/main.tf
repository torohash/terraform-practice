provider "google" {
  credentials = file(var.credentials)
  project     = var.project
  region      = var.region
}

resource "google_compute_instance" "single" {
  name         = var.instance
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }
}

resource "google_compute_instance" "multiple" {
  count        = var.instance_count
  name         = "${var.instance_name_prefix}-${count.index + 1}"
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }
}

variable "credentials" {
  description = "Path to the JSON file used to describe your account credentials"
}

variable "project" {
  description = "The ID of the project in which the resources belong"
}

variable "region" {
  description = "The region in which to create the resources"
}

variable "zone" {
  description = "The zone in which to create the resources"
}

variable "instance" {
  description = "The name of the single instance to create"
}

variable "instance_count" {
  description = "The number of instances to create"
  default     = 1
}

variable "instance_name_prefix" {
  description = "The prefix for the instance names"
  default     = "instance"
}