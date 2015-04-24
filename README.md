# box_search

An ArchivesSpace plugin that adds a box search screen to the staff UI

This plugin depends on the container model currently provided by the
[container_management](https://github.com/hudmol/container_management)
plugin.

## Install

To install, just activate the plugin in your config/config.rb file by
including an entry such as:

     # If you have other plugins loaded, just add 'box_search' to
     # the list
     AppConfig[:plugins] = ['local', 'other_plugins', 'managed_containers', 'box_search']

And then clone the `box_search` repository into your
ArchivesSpace plugins directory.  For example:

     cd /path/to/your/archivesspace/plugins
     git clone https://github.com/hudmol/box_search.git box_search

