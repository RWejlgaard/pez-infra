resource "pagerduty_escalation_policy" "default" {
  name      = "Default"
  num_loops = 2

  rule {
    escalation_delay_in_minutes = 10

    target {
      type = "user_reference"
      id   = pagerduty_user.pez.id
    }
  }
}
