# == Schema Information
#
# Table name: application_doc_requests
#
#  id                 :integer          not null, primary key
#  application_doc_id :integer          not null
#  title              :string
#  description        :text
#  curl_template      :text
#  swagger_data       :jsonb
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_application_doc_requests_on_application_doc_id  (application_doc_id)
#

require 'rails_helper'

RSpec.describe ApplicationDocRequest, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
