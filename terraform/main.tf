terraform {
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = ">= 6.25.0"
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = "eu-frankfurt-1"
}

resource "oci_core_vcn" "vcn" {
  compartment_id = var.compartment_id

  cidr_blocks = [
    "10.0.0.0/24",
  ]
  display_name   = "vcn"
  dns_label      = "vcn01241828"
  is_ipv6enabled = false
}

resource "oci_core_subnet" "subnet" {
  compartment_id    = var.compartment_id
  vcn_id            = oci_core_vcn.vcn.id
  display_name      = "subnet"
  security_list_ids = [oci_core_security_list.security-list.id]
  cidr_block        = "10.0.0.0/24"
}

resource "oci_core_instance" "instance" {
  availability_domain                     = var.availability_domain
  compartment_id                          = var.compartment_id
  preserve_data_volumes_created_at_launch = true

  display_name = "instance"
  fault_domain = "FAULT-DOMAIN-3"
  metadata = {
    "ssh_authorized_keys" = var.ssh_public_key
  }
  security_attributes = {}
  shape               = "VM.Standard.A1.Flex"
  state               = "RUNNING"


  agent_config {
    are_all_plugins_disabled = false
    is_management_disabled   = false
    is_monitoring_disabled   = false

    plugins_config {
      desired_state = "DISABLED"
      name          = "Vulnerability Scanning"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Management Agent"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Custom Logs Monitoring"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Compute RDMA GPU Monitoring"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Compute Instance Monitoring"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Compute HPC RDMA Auto-Configuration"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Compute HPC RDMA Authentication"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Cloud Guard Workload Protection"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Block Volume Management"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Bastion"
    }
  }
  availability_config {
    is_live_migration_preferred = false
    recovery_action             = "RESTORE_INSTANCE"
  }

  create_vnic_details {
    assign_private_dns_record = true
    assign_public_ip          = true
    display_name              = "instance"
    skip_source_dest_check    = false
    subnet_id                 = oci_core_subnet.subnet.id
  }

  instance_options {
    are_legacy_imds_endpoints_disabled = true
  }
  launch_options {
    boot_volume_type                    = "PARAVIRTUALIZED"
    firmware                            = "UEFI_64"
    is_consistent_volume_naming_enabled = true
    is_pv_encryption_in_transit_enabled = true
    network_type                        = "PARAVIRTUALIZED"
    remote_data_volume_type             = "PARAVIRTUALIZED"
  }

  shape_config {
    memory_in_gbs = 24
    ocpus         = 4
    vcpus         = 4
  }

  source_details {
    boot_volume_size_in_gbs         = "200"
    boot_volume_vpus_per_gb         = "10"
    is_preserve_boot_volume_enabled = true
    source_id                       = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaaksqfm6zbpujsbsy3or527xq4wl4kgqejmaho3spy7ygotftf5haq"
    source_type                     = "image"
  }
}

resource "oci_core_security_list" "security-list" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "security-list"
  ingress_security_rules {
    description = "allow tcp access to port 8080"
    protocol    = "6"         # TCP
    source      = "0.0.0.0/0" # Open to anyone
    tcp_options {
      min = 8080
      max = 8080
    }
  }
  ingress_security_rules {
    description = "allow ssh access, important, without that you can't access server"
    protocol    = "6"         # TCP
    source      = "0.0.0.0/0" # Open to anyone
    tcp_options {
      min = 22
      max = 22
    }
  }
  egress_security_rules {
    description      = "allow egress to anywhere"
    protocol         = "6" # TCP
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK" # default
  }
}

resource "oci_core_internet_gateway" "gateway" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "gateway"
}

resource "oci_core_default_route_table" "route-table" {
  compartment_id = var.compartment_id
  manage_default_resource_id = oci_core_vcn.vcn.default_route_table_id

  display_name   = "route-table"
  route_rules {
    network_entity_id = oci_core_internet_gateway.gateway.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}
