Pod::Spec.new do |s|
  s.name             = 'ApiKit'
  s.version          = '0.0.1'
  s.swift_versions   = ['5.7']
  s.summary          = 'ApiKit is something...'
  s.description      = 'ApiKit is something...great?'

  s.homepage         = 'https://github.com/danielsaidi/ApiKit'
  s.license          = { :type => 'NONE', :file => 'LICENSE' }
  s.author           = { 'Daniel Saidi' => 'daniel.saidi@gmail.com' }
  s.source           = { :git => 'https://github.com/danielsaidi/ApiKit.git', :tag => s.version.to_s }
  
  s.swift_version = '5.7'
  s.ios.deployment_target = '13.0'
  s.tvos.deployment_target = '13.0'
  s.macos.deployment_target = '11.0'
  
  s.source_files = 'Sources/ApiKit/**/*.swift'
end
