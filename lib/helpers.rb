module Helpers
  def self.clean_mac(mac)
    mac = URI.decode(mac)
    mac = (mac.include? ':') ? mac.gsub!(':','-') : (mac.include? '-') ? mac : add_dash(mac)
    mac.upcase
  end
  
  def self.add_dash(mac)
    mac.scan(/.{2}/).join('-') rescue mac
  end
end
