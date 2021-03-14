module ResponseHandler
  def json_response(data, status = :ok)
    render json: data, status: status
  end

  def render_error(data: nil, message: nil, status: :internal_server_error, errors: [])
    render json: { data: data, message: message, errors: errors }, status: status
  end
end