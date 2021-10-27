
def shared
#  use_frameworks!
  inhibit_all_warnings!
  use_modular_headers!
  
  pod 'SwiftyBeaver', '~> 1.9.5'
  pod 'Models', :path => './'
  pod 'KeychainAccess', '~> 4.2.2'
end

def tests
  inhibit_all_warnings!
  use_modular_headers!
  
  pod 'SwiftyBeaver', '~> 1.9.5'
  pod 'Models', :path => './'
end

target 'ModelsTests' do
  platform :osx, '10.15'
  tests
end

target 'Buildio (iOS)' do
  platform :ios, '14.0'
  shared
end

target 'Buildio (macOS)' do
  platform :osx, '10.15'
  shared
end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
#    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      config.build_settings['ENABLE_BITCODE'] = 'NO'
#      config.build_settings['VALID_ARCHS'] = 'arm64'
      config.build_settings['APPLICATION_EXTENSION_API_ONLY'] = 'YES'
      config.build_settings.delete('ARCHS')
    end
  end
end
