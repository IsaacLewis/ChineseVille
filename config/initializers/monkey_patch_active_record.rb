class ActiveRecord::Base
  def bounded_update(attribute, change, bound)
    current_value = self.send attribute
    new_value = current_value + change
    if change > 0 and new_value > bound
      new_value = bound
    end
    if change < 0 and new_value < bound 
      new_value = bound 
    end
    update_attributes attribute => new_value
    new_value
  end

  def unbounded_update(attribute, change)
    update_attributes attribute => (self.send attribute) + change
  end

  def self.where(conditions)
    all :conditions => conditions
  end

  def self.first_where(conditions)
    first :conditions => conditions
  end

  def self.add_methods_of(object_name)
    class_eval <<-END
      alias active_record_method_missing method_missing
      def method_missing(m, *args, &block)
        begin
          active_record_method_missing m, *args, &block
        rescue NoMethodError => e
          return #{object_name}.send m, *args, &block
        end
      end
    END
  end
end
