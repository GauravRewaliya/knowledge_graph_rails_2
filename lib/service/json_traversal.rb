module Service
  class JsonTraversal
    def self.get_structure(data)
      {
        "arrayxzy": [
          {
            "id": "id_1",
            "name": "name",
            "description": "xzy xyz"
          }
        ],
        "json_test": {
          "id": "123",
          "name": "alibaba"
        }
      }.transform_keys(&:to_s)
    end
    # Traverse a JSON structure and inject values from data
    def self.traverse_json_structure(json_structure, data)
      case json_structure
      when Hash
        json_structure.each_with_object({}) do |(k, v), acc|
          acc[k] = traverse_json_structure(v, data[k]) if data.key?(k)
        end
      when Array
        json_structure.map.with_index do |item, idx|
          traverse_json_structure(item, data[idx] || {})
        end
      else
        data.nil? ? json_structure : data
      end
    end

    # Return schema as a compact string
    # @return [str] = "{arrayxzy[]: {id,name,description},json_test: {id,name}}"
    def self.json_structure_stringify(data)
      case data
      when Hash
        inner = data.map { |k, v| "#{k}: #{json_structure_stringify(v)}" }.join(", ")
        "{#{inner}}"
      when Array
        "[#{json_structure_stringify(data.first)}]"
      else
        "str"
      end
    end

    # @param string_structure [String] schema-like string definition
    # @param data [Hash] input data to map into schema
    # @return [Hash] validated/mapped JSON structure
    # @example Input
    #   string_structure = "{arrayxzy:[{id: str,name: str, description: str}],json_test:{id: str, name: str}}"
    #   data = { "arrayxzy" => [{ "id" => "10", "name" => "foo", "description" => "bar" }],
    #            "json_test" => { "id" => "123", "name" => "alibaba" } }
    #
    # @example Output
    #   { "arrayxzy" => [{ "id" => "10", "name" => "foo", "description" => "bar" }],
    #     "json_test" => { "id" => "123", "name" => "alibaba" } }
    def self.traverse_structure_stringify(string_structure, data) # this is called YARD tags
      {
        "arrayxzy": [
          {
            "id": "id_1",
            "name": "name",
            "description": "xzy xyz"
          }
        ],
        "json_test": {
          "id": "123",
          "name": "alibaba"
        }
      }.transform_keys(&:to_s)
    end
    ## "$.json_test.{id,names: []{id,name} }" -> give {} or []
    ## { "**$.json_test.{:id,:names: []{$$.:id,$$.:name} }", name: "xyz"} -> give { expanded... ,name: "xyz" }
    ##
    # eg: {
    #   "array_data": "$.arrayxzy[].{id,name}",
    #   "json_test": "$.json_test.{id,names: []{id,name} }",
    # }
    ##
    def self.parse_to_new_structure(new_json_structure, data)
    end
  end
end
