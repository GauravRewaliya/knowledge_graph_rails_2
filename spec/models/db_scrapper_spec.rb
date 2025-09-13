# == Schema Information
#
# Table name: db_scrappers
#
#  id                            :integer          not null, primary key
#  user_id                       :integer          not null
#  project_id                    :integer          not null
#  url                           :string
#  meta_data                     :jsonb
#  source_provider               :string
#  sub_type                      :string
#  response                      :jsonb
#  fildered_response             :jsonb
#  parser_code                   :text
#  final_response                :string
#  knowledge_storage_cypher_code :text
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
# Indexes
#
#  index_db_scrappers_on_project_id  (project_id)
#  index_db_scrappers_on_user_id     (user_id)
#

require 'rails_helper'

RSpec.describe DbScrapper, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
