require "active_storage/service"
require "net/http"
require "tempfile"

class ActiveStorage::Service::CustomFileService < ActiveStorage::Service
  def initialize(token:, base_url:, **options)
    @token, @base_url = token, base_url
  end

  def upload(relative_path, io, checksum: nil, **)
    full_path = "#{Setting.fileapi_path}/#{relative_path}"
    uri = URI("#{@base_url}/files")
    request = Net::HTTP::Post.new(uri)
    request["X-Request-Token"] = @token
    request.set_form({'file' => io, 'filePath' => full_path}, 'multipart/form-data')
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https', read_timeout: 500, open_timeout: 500) do |http|
      http.request(request)
    end
    unless response.is_a?(Net::HTTPSuccess)
      raise "Upload failed: HTTP Status #{response.code}, Response Body: #{response.body}"
    end
  end

  def download(relative_path)
    full_path = "#{Setting.fileapi_path}/#{relative_path}"
    uri = URI("#{@base_url}/files")
    uri.query = URI.encode_www_form(filePath: full_path)
    request = Net::HTTP::Get.new(uri)
    request["X-Request-Token"] = @token
    tempfile = Tempfile.new([relative_path, '.tmp'], binmode: true)

    Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request) do |response|
        if response.is_a?(Net::HTTPSuccess)
          tempfile.write(response.body)
          tempfile.rewind
          return tempfile.path
        else
          raise "Download failed: HTTP Status #{response.code}, Response Body: #{response.body}"
        end
      end
    end
  ensure
    tempfile.close unless tempfile.closed?
  end

  def delete(relative_path)
    full_path = "#{Setting.fileapi_path}/#{relative_path}"
    uri = URI("#{@base_url}/files")
    uri.query = URI.encode_www_form(filePath: full_path)
    request = Net::HTTP::Delete.new(uri)
    request["X-Request-Token"] = @token
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end
    raise "Delete failed" unless response.is_a?(Net::HTTPSuccess)
  end

  def exist?(relative_path)
    full_path = "#{Setting.fileapi_path}/#{relative_path}"
    uri = URI("#{@base_url}/files")
    uri.query = URI.encode_www_form(filePath: full_path)
    request = Net::HTTP::Head.new(uri)
    request["X-Request-Token"] = @token
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end
    response.is_a?(Net::HTTPSuccess)
  end

  def url(relative_path, expires_in: nil, filename: nil, content_type: nil, disposition: nil, **options)
    "#{@base_url}/files?filePath=#{Setting.fileapi_path}/#{relative_path}&X-Request-Token=#{@token}"
  end

  def open(relative_path, checksum: nil, **options)
    file_path = download(relative_path)
    raise ArgumentError, 'Invalid file path' if file_path.include?("\0")

    File.open(file_path, 'rb') do |file|
      yield file if block_given?
    end
  end

  def delete_prefixed(prefix)
    full_path = "#{Setting.fileapi_path}/#{prefix}"
    uri = URI("#{@base_url}/files")
    uri.query = URI.encode_www_form(filePath: full_path)
    request = Net::HTTP::Delete.new(uri)
    request["X-Request-Token"] = @token

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end

    unless response.is_a?(Net::HTTPSuccess)
      raise "Delete failed: HTTP Status #{response.code}, Response Body: #{response.body}"
    end
  end
end
