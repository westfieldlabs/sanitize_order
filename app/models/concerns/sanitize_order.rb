module SanitizeOrder
  extend ActiveSupport::Concern

  included do

    scope :sanitize_order, -> (tainted_sql = nil, whitelist = nil) do
      sql = sanitize_order_clause(tainted_sql, whitelist)
      reorder(sql) unless sql.empty?
    end

    def self.sanitize_order_clause(tainted_sql = nil, whitelist = nil)
      tainted_sql.to_s.strip.split(',').map do |e|
        if whitelist
          whitelist_order_element(e, whitelist)
        else
          sanitize_order_element(e)
        end
      end.reject(&:empty?).join(',')
    end

    def self.sanitize_order_element(element)
      element.strip!
      column_and_table_name, direction = element.split(' ')[0, 2]

      # allow the table name to be passed in the format
      # <table_name>.<column_name> in order to remove ambiguous query
      # strings
      if column_and_table_name.include?(".")
        the_table_name, column = column_and_table_name.split('.')[0, 2]
        the_table_name = sanitize_table_name(the_table_name)

        # Do not allow invalid table names
        return unless the_table_name.present?
      else
        column = column_and_table_name
        the_table_name = table_name
      end

      column = sanitize_order_column(column)
      direction = sanitize_order_direction(direction)

      column ? "#{the_table_name}.#{column} #{direction}" : ''
    end

    def self.whitelist_order_element(element, whitelist)
      element.strip!
      column, direction = element.split(' ')[0, 2]

      if column_and_table_name = whitelist[column]
        direction = sanitize_order_direction(direction)
        "#{column_and_table_name} #{direction}"
      else
        ""
      end
    end

    def self.sanitize_order_column(column_name)
      column_names.include?(column_name) ? column_name : nil
    end

    def self.sanitize_table_name(the_table_name)
      (table_name == the_table_name) ? "#{the_table_name}" : nil
    end

    def self.sanitize_order_direction(dir = nil)
      (dir.to_s.upcase == 'DESC' ? 'DESC' : 'ASC')
    end
  end
end
