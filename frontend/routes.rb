ArchivesSpace::Application.routes.draw do
  match('/plugins/box_search/search/typeahead' => 'box_search#typeahead', :via => [:get])
  match('/plugins/box_search/search/linker_search' => 'box_search#linker_search', :via => [:get])
  match('/plugins/box_search/search' => 'box_search#search', :via => [:post])
end
