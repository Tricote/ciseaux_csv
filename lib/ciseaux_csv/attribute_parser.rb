module CiseauxCsv
  class AttributeParser
    def initialize(nested_separator = '|', params_class = Hash)
      @nested_separator = nested_separator
      @params_class = params_class
      @param_depth_limit = 5
    end

    # Assign an attribute in the hash according to a csov_key
    #
    # @param hash [Hash] the hash to modifiy
    # @param csov_key [String] the csov description of the path in the hash
    # @param value [String] the value to assign in the hash
    #
    # @example Simple nested object
    #   assign(h, "author[name]", "Bill")
    #   h["author"]["name"] 
    #   #=> "Bill"
    # 
    # @example Nested collection of object
    #   assign(h, "comments[][title]", "Title1|Title2")
    #   h["comments"] #=> Array
    # 
    #   h["comments"][0]["title"] 
    #   #=> "Title1"
    #
    #   h["comments"][1]["title"]
    #   #=> "Title2"
    def assign(hash, csov_key, value)
      normalize_attributes(hash, csov_key, value, 5)
    end

    private
    def normalize_attributes(hash, csov_key, value, depth)
      raise RangeError if depth <= 0

      csov_key =~ %r(\A[\[\]]*([^\[\]]+)\]*)
      k = $1 || ''
      after = $' || ''

      return if k.empty?

      if after == ""
        hash[k] = value
      elsif after == "["
        hash[csov_key] = value
      elsif after == "[]"
        hash[k] ||= []
        raise ParameterTypeError, "expected Array (got #{hash[k].class.name}) for attribute `#{k}'" unless hash[k].is_a?(Array)
        hash[k] = value.split(@nested_separator)
      elsif after =~ %r(^\[\]\[([^\[\]]+)\]$) || after =~ %r(^\[\](.+)$)
        child_key = $1
        hash[k] ||= []
        raise ParameterTypeError, "expected Array (got #{hash[k].class.name}) for attribute `#{k}'" unless hash[k].is_a?(Array)
        value.split(@nested_separator).each_with_index do |nested_value, index|
          if params_hash_type?(hash[k][index]) && !hash[k][index].key?(child_key)
            normalize_attributes(hash[k][index], child_key, nested_value, depth - 1)
          else
            hash[k][index] = normalize_attributes(make_hash, child_key, nested_value, depth - 1)
          end
        end

      else
        hash[k] ||= make_hash
        raise ParameterTypeError, "expected Hash (got #{hash[k].class.name}) for attribute `#{k}'" unless params_hash_type?(hash[k])
        hash[k] = normalize_attributes(hash[k], after, value, depth - 1)
      end

      return hash
    end

    def params_hash_type?(obj)
      obj.kind_of?(@params_class)
    end

    def make_hash
      @params_class.new
    end

  end
end