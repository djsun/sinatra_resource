module RequestHelpers

  def parsed_response_body
    Crack::JSON.parse(last_response.body)
  end
  
end
