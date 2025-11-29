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

require 'rails_helper'

RSpec.describe ApplicationCredentialProxyLog, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
