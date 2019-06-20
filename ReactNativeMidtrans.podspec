require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "ReactNativeMidtrans"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = "https://github.com/adrianha/react-native-midtrans"
  s.license      = "MIT"
  s.author       = { "Adrian Hartanto" => "s.adrianh@gmail.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/adrianha/react-native-midtrans.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m}"
  s.requires_arc = true

  s.dependency "React"
  s.dependency "MidtransCoreKit"
  s.dependency "MidtransKit"
  
end
