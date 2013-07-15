module ActiveRecordMap

  module Config

    attr_accessor :config

    ##
    # Configure custom classes to use with json attributes.
    # These classes should inherit from `ActiveRecordMap::Map`.
    #
    def use(klass, attribute_name=nil)
      self.config ||= ::Map.new
      self.config[:map_filters] ||= {}
      map_columns = columns.select{|column| column.type == :json}

      if map_columns.size > 1
        if attribute_name.nil?
          raise ArgumentError, "`attribute_name` arg is required when more than one json column exists in a table;"+
                               " you have #{map_columns.size} [#{map_columns.map(&:name).join(',')}]."
        end
      elsif map_columns.size == 1 and attribute_name.nil?
        attribute_name = map_columns.first.name
      end

      self.config[:map_filters][attribute_name] = klass
      self.config[:map_filters]
    end

  end

end