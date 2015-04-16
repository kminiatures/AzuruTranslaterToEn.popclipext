#!/usr/bin/env ruby

dir = File.dirname File.expand_path('./', __FILE__)
require File.join(dir, 'microsoft_translator')
require File.join(dir, 'translate')

begin
  Translate.new.print('en')
rescue => e
  puts e.message
end
