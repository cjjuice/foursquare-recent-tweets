OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :foursquare, '2204BFGUKTK5KORPWZYUO0CJCLFHWUTLNM2SCEXK2AD0NQ1N', '1WNKMPVJIAK35OTIMA25VCFIRDA5RDUJV554BKX31YR4ZR5M'
end
