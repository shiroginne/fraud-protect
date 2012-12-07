class FroudProtect < Sinatra::Base
  configure :production, :development do
    disable :logging
  end

  get '/*' do
    if params['object'].nil? || params['value'].nil?
      'No params passed'
    else
      object = params['object'].to_sym
      value = params['value']
    
      server_request({ object: object, value: value }).to_json
    end
  end
end