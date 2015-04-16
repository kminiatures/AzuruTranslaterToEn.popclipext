
class Translate
  def get_app_id
    path = File.expand_path('../', __FILE__).split("/")
    user_dir = [path[1], path[2]].join("/")

    app_id_file = "/#{user_dir}/.MicrosoftAzureTranslatorAppId.txt"
    unless File.exists? app_id_file
      raise "Get Microsoft Translator App ID. https://datamarket.azure.com/dataset/bing/microsofttranslator"
    end

    File.read(app_id_file).strip
  end

  def print(to = 'ja')
    text = ENV['POPCLIP_TEXT']
    translator = MicrosoftTranslator.new(get_app_id, text, to: to)
    if r = translator.get
      puts r
    else
      p "Error"
      puts r
    end
  end
end
