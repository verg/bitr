
def handle_encoding(string)
  string.encode('binary', {:invalid => :replace, :undef => :replace, :replace => '?'})
end
