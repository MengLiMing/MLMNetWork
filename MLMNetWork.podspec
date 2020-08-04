#
# Be sure to run `pod lib lint MLMNetWork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MLMNetWork'
  s.version          = '0.0.4'
  s.summary          = 'Swift网络请求'


  s.description      = <<-DESC
  MVVM响应式网络请求 - RxSwift、HandyJson、Alamofire
                       DESC

  s.homepage         = 'https://github.com/MengLiMing/MLMNetWork'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'MengLiMing' => '920459250@qq.com' }
  s.source           = { :git => 'https://github.com/MengLiMing/MLMNetWork.git', :tag => s.version.to_s }

  s.platform = :ios, '10.0'
  s.ios.deployment_target = '10.0'
  
  s.source_files = 'MLMNetWork/Classes/**/*'
  
  s.dependency 'RxSwift', '~> 5'
  s.dependency 'RxCocoa', '~> 5'
  s.dependency 'Alamofire', '~> 5.2'
  s.dependency 'HandyJSON', '~> 5.0.1'

  #  s.requires_arc = true
  # s.resource_bundles = {
  #   'MLMNetWork' => ['MLMNetWork/Assets/*.png']
  # }

  # s.frameworks = 'UIKit', 'MapKit'
end
