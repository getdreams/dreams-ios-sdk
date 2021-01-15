Pod::Spec.new do |s|
  s.name           = "Dreams"
  s.version        = "0.1.0"
  s.summary        = "Dreams iOS SDK"

  s.homepage       = "http://getdreams.com"
  s.license        = { :type => 'MPL 2.0', :file => 'LICENSE' }
  s.author         = { "Dreams AB" => "hello@getdreams.com" }
  s.platform       = :ios, "10.3"

  s.source         = { :git => "https://github.com/getdreams/dreams-ios-sdk.git", :tag => "#{s.version}" }
  s.source_files   = "Sources/*.swift"
  s.frameworks     = "WebKit"
  s.swift_version  = "5.0"
end
