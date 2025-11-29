# == Schema Information
#
# Table name: application_credential_proxy_logs
#
#  id                        :integer          not null, primary key
#  application_doc_id        :integer          not null
#  application_credential_id :integer          not null
#  user_id                   :integer          not null
#  request_data              :jsonb
#  response_data             :jsonb
#  requested_at              :datetime
#  finished_at               :datetime
#  credits_used              :decimal(, )
#  duration_ms               :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
# Indexes
#
#  idx_on_application_credential_id_652e413c36                    (application_credential_id)
#  index_application_credential_proxy_logs_on_application_doc_id  (application_doc_id)
#  index_application_credential_proxy_logs_on_user_id             (user_id)
#

FactoryBot.define do
  factory :application_credential_proxy_log do
    application_doc { nil }
    application_credential { nil }
    user { nil }
    request_data { "" }
    response_data { "" }
    requested_at { "2025-11-01 16:02:42" }
    finished_at { "2025-11-01 16:02:42" }
    credits_used { "9.99" }
    duration_ms { 1 }
  end
end
