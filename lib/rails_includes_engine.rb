require "rails_includes_engine/version"

module RailsIncludesEngine
  class IncludesEngine

  def initialize string
    @string_segments = strip_first_level string
  end

  def strip_first_level string
    string = string.gsub(/(?<b>({(([\w,]{1,})(\g<b>)?)*}){1,})/){ |nested| nested.gsub(',',';') }
    string = string.gsub(/(?:\(.*\))/){ |nested| nested.gsub(',',';') }
    segments = string.split ','
    segments = segments.map do |segment|
      segment.gsub ';', ','
    end
    segments.each do |segment|
      raise StandardError.new "Invalid segment! (#{segment})" unless is_valid? segment
    end
    segments
  end

  def remove_nested string
    string.gsub /(?:{.*})/, ''
  end

  def remove_commands string
    get_command_strings(string).each do |command|
      string = string.gsub('.' + command, '')
    end
    return string
  end

  def get_command_strings string
    remove_nested(string).scan(/(?:\.)([\w\d(),\-_ ]{1,})(?:{.*})?/).map { |group| group.first }
  end

  def get_commands string
    command_strings = get_command_strings(string)
    commands = []
    command_strings.each do |cs|
      args = []
      if group = cs.scan(/(?:\()([\w,\-_ ]{1,})(?:\))$/).first
        if group = group.first
          args = group.split ','
        end
      end
      method = cs.scan(/^\w{1,}/).first.to_sym
      command = {
        method: method,
        arguments: args,
      }
      commands << command
    end
    commands
  end

  def get_nested_string string
    match = string.match(/(?:{(.*)})/)
    return nil unless match
    match[1]
  end

  def get_field_string string
    scan = string.scan /(^[a-zA-Z_]{1,})(?:\.)?/
    return nil unless scan.first
    scan.first.first
  end

  def is_valid? string
    return true if string.match(/^([\w]{1,})(\.[\w]{1,}(\([\w,-_ ]*\))?)*(?:{[\w,{}().]*})?$/)
    false
  end

  def process_segments segments, args = {}
    return_array = []
    segments.each do |segment|
      field = get_field_string(segment).to_sym
      nested = get_nested_string(segment)
      commands = get_commands(segment)
      if nested
        new_hash = Hash.new
        unless args[:simple]
          new_hash[field] = {include: process_segments(strip_first_level(nested)), include_scopes: commands}
        else
          new_hash[field] = process_segments(strip_first_level(nested), args)
        end
        return_array << new_hash
      else
        unless args[:simple]
          new_hash = Hash.new
          new_hash[field] = {include_scopes: commands}
          return_array << new_hash
        else
          return_array << field
        end
      end
    end if segments
    return_array
  end

  def includes_hash args = {}
    process_segments @string_segments, args
  end
end

end
