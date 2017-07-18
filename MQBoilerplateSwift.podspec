Pod::Spec.new do |s|

  s.name         = "MQBoilerplateSwift"
  s.version      = "4.0"
  s.summary      = "MQBoilerplateSwift is a Swift framework containing all the code that I keep reusing across my iOS app projects."
  s.homepage     = "https://github.com/jaarce/MQBoilerplateSwift"
  s.license      = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.author             = { "JA Arce" => "jarce@teamimpact.com" }
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/jaarce/MQBoilerplateSwift.git", :tag => "4.0.1" }
  s.source_files  = "MQBoilerplateSwift/**/*.{swift}"
  s.requires_arc = true

end
