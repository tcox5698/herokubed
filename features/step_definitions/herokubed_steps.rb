require 'open3'
require 'pty'

def flush_input_out(output)
  begin
    sofar = output.read_nonblock 1024
    error = "stdin received empty string. Set env variables for HEROKU_USER_NAME and HEROKU_PASSWORD."
    expect(sofar.chomp.strip).not_to be_empty, error
  rescue => e
    puts "exception reading output: #{e}"
  end
end

def flush_input(input_text, input_stream, output_stream)
  input_stream.print(input_text)
  flush_input_out(output_stream)
end

Given(/^I have logged into heroku$/) do
  expect(`heroku auth:logout`).to include 'cleared'

  PTY.spawn('heroku auth:login') do |output, input, pid|
    flush_input( "#{ENV['HEROKU_USER_NAME']}\n", input, output)
    flush_input("#{ENV['HEROKU_PASSWORD']}\n", input, output)
    input.close

    output.each_line do |line|
      expect(line).not_to match /failure/
    end
  end

  expect(`heroku auth:token`.chomp.size).to eq 36
end