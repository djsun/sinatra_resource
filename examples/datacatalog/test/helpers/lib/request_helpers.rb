module RequestHelpers

  def parsed_response_body
    s = last_response.body
    if s == ""
      nil
    else
      Crack::JSON.parse(s)
    end
  end
  
end
