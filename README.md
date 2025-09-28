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