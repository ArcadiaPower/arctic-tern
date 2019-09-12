lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name        = 'artic_tern'
  s.version     = '0.1.0'
  s.summary     = "Such!"
  s.authors     = ['Justin Doody']
  s.files       = ['lib/artic_tern.rb']

  s.add_dependency 'activesupport'
  s.add_dependency 'actionview'
  s.add_dependency 'colorize'
end
