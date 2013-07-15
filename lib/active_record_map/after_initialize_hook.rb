module ActiveRecordMap

  module AfterInitializeHook
    ##
    # Wrap appropriate fields with the configured custom classes.
    # Raise ArgumentError if designated custom class is not defined.
    #
    def self.included(base)
      this = self
      base.after_initialize do |record|
        return if record.class.config.nil? or record.class.config[:map_filters].empty?
        map_filters = record.class.config[:map_filters]
        if map_filters.any?
          map_filters.each do |attribute_name, klass|
            iklass = this.load_constant(klass)
            record[attribute_name] = iklass.send(:new, record[attribute_name])
          end
        end
      end
    end

  protected

    def self.load_constant(klass)
      names = klass.split('::')

      load_it = (-> cur_klass, par_klass=nil {
                                unless const_defined? cur_klass
                                  raise ArgumentError, "#{klass} is not defined."
                                end
                                if par_klass
                                  par_klass.send :const_get, cur_klass
                                else
                                  const_get cur_klass
                                end
                              }
                )
      last_klass = nil
      names.each{ |name| last_klass = load_it.call(name, last_klass)}
      last_klass
    end
  end

end