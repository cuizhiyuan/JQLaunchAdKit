#
# Be sure to run `pod lib lint JQLaunchAdKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JQLaunchAdKit'
  s.version          = '3.1.6'
  s.summary          = '开屏广告、启动广告解决方案-支持静态/动态图片广告/mp4视频广告
'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
### 特性:

* 1.支持静态/动态图片广告.
* 2.支持mp4视频广告.
* 3.支持全屏/半屏广告.
* 4.支持网络及本地资源.
* 5.兼容iPhone和iPad.
* 6.支持广告点击事件.
* 7.支持自定义跳过按钮,添加子视图.
* 8.支持设置数据等待时间.
* 9.自带图片/视频下载,缓存功能.
* 10.支持预缓存图片及视频.
* 11.支持设置完成动画.
* 12.支持清除指定资源缓存.
* 13.支持LaunchImage 和 LaunchScreen.storyboard.
* 14.等等等...
                       DESC

  s.homepage         = 'https://github.com/cuizhiyuan/JQLaunchAdKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '554561128@qq.com' => '554561128@qq.com' }
  s.source           = { :git => 'https://github.com/cuizhiyuan/JQLaunchAdKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'JQLaunchAdKit/Classes/JQLaunchAd/**/*.{h,m}'
  s.resource = 'JQLaunchAdKit/Assets/JQLaunchAdKit.bundle'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
