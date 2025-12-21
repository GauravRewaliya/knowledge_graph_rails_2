module HarParser
  class Parser
    def initialize(har_json)
      @har = har_json.is_a?(String) ? JSON.parse(har_json) : har_json
    end

    def extract_requests
      return [] unless @har.is_a?(Hash) && @har['log'].is_a?(Hash)

      entries = @har['log']['entries'] || []
      entries.map.with_index do |entry, idx|
        extract_entry_data(entry, idx)
      end
    end

    private

    def extract_entry_data(entry, index)
      {
        _id: "entry-#{Time.now.to_i}-#{index}",
        _index: index,
        _selected: false,
        _harName: extract_har_filename,
        _harId: extract_har_id,
        startedDateTime: entry['startedDateTime'] || Time.now.iso8601,
        time: entry['time']&.to_f || 0,
        request: extract_request(entry['request']),
        response: extract_response(entry['response']),
        cache: entry['cache'] || {},
        timings: entry['timings'] || {}
      }
    end

    def extract_request(request_data)
      return {} unless request_data.is_a?(Hash)

      {
        method: request_data['method'] || 'GET',
        url: request_data['url'] || '',
        httpVersion: request_data['httpVersion'] || 'HTTP/1.1',
        headers: extract_headers(request_data['headers']),
        queryString: request_data['queryString'] || [],
        cookies: request_data['cookies'] || [],
        headersSize: request_data['headersSize'] || -1,
        bodySize: request_data['bodySize'] || -1,
        postData: request_data['postData'] || {}
      }
    end

    def extract_response(response_data)
      return { status: 0, statusText: 'Unknown', headers: [], cookies: [], content: {} } unless response_data.is_a?(Hash)

      {
        status: response_data['status'] || 0,
        statusText: response_data['statusText'] || 'Unknown',
        httpVersion: response_data['httpVersion'] || 'HTTP/1.1',
        headers: extract_headers(response_data['headers']),
        cookies: response_data['cookies'] || [],
        content: extract_content(response_data['content']),
        redirectURL: response_data['redirectURL'] || '',
        headersSize: response_data['headersSize'] || -1,
        bodySize: response_data['bodySize'] || -1
      }
    end

    def extract_headers(headers_array)
      return [] unless headers_array.is_a?(Array)

      headers_array.map do |header|
        {
          name: header['name'] || '',
          value: header['value'] || ''
        }
      end
    end

    def extract_content(content_data)
      return { size: 0, mimeType: 'application/octet-stream', text: '' } unless content_data.is_a?(Hash)

      {
        size: content_data['size'] || 0,
        mimeType: content_data['mimeType'] || 'application/octet-stream',
        text: content_data['text'] || '',
        encoding: content_data['encoding'] || 'utf8'
      }
    end

    def extract_har_filename
      @har.dig('log', '_har_filename') || 'Unknown.har'
    end

    def extract_har_id
      @har.dig('log', '_har_id') || SecureRandom.hex(8)
    end
  end
end
