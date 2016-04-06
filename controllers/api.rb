require 'digest/md5'

class Application < Sinatra::Base
  post '/api/auth' do
    puts params[:e]
    if (user = User.first(:email => params[:e])) &&
      (params[:k].nil? ? user.password == params[:p] : params[:k] == user.api)

      return [user.role.id, user.api, '', user.disk_used].join ','
    end

    '-1,,,'
  end

  post '/api/up' do
    puts params.inspect
    unless params[:f] && (tmpfile = params[:f][:tempfile]) &&
      (name = params[:f][:filename])

      return ',,,'
    end

    unless (user = key_authed?(params[:k]))
      return '-1,,,'
    end

    size = tmpfile.size

    if (user.role.max_size > 0 && size > user.role.max_size)
      return '-4,,,' + user.disk_used.to_s
    end

    if (user.role.quota > 0 && user.disk_used + size > user.role.quota)
      return '-4,,,' + user.disk_used.to_s
    end

    unless params[:c] == Digest::MD5.hexdigest(tmpfile.read)
      return '-3,,,'
    end
    tmpfile.rewind

    char = [('a'..'z'),('A'..'Z'),(0..9)].map{|i| i.to_a}.flatten
    short = nil
    loop do
      short = (0..6).map{ char[rand(char.length)] }.join
      break if UploadFile.count(:short_name => short) == 0
    end

    file = UploadFile.create(
      :name => name,
      :short_name => short,
      :user => user
    )

    File.open(File.join('upload', short), 'wb') do |f|
      f.write(tmpfile.read)
    end

    user.disk_used += size
    user.save
    puts "0,#{@config[:site]}/#{short},#{file.id},#{user.disk_used}"
    "0,#{@config[:site]}/#{short},#{file.id},#{user.disk_used}"
  end

  post '/api/del' do
    unless key_authed?(params[:k])
      return
    end

    f = UploadFile.get(params[:i].to_i)

    user.disk_used -= File.size(File.join('upload', f.short_name))
    user.save

    File.delete(File.join('upload', f.short_name))
    f.destroy
  end

  post '/api/hist' do
    unless (user = key_authed?(params[:k]))
      return '-1'
    end

    "0\n" << user.hist.map { |f|
      [
        f.id,
        f.created_at.strftime("%Y-%m-%d %H:%M:%S"),
        "#{@config[:site]}/#{f.short_name}",
        f.name,
        f.views
      ].join ","
    }.join("\n")
  end

  post '/api/thumb' do
    # TODO
  end
end