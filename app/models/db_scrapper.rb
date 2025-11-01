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

class DbScrapper < ApplicationRecord
  belongs_to :user
  belongs_to :project


  # enum :processing_status, {
  #   unprocessed: 0,
  #   sp_filterer: 1,
  #   filtered: 2,
  #   sp_conveter: 3,
  #   conveter: 4,
  #   sp_convert: 5,
  #   final_response: 6
  # }

  # def request_struct
  #   ScrapperRequestBase.from_hash(request || {})
  # end

  # def request_struct=(obj)
  #   self.request = obj.as_json
  # end
  # # validates :url, :source_type_key, :workspace_id, presence: true
end
