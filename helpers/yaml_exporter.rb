require 'yaml'

class YamlExporter
  def export(file, holidays)
    holidays_hash = { File.basename(file.path, '.yml') => holidays }
    file.write(holidays_hash.to_yaml)
  end
end
