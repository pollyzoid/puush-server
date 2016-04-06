class Application < Sinatra::Base
  get '/:name' do |n|
    unless (file = UploadFile.first(:short_name => n))
      return 'Invalid file'
    end

    file.views += 1
    file.save

    send_file(
      File.join('upload', file.short_name),
      :type => File.extname(file.name)
    )
  end
end