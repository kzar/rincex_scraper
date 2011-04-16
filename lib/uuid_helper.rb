require 'rubygems'
require 'uuidtools'

# Module to help with UUID creation
# http://stackoverflow.com/questions/2487837/uuids-in-rails3
module UUIDHelper
  def self.included(base)
    base.class_eval do
      before_create :set_guuid

      def set_guuid
        self.id = UUIDTools::UUID.random_create.to_s
      end
    end
  end
end

# Add an UUID conversion method to ActiveRecord
# FIXME - Is this the correct place to put this? How can automate this step?
module ActiveRecord
  # Execute SQL to alter UUID field _if_ using Postgres
  # Fixme - we're trusting the caller here! SQL Injection?
  def self.convert_to_native_uuid(table, field)
    if ActiveRecord::Base.connection.adapter_name == "PostgreSQL"
      sql = "ALTER TABLE #{table} ALTER COLUMN #{field} TYPE uuid
            USING CAST(regexp_replace(#{field}, '([A-Z0-9]{4})([A-Z0-9]{12})',
                                      E'\\1-\\2')
            AS uuid);"
      ActiveRecord::Base::connection.execute(sql)
    end
  end
end
