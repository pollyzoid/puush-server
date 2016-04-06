class Application < Sinatra::Base
  helpers do

    def key_authed?(key)
      User.first(:api => key)
    end
    
  end
end