import path from 'path'
import { defineConfig } from 'vite'
import FullReload from 'vite-plugin-full-reload'
import RubyPlugin from 'vite-plugin-ruby'

export default defineConfig({
  plugins: [
    RubyPlugin(),
    FullReload([
      'config/routes.rb',
      'app/views/**/*',
      'app/controllers/**/*',
      'app/helpers/**/*',
      'app/assets/**/*'
    ])
  ],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "app/javascript"),
    },
  },
})
