require "active_storage/service"
require "net/http"
require "tempfile"

class ActiveStorage::Service::CustomFileService < ActiveStorage::Service
  def initialize(token:, base_url:, **options)
    @token, @base_url = token, base_url
  end

  def upload(relative_path, io, checksum: nil, **)
    blob = ActiveStorage::Blob.find_by(key: relative_path)
    custom_path = blob.metadata["custom_path"]

    create_readme_if_needed(custom_path)

    full_path = "#{Setting.fileapi_path}#{custom_path}#{blob.filename.to_s}"

    uri = URI("#{@base_url}/files")
    request = Net::HTTP::Post.new(uri)
    request["X-Request-Token"] = @token
    request.set_form({'file' => io, 'filePath' => full_path}, 'multipart/form-data')

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https', read_timeout: 1000, open_timeout: 1000) do |http|
      http.request(request)
    end
    unless response.is_a?(Net::HTTPSuccess)
      raise "Upload failed: HTTP Status #{response.code}, Response Body: #{response.body}"
    end
  end

  def download(relative_path)
    blob = ActiveStorage::Blob.find_by(key: relative_path)
    custom_path = blob.metadata["custom_path"]
    full_path = "#{Setting.fileapi_path}#{custom_path}#{blob.filename.to_s}"

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

  def delete(key)
    blob = ActiveStorage::Blob.find_by(key: key)

    if blob.nil?
      Rails.logger.error "Blob not found for key: #{key}"
    end

    custom_path = blob.metadata["custom_path"]
    full_path = "#{Setting.fileapi_path}#{custom_path}#{blob.filename.to_s}"

    uri = URI("#{@base_url}/files")
    uri.query = URI.encode_www_form(filePath: full_path)
    request = Net::HTTP::Delete.new(uri)
    request["X-Request-Token"] = @token
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end

    unless response.is_a?(Net::HTTPSuccess)
      Rails.logger.error "Delete failed: HTTP Status #{response.code}, Response Body: #{response.body}"
      raise "Delete failed"
    else
      Rails.logger.info "Deleted file: #{full_path}"
    end
  end

  def exist?(relative_path)
    if relative_path.end_with?("Readme.txt")
      full_path = relative_path
    else
      blob = ActiveStorage::Blob.find_by(key: relative_path)
      custom_path = blob.metadata["custom_path"]
      full_path = "#{Setting.fileapi_path}#{custom_path}#{blob.filename.to_s}"
    end

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
    blob = ActiveStorage::Blob.find_by(key: relative_path)
    custom_path = blob.metadata["custom_path"]
    full_path = "#{Setting.fileapi_path}#{custom_path}#{blob.filename.to_s}"
    "#{@base_url}/files?filePath=#{full_path}"
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

  private

  def create_readme_if_needed(custom_path)
    category_hard_path = File.join(Setting.fileapi_path, custom_path.split('/')[0..1].join('/'))
    readme_path = File.join(category_hard_path, "Readme.txt")

    unless exist?(readme_path)
      questionnaire_name = get_questionnaire_name_from_path(custom_path)
      content = "Создано в рамках прохождения опроса #{questionnaire_name}"

      Tempfile.create('Readme') do |tempfile|
        tempfile.write(content)
        tempfile.rewind

        uri = URI("#{@base_url}/files")
        request = Net::HTTP::Post.new(uri)
        request["X-Request-Token"] = @token
        request.set_form({'file' => tempfile, 'filePath' => readme_path}, 'multipart/form-data')

        response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https', read_timeout: 1000, open_timeout: 1000) do |http|
          http.request(request)
        end

        unless response.is_a?(Net::HTTPSuccess)
          raise "Readme creation failed: HTTP Status #{response.code}, Response Body: #{response.body}"
        end
      end
    end
  end

  def get_questionnaire_name_from_path(custom_path)
    Questionnaire.find_by(status: true).name
  end
end
