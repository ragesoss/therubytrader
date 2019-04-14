require 'webdrivers'
require 'watir'
require 'base64'

class MapFetcher
  attr_reader :browser

  def initialize
    @browser = Watir::Browser.new :chrome, headless: true
  end

  def fetch_map
    @browser.goto random_map_url
    sleep 4 # wait for map to render
    download_map
  end

  def download_map
    script = "return document.getElementById('map').toDataURL('image/png')"
    # Return a base64 string of the image, which beings "data:image/png;base64,"
    # We don't need those first 21 characters.
    image = @browser.execute_script script
    File.write 'overworld.png', Base64.decode64(image[22..])
    @browser.screenshot.save 'screenshot.png'
  end

  def random_map_url
    @seed = rand 1..10000
    @north_temp = rand(-11..11) / 10.0
    @south_temp = rand(-11..11) / 10.0
    @rainfall = rand(-8..10) / 10.0
    @variant = rand(0..9)
    @persistence = [-1, -0.9, -0.8, -0.7, -0.6, -0.5, -0.4, -0.3].sample
    "https://www.redblobgames.com/maps/mapgen2/embed.html" +
      "#seed=#@seed" +
      "&size=huge&noisy-fills=&noisy-edges=true&biomes=true&icons=false" +
      "&north-temperature=#@north_temp" +
      "&south-temperature=#@south_temp" +
      "&rainfall=#@rainfall" +
      "&persistence=#@persistence"
  end
end