# == Schema Information
#
# Table name: application_credentials
#
#  id                 :integer          not null, primary key
#  application_doc_id :integer          not null
#  title              :string
#  description        :text
#  credential_type    :string
#  rate_limits        :jsonb
#  settings           :jsonb
#  auth_data          :jsonb
#  is_active          :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_application_credentials_on_application_doc_id  (application_doc_id)
#

require 'rails_helper'

RSpec.describe ApplicationCredential, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
