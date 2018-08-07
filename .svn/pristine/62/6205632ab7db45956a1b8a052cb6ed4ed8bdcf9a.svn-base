platform :ios, '9.0'

target 'DaiJia' do
    
use_frameworks!

pod 'Masonry'
pod 'AFNetworking'
pod 'MJRefresh'
pod 'IQKeyboardManager'
pod 'MBProgressHUD'
pod 'GTSDK', '2.2.0.0-noidfa'
pod 'SDWebImage'
#pod 'BaiduMapKit'
pod 'SnapKit','3.2.0'
pod 'Alamofire','~> 4.3.0'
pod 'Kingfisher', '4.5.0'

end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings['PROVISIONING_PROFILE_SPECIFIER'] = ''
        end
    end
