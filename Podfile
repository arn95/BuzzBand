platform :ios, '10.3'
target 'BuzzBand' do
    pod 'Bean-iOS-OSX-SDK'
end

pre_install do |install|
    puts(`./fix-bean-pod.sh`)
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
