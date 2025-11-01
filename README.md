# run by
bin/dev
# bundles and work
bundle add hashid-rails annotate neo4j-ruby-driver 
bundle add bcrypt 
bundle add rack-cors   
bundle add dotenv-rails      
bundle add rspec-rails factory_bot_rails  


bundle add foreman vite_rails
bundle exec vite install
npm install -D vite-plugin-full-reload
vite.config.ts
'''
plugins: [
    FullReload([
      'config/routes.rb',
      'app/views/**/*',
      'app/controllers/**/*'
    ])
]
'''
// change bin/dev
'''
#!/usr/bin/env ruby
exec "foreman start -f Procfile.dev"
'''


# 
rails g scaffold DbScrapper user:references project:references url meta_data:jsonb source_provider sub_type response:jsonb fildered_response:jsonb parser_code:text final_response knowledge_storage_cypher_code:text

rails g scaffold KnowledgeQueryfier user:references project:references cypher_dynamic_query:text meta_data_swagger_docs:jsonb tags title description:text

# tips
rails routes -g db_scrapper

# 
bin/vite dev
rails s

## VsCode Extension
* misogi.ruby-rubocop // for linting & formatting

<!-- rails g scaffold ApplicationDoc title:string description:text base_url:string tags:text is_active:boolean docs:jsonb auth_fields:jsonb docs:jsonb -->
<!-- rails g scaffold ApplicationDocRequest application_doc:references title:string description:text curl_template:text swagger_data:jsonb     -->
<!-- rails g scaffold ApplicationCredential application_doc:references title:string description:text credential_type:string rate_limits:jsonb settings:jsonb auth_data:jsonb is_active:boolean -->
# rails g scaffold ApplicationCredientail crediantial_type: (real | proxy), auth_data:jsonb( encripted: salt+secrets ), salt:str, application_request:reference
# real -> limit..
  # - proxy 1 -> jwt, name, desc, limit.., experi: , reqPerMin: ..., real_key_id: .., api_request_settings: {api_id, enable: true, cache: true, }
<!--  rails g scaffold ApplicationCredentialProxyLog application_doc:references application_credential:references user:references request_data:jsonb response_data:jsonb requested_at:datetime finished_at:datetime credits_used:decimal duration_ms:integer
 -->
# rails g scaffold ApplicationCredientailProxyLog request: {}, response: {}, request_at: ,finish_at: 

<!-- rails g scaffold UserCredit user:references total_credits:decimal used_credits:decimal current_balance:decimal -->