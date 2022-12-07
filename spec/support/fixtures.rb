def fixtures_dir
  File.join(File.dirname(__FILE__), "..", "fixtures")
end

def read_xml_fixture(file_name)
  file_path = File.join(fixtures_dir, "xml", file_name)

  File.read(file_path)
end

def read_certificate(file_name)
  File.read(certificate_path(file_name))
end

def private_key_fixtures_path(file_name)
  File.join(fixtures_dir, "private_keys", file_name)
end

def certificate_path(file_name)
  File.join(fixtures_dir, "certificates", file_name)
end
