# frozen_string_literal: true

# Configure your routes here
# See: https://guides.hanamirb.org/routing/overview

get '/selection/new', to: 'selection#new'
get '/compare/:movie1/:movie2', to: 'compare#show'

root to: 'selection#new'
