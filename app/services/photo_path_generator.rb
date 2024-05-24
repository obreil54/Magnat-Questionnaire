class PhotoPathGenerator
  def self.generate_path(user, hardware, response_start_date)
    formatted_date = response_start_date.strftime("%Y-%m-%d")
    "#{user.name}_#{user.id}/#{hardware.category_hard.name}/#{hardware.series}/#{formatted_date}/"
  end

  def self.generate_filename(hardware_series, response_start_date)
    formatted_date = response_start_date.strftime("%Y-%m-%d")
    base_filename = "#{hardware_series}_#{formatted_date}"

    existing_files = ActiveStorage::Blob.where("filename LIKE ?", "#{base_filename}_%.jpg").pluck(:filename)

    max_sequence_number = existing_files.map do |filename|
      sequence_match = filename.match(/_(\d{3})\.jpg\z/)
      sequence_match ? sequence_match[1].to_i : 0
    end.max || 0

    next_sequence_number = max_sequence_number + 1

    sequence_str = format("%03d", next_sequence_number)

    "#{base_filename}_#{sequence_str}.jpg"
  end
end
