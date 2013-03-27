Twitter.configure do |config|
  config.consumer_key = "nfaOrL6p0Q0gomEwmkUFw"
  config.consumer_secret = "nvpBIB3ZYVNcMwKiAg6cjs9DS3787QpcEiKWirGkiO0"
  config.oauth_token = "45601285-2kpcblwDrwwwN9LrheYeTmZSwCRtCIGGl46RPPdhw"
  config.oauth_token_secret = "45nYe4xB1zFuXwXWMIjCQ48KHoISHkiqFjWtYv1gOk"
end

middleware = Proc.new do |builder|
  builder.use Twitter::Request::MultipartWithFile
  builder.use Faraday::Request::Multipart
  builder.use Faraday::Request::UrlEncoded
  builder.use Twitter::Response::RaiseError, Twitter::Error::ClientError
  builder.use Twitter::Response::ParseJson
  builder.use Twitter::Response::RaiseError, Twitter::Error::ServerError
  builder.adapter :typhoeus
end

Twitter.middleware = Faraday::Builder.new(&middleware)
