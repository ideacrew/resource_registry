require 'securerandom'

module ResourceRegistry
  class Compactor
    RADIX = 36

    CHARSET     = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    BASE        = 62
    CODE_LENGTH = 6


    def encode(key)
      key.to_s + (salt.to_s).reverse.to_i.to_s(36)
    end

    def decode(code)
      code.to_i(36).to_s.reverse.chop
    end

    def generate
      SecureRandom.base64(RADIX)
    end

    def encode_base62
      url36 = Digest::MD5.hexdigest(long_url+"in salt we trust").slice(0..6)
      
      base62 = ['0'..'9','A'..'Z','a'..'z'].map{|a| a.to_a}.flatten 
      base36 = {}

      ['0'..'9','a'..'z'].map{|range| range.to_a}.flatten.each_with_index{|char, position| base36[char] = position} 
      url10 = 0
      url62 = "" 

      # convert to base10
      url36.reverse.chars.to_a.each_with_index { |c,i| url10 += base36[c] * (36 ** i)} 
      # convert to base62 
      6.times { |i| url62 << base62[url10 % 62]; url10 = url10 / 62 } 
    end


    def self.encode(id)
      code = ""
      while (id.length > 0) do
        code = CHARSET[id % BASE].chr + code
        id = id / BASE
      end

      (code.length > CODE_LENGTH) ? "" : "0" * (CODE_LENGTH - code.length) + code 
    end

    def self.decode(code)
      return -1 if code.length != CODE_LENGTH
      id = 0
      for i in 0..(CODE_LENGTH - 1) do
        n = CHARSET.index(code[i])
        return -1 if n.nil?
        id += n * (BASE ** (CODE_LENGTH - i - 1))
      end
      return id
    end
  end
end