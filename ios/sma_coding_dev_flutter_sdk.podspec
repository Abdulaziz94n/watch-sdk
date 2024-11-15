#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint coding_dev_flutter_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'sma_coding_dev_flutter_sdk'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.platform = :ios, '13.0'
  s.source_files = 'Classes/**/*'
  s.vendored_frameworks = 'Frameworks/RTKOTASDK.framework','Frameworks/RTKLEFoundation.framework','Frameworks/JL_BLEKit.framework','Frameworks/JLDialUnit.framework','Frameworks/ZipZap.framework','Frameworks/BeaconMonitor.framework'
  s.dependency 'Flutter'


  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
