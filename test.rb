require "rubygems"

@gems = Gem::Specification.all().map{|g| [g.name, g.version.to_s].join('-') }
puts @gems
