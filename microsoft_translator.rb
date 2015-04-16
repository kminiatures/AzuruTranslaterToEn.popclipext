#!/usr/bin/env ruby
# -*- coding:utf-8 -*-
require 'net/http'
require 'rexml/document'
require 'json'

# See https://datamarket.azure.com/dataset/bing/microsofttranslator
class MicrosoftTranslator
  attr_accessor :error

  DOMAIN = "api.datamarket.azure.com"
  PATH   = "/Data.ashx/Bing/MicrosoftTranslator/v1/Translate"

  def initialize(app_id, text, to: 'ja')
    @app_id = app_id
    @text = URI.escape text
    # @from = from
    @to   = to
    @error = ''
  end

  def build_query(params)
    buf = []
    params.each do |k,v|
      buf << "#{k}='#{v}'"
    end
    buf.join('&')
  end

  def request(query)
    http = Net::HTTP.new(DOMAIN, '443')
    http.use_ssl = true

    req = Net::HTTP::Get.new("#{PATH}?#{query}")
    req.basic_auth 'APPID', @app_id

    http.request(req)
  end

  def get
    response = request build_query({
      "Text" => @text,
      "To"   => @to,
      # "From" => @from
    })

    if response.message == 'OK'
      doc = REXML::Document.new(response.body)
      doc.elements['//content/m:properties/d:Text'].text
    else
      @error = "response Not-OK.#{response.message}"
    end
  end

  def self.cli_params
    buf = []
    from = 'en'
    to   = 'ja'
    ignore_next = false
    ARGV.each_with_index do |str, i|
      if ignore_next
        ignore_next = false
        next
      end

      case str
      when '-f', '--from'
        from = ARGV[i +1]
        ignore_next = true
        next
      when '-t', '--to'
        to = ARGV[i +1]
        ignore_next = true
        next
      end
      buf << str
    end

    [buf.join(" "), from, to]
  end
end
