require 'db/migrations/utils'

Sequel.migration do

  up do
    now = Time.now
    [:resource, :top_container].each do |table|
      self[table].update(:system_mtime => now)
    end
  end

  down do
    # it's only up
  end

end
