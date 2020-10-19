#
# Be sure to run `pod lib lint HSDialog.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HSDialog'
  s.version          = '0.1.0'
  s.summary          = '通用弹窗'

  s.description      = <<-DESC
  一款链式语法调用通用弹窗，使用便捷快速集成
  DESC

  s.homepage         = 'https://github.com/tukzi'
  
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'hesong_ios@163.com' => 'songhe' }
  s.source           = { :git => 'https://github.com/tukzi/HSDialog.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'HSDialog/Classes/**/*'
  
  s.resource_bundles = {
      'HSDialog' => ['HSDialog/Assets/*.png']
  }

end
