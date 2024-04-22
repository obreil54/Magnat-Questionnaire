require "active_storage/service"
require "net/http"
require "tempfile"

class ActiveStorage::Service::CustomFileService < ActiveStorage::Service
  def initialize(token:, base_url:, **options)
    @token, @base_url = token, base_url
  end

  def upload(key, io, checksum: nil, **)
    uri = URI("#{@base_url}/files")
    request = Net::HTTP::Post.new(uri)
    request["X-Request-Token"] = @token
    request.set_form({'file' => io, 'filePath' => "it-audit/#{key}"}, 'multipart/form-data')
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https', read_timeout: 500, open_timeout: 500) do |http|
      http.request(request)
    end
    unless response.is_a?(Net::HTTPSuccess)
      raise "Upload failed: HTTP Status #{response.code}, Response Body: #{response.body}"
    end
  end

  def download(key)
    uri = URI("#{@base_url}/files")
    uri.query = URI.encode_www_form(filePath: "it-audit/#{key}")
    request = Net::HTTP::Get.new(uri)
    request["X-Request-Token"] = @token
    tempfile = Tempfile.new([key, '.tmp'], binmode: true)

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

  def delete(key)
    uri = URI("#{@base_url}/files")
    uri.query = URI.encode_www_form(filePath: "it-audit/#{key}")
    request = Net::HTTP::Delete.new(uri)
    request["X-Request-Token"] = @token
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end
    raise "Delete failed" unless response.is_a?(Net::HTTPSuccess)
  end

  def exist?(key)
    uri = URI("#{@base_url}/files")
    uri.query = URI.encode_www_form(filePath: "it-audit/#{key}")
    request = Net::HTTP::Head.new(uri)
    request["X-Request-Token"] = @token
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end
    response.is_a?(Net::HTTPSuccess)
  end

  def url(key, expires_in: nil, filename: nil, content_type: nil, disposition: nil, **options)
    "#{@base_url}/files?filePath=it-audit/#{key}&X-Request-Token=#{@token}"
  end

  def open(key, checksum: nil, **options)
    file_path = download(key)
    raise ArgumentError, 'Invalid file path' if file_path.include?("\0")

    File.open(file_path, 'rb') do |file|
      yield file if block_given?
    end
  end

  def delete_prefixed(prefix)
    uri = URI("#{@base_url}/files")
    uri.query = URI.encode_www_form(filePath: "it-audit/#{prefix}")
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
