Devise.setup do |config|
  config.mailer_sender = "noreply@example.com"

  require "devise/orm/active_record"

  config.case_insensitive_keys = [ :email ]
  config.strip_whitespace_keys = [ :email ]
  config.skip_session_storage = [ :http_auth ]
  config.stretches = Rails.env.test? ? 1 : 12
  config.password_length = 6..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete

  config.jwt do |jwt|
    jwt.secret = ENV.fetch("DEVISE_JWT_SECRET_KEY")
    jwt.expiration_time = 24.hours.to_i

    jwt.dispatch_requests = [
      [ "POST", %r{^/api/v1/auth/sign_in$} ]
    ]

    jwt.revocation_requests = [
      [ "DELETE", %r{^/api/v1/auth/sign_out$} ]
    ]
  end
end
