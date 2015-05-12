# ArchivesSpace Box Search Plugin

An ArchivesSpace plugin that adds a box search screen to the staff UI

This plugin depends on the container model currently provided by the
[container_management](https://github.com/hudmol/container_management)
plugin.


## How to install it

To install, just activate the plugin in your config/config.rb file by
including an entry such as:

     # If you have other plugins loaded, just add 'box_search' to
     # the list
     AppConfig[:plugins] = ['local', 'other_plugins', 'managed_containers', 'box_search']

And then clone the `box_search` repository into your
ArchivesSpace plugins directory.  For example:

     cd /path/to/your/archivesspace/plugins
     git clone https://github.com/hudmol/box_search.git box_search

Or if you are after a particular release, download and unzip it from here:

https://github.com/hudmol/box_search/releases

When installing or upgrading this plugin it will be neceesary to reindex some of the records
in your system (resources and top_containers). The plugin includes a database migration
that will trigger the reindex. Run the migration like this:

      cd /path/to/archivesspace
      scripts/setup-database.sh

Or if you are running in dev mode, you can force a complete reindex like this:

      cd /path/to/archivesspace/build
      rm -rf indexer_state


## How to use it

Click the gear icon in the repository toolbar.
Hover over the `Plug-ins` item in the dropdown and click on `Box Search` when it appears.

- Enter a box number (also known as container indicator).
- Optionally enter a collection number (also known as resource identifier).
- Hit return, or click `Search`.

Information about matching boxes will appear below, including their current location.
