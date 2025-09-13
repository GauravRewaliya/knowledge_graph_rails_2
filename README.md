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
