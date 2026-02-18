class LogParserService
  LOG_REGEX = /^(?<timestamp>\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}) \[(?<category>\w+)\] (?<event_type>\w+) (?<raw_metadata>.*)$/

  def self.parse(line)
    match = line.match(LOG_REGEX)
    return nil unless match

    {
      timestamp: match[:timestamp],
      category: match[:category],
      event_type: match[:event_type],
      metadata: parse_metadata(match[:raw_metadata])
    }
  end

  def self.parse_metadata(raw)
    raw.scan(/(?<key>\w+)=(?:"(?<value>[^"]+)"|(?<value_simple>\S+))/).each_with_object({}) do |(key, v1, v2), hash|
      hash[key.to_sym] = v1 || v2
    end
  end
end
