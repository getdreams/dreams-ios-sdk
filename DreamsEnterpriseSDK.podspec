Pod::Spec.new do |s|
  s.name           = "DreamsEnterpriseSDK"
  s.version        = "1.0.0"
  s.summary        = "Dreams Enterprise iOS SDK"

  s.homepage       = "http://dreamstech.com"
  s.license        = { :type => 'MPL 2.0', :file => 'LICENSE' }
  s.author         = { "Dreams Technology AB" => "didde.brockman@dreamstech.com" }
  s.platform       = :ios, "10.3"

  s.source         = { :git => "https://github.com/dreamstechnology/dreams-ios-sdk.git", :tag => "#{s.version}" }
  s.source_files   = "Sources/*.swift"
  s.frameworks     = "WebKit"
  s.swift_version  = "5.0"
end
