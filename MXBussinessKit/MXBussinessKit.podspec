#
#  Be sure to run `pod spec lint MXBussinessKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "MXBussinessKit"
  spec.version      = "0.0.1"
  spec.summary      = "逻辑层抽取"
  spec.description  = <<-DESC
                      逻辑层抽取
                      DESC

  spec.homepage     = "https://github.com/mhqamx/MXBusinessKit.git"
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author             = { "maxiao" => "maxiao@seaway.net.cn" }
  spec.platform = :ios, "8.0"
  spec.source       = { :git => "https://github.com/mhqamx/MXBusinessKit.git", :tag => spec.version.to_s }
  spec.source_files  = "Classes",  "MXBussinessKit/**/**/*.{h,m,mm}"
  
  spec.dependency 'FMDB', '~>2.7.2'
  # spec.dependency 'MaxSqlite', '~>1.0.0'
  spec.dependency 'AFNetworking', '~>3.1.0'
  spec.dependency 'MXContacts', '~>1.0.0'

end
