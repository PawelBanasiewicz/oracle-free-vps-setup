resource "oci_budget_alert_rule" "alert-rule" {
  budget_id      = oci_budget_budget.budget.id
  threshold      = 100
  threshold_type = "PERCENTAGE"
  type           = "FORECAST"

  display_name = "zero-spending-alert-rule"
  message      = "Przekroczono budżet za Oracle Cloud. Sprawdź szczegóły: https://cloud.oracle.com/account-management/overview"
  recipients   = var.alerts_email
}

resource "oci_budget_budget" "budget" {
  compartment_id = var.compartment_id
  amount         = var.spending_limit
  reset_period   = "MONTHLY"
  display_name   = "budget"

  target_type = "COMPARTMENT"
  targets     = [var.compartment_id]
}