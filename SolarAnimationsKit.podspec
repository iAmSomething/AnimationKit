Pod::Spec.new do |s|
  s.name             = 'SolarAnimationsKit'
  s.version          = '1.0.0'
  s.summary          = 'Protocol-oriented iOS animation framework'
  s.description      = <<-DESC
    SolarAnimationsKit provides 40+ built-in animations with performance metadata,
    memory leak protection, and protocol-based custom animation architecture.
    Supports SwiftUI & UIKit with unified API.
  DESC
  s.homepage         = 'https://github.com/yourname/SolarAnimationsKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Solar' => 'yourname@example.com' }
  s.source           = { :git => 'https://github.com/yourname/SolarAnimationsKit.git', :tag => s.version.to_s }
  s.swift_version    = '6.0'
  s.ios.deployment_target = '15.0'
  s.source_files = 'Sources/**/*.swift'
end
