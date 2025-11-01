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
