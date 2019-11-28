Pod::Spec.new do |s|
    s.name             = "BleshSDKLite"
    s.version          = "5.0.1"
    s.summary          = "Blesh iOS SDK-Lite"
    s.homepage         = "https://github.com/bleshcom/Blesh-iOS-SDK-Lite"
    s.author           = { "Blesh Technology Team" => "technology@blesh.com" }
    s.source           = { :git => "https://github.com/bleshcom/Blesh-iOS-SDK-Lite.git", :tag => s.version.to_s }
  
    s.platform     = :ios, 9.0
    s.requires_arc = true
  
    s.source_files = 'BleshSDKLite.framework/Headers/*.h'
    s.vendored_frameworks = 'BleshSDKLite.framework'
    s.frameworks = 'Foundation', 'UIKit', 'CoreLocation', 'CoreTelephony'

    s.license      = {
        :type => 'Copyright',
        :text => <<-LICENSE
        Copyright 2013 - 2020 Blesh, Inc. All rights reserved.
        LICENSE
    }
  end
