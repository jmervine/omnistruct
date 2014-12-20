require 'json'

module CommonStruct
  DEFAULT_STRUCT_TYPE = :classy_struct

  def struct_type
    DEFAULT_STRUCT_TYPE
  end

  def to_struct(type=nil)
    type ||= struct_type
    return self if type.to_sym == struct_type
    return self.to_h.to_struct(type)
  end

  def delete key
    key = key.to_sym
    val = send(key) rescue nil

    unless val.nil?
      send("#{key}=".to_sym, nil)
    end

    return val
  end

  def to_json
    to_h.to_json
  end
end
