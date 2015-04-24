my_routes = [File.join(File.dirname(__FILE__), "routes.rb")]
ArchivesSpace::Application.config.paths['config/routes'].concat(my_routes)

Rails.application.config.after_initialize do

  begin
    JSONModel(:top_container)
  rescue
    puts("Couldn't find JSONModel(:top_container)\n" +
         "\n" +
         "The box_search plugin depends on container_management. Be sure to include the container_management plugin.\n\n" +
         "Please check your configuration and try again.")
    raise "Plugin dependency not satisfied - box_search requires container_management"
  end

end
