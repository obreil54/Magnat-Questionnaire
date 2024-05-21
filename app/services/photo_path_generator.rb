class PhotoPathGenerator
  def self.generate_path(user, hardware, response_start_date)
    formatted_date = response_start_date.strftime("%Y-%m-%d")
    "#{user.name}_#{user.id}/#{hardware.category_hard.name}/#{hardware.series}/#{formatted_date}/"
  end

  def self.generate_filename(hardware_series, response_start_date)
    formatted_date = response_start_date.strftime("%Y-%m-%d")
    "#{hardware_series}#{formatted_date}.jpg"
  end
end
