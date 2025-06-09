class FeedbackResultSerializer < Blueprinter::Base
  identifier :id

  fields :affected_devices, :estimated_affected_accounts
end
