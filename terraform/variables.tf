variable "tenancy_ocid" {
  type        = string
  description = "Displayed when creating new API KEY here: https://cloud.oracle.com/identity/domains/my-profile/api-keys"
  default     = "ocid1.tenancy.oc1..aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

variable "compartment_id" {
  description = "Same as tenancy_ocid. Just set it this way and forget about it."
  type        = string
  default     = "ocid1.tenancy.oc1..aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

variable "user_ocid" {
  type        = string
  description = "Displayed when creating new API KEY here: https://cloud.oracle.com/identity/domains/my-profile/api-keys"
  default     = "ocid1.user.oc1..aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
}
variable "fingerprint" {
  type        = string
  description = "Displayed when creating new API KEY here: https://cloud.oracle.com/identity/domains/my-profile/api-keys"
  default     = "5a:5a:5a:5a:5a:5a:5a:5a:5a:5a:5a:5a:5a:5a:5a:5a"
}

variable "private_key_path" {
  type        = string
  description = "where you store your API KEY-related certificate. ON YOUR MACHINE. Create this directory and put your cert there."
  default     = "~/.oci/example@example.com_2020-01-01T01_01_01.654Z.pem"
}

variable "ssh_public_key" {
  type        = string
  description = "Public key of SERVERS-related certificate, used for SSH access (downloaded when creating instance)"
  default     = "ssh-rsa LONG-KEY-HERE ssh-key-2025-02-06"
}

variable "availability_domain" {
  type = string
  description = "Where you want your instance to be created. WITHIN REGION. Sometimes AD-1 is full, so try others (AD-2 or AD-3)"
  default = "HIfK:EU-FRANKFURT-1-AD-1"
}

variable "alerts_email" {
  type        = string
  description = "e-mail, which will receive budget alerts"
  default     = "example@example.com"
}

variable "spending_limit" {
  type        = number
  description = "On what threshold you want the spending alert to be triggered [in default currency of your card, probably PLN]"
  default     = "10"
}
