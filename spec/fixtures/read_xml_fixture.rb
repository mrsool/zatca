def read_xml_fixture(file_name)
  file_path = File.join(__dir__, "xml", file_name)

  File.read(file_path)
end
