# Test app for liquidsoap on heroku.

# Set logging to stdout
set("log.file", false)
set("log.stdout", true)

# Grab port
port = list.hd(get_process_lines("echo $PORT"))
port = 
  if port == "" then
    8000
  else
    int_of_string(port)
  end

# Register a "Hello World!" handler at "/hello"
def hello(~method,~protocol,~data,~headers,uri) =
   http_response(
     protocol=protocol,
     code=200,
     data="Hello World!"
   )
end

harbor.http.register(port=port,"/hello", hello)

# Grab radiopi's reggae channel
s = input.http("http://radiopi.org:8080/reggae")

# Output it at mountpoint "/test" in mp3 format.
output.harbor(%mp3, port=port, mount="test",
              fallible=true, s)

