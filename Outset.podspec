Pod::Spec.new do |s|
  s.name = 'Outset'
  s.version = '0.1.0'
  s.license = 'MIT'
  s.summary = 'Distributed hash table library for iOS and Mac OS X'
  s.homepage = 'https://github.com/jeremytregunna/Outset'
  s.authors = { 'Jeremy Tregunna' => 'jeremy@tregunna.ca' }
  s.source = { :git => 'https://github.com/jeremytregunna/Outset.git', :tag => '0.1.0' }
  s.requires_arc = true
  s.source_files = "Outset/Outset.{h,m}"
  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'
end
