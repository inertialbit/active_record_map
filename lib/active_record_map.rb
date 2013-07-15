require 'map'
require 'json'
require 'active_record_map/config'
require 'active_record_map/after_initialize_hook'

module ActiveRecordMap

  def self.included(base)
    base.extend Config
    base.send :include, AfterInitializeHook
  end

  class Map < ::Map
    # Override Map#method_missing to parse JSON strings.
    def method_missing(method, *args, &block)
      mapped = super
      if mapped.kind_of? String
        if mapped =~ %r{^\[.*\]\Z}
          mapped = JSON.load(mapped)
        elsif mapped =~ %r{^\{.*\}\Z}
          mapped = JSON.load(mapped)
        end
      end
      mapped
    end
  end

end