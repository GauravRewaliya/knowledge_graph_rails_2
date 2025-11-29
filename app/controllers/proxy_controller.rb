class ProxyController < ApplicationController
  def forward
    target_url = params[:target]

    return render json: { error: "Missing target URL" }, status: 400 unless target_url

    # capture incoming data
    incoming_headers = request.headers.env.select { |k, _| k.start_with?("HTTP_") }
    incoming_body    = request.raw_post.presence
    incoming_method  = request.method

    conn = Faraday.new

    start = Time.now

    response = conn.run_request(
      incoming_method.downcase.to_sym,
      target_url,
      incoming_body,
      cleaned_headers(incoming_headers)
    )

    duration = (Time.now - start).round(4)

    # store log
    ApiLog.create!(
      method: incoming_method,
      target_url: target_url,

      req_method: incoming_method,
      req_path: URI(target_url).path,
      req_query: URI(target_url).query,
      req_headers: cleaned_headers(incoming_headers),
      req_body: parse_json(incoming_body),

      res_status: response.status,
      res_headers: response.headers.to_h,
      res_body: safe_body(response.body),
      res_time: duration
    )

    # return response as-is
    render json: safe_json(response.body), status: response.status
  end

  private

  def cleaned_headers(headers)
    headers.transform_keys { |k| k.sub("HTTP_", "").titleize }.reject do |k, _|
      %w[Host Connection].include?(k)
    end
  end

  def parse_json(str)
    JSON.parse(str) rescue str
  end

  def safe_json(body)
    JSON.parse(body) rescue body
  end

  def safe_body(body)
    JSON.parse(body) rescue body
  end
end
