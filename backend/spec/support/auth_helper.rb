module AuthHelper
  def sign_in_as(user)
    post "/api/v1/auth/sign_in",
      params: { user: { email: user.email, password: "password" } },
      as: :json
    json_body = JSON.parse(response.body)
    json_body["token"]
  end

  def auth_headers(token)
    { "Authorization" => "Bearer #{token}" }
  end
end
