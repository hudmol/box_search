ArchivesSpace::Application.routes.draw do
  match('/plugins/box_search/search' => 'box_search#search', :via => [:post])
end
