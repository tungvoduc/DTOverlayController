#
# Be sure to run `pod lib lint DTOverlayController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DTOverlayController'
  s.version          = '1.0.0'
  s.summary          = 'A fully customizable lay over view controller container, inspired by Facebook lay over controller.'
  s.swift_version    = '5.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A fully customizable lay over view controller container, inspired by Facebook lay over controller. DTOverlayController is extremely easy to use and customize.
                       DESC

  s.homepage         = 'https://github.com/tungvoduc/DTOverlayController'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'tungvoduc' => 'tung98.dn@gmail.com' }
  s.source           = { :git => 'https://github.com/tungvoduc/DTOverlayController.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'DTOverlayController/Classes/**/*'
end
