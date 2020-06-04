Pod::Spec.new do |s|
  s.name         = "TelegramColorPicker"
  s.version      = "1.0.0"
  s.summary      = "Simple telegram style color picker build in swift."
  s.homepage     = "https://github.com/IrelDev/TelegramColorPicker"
  s.swift_version= '5.0'

  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = "Kirill Pustovalov"
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/IrelDev/TelegramColorPicker.git", :tag => "#{s.version}" }
  s.source_files = "Source/**/*.swift"

end
