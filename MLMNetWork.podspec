#
# Be sure to run `pod lib lint MLMNetWork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MLMNetWork'
  s.version          = '0.0.3'
  s.summary          = 'Swift网络请求'


  s.description      = <<-DESC
  MVVM响应式网络请求 - RxSwift、HandyJson、Alamofire
                       DESC

  s.homepage         = 'https://github.com/MengLiMing/MLMNetWork'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'MengLiMing' => '920459250@qq.com' }
  s.platform = :ios, '9.0'
  s.ios.deployment_target = '9.0'
  
  s.source           = { :git => 'https://github.com/MengLiMing/MLMNetWork.git', :tag => s.version.to_s }
  s.source_files = 'MLMNetWork/Classes/**/*'
  
  s.requires_arc = true
  
  s.dependency 'HandyJSON', '~> 5.0.1'
  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
  s.dependency 'Alamofire'
  s.dependency 'AFNetworking'
  
  # s.resource_bundles = {
  #   'MLMNetWork' => ['MLMNetWork/Assets/*.png']
  # }

  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
