# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'LaowaiQuestions' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for LaowaiQuestions
  
  target 'LaowaiQuestionsTests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  target 'LaowaiQuestionsUITests' do
    # Pods for testing
  end
  
  #Network pasring
  pod 'SwiftyJSON'
  
  #Network
  pod 'Alamofire', '~> 5.0'
  
  #Load image
  pod 'Kingfisher', '~> 7.6.1'


  #for HUD
  pod 'JGProgressHUD'
  pod 'SVProgressHUD'
  # for keyboard managment
#  pod 'IQKeyboardManager' #iOS8 and later
  
  #  pod 'IQKeyboardManagerSwift'
  
  #for making toast
  pod 'Toast-Swift', '~> 5.0.1'
  
  
  #  pod 'ActionSheetPicker-3.0', '~> 2.3.0'
  
  pod 'FittedSheets'
  
  
  pod 'DropDown'
  
  pod 'ImageSlideshow'
  
  pod 'ImageSlideshow/Kingfisher'
  
  
  pod 'ZKProgressHUD'
  
  pod 'Gallery'
  #  pod 'Lightbox'
  #  pod 'MASegmentedControl'
  
  pod 'MOLH'
  
  pod 'Pushy', '1.0.32'
  
  pod 'BaiduMapKit' ,  '~> 6.3'
  #  '6.0.0'
  
  pod 'BMKLocationKit'
  pod 'CountryPickerView'
  
  pod 'NVActivityIndicatorView'
  
  pod 'MSRichLinkPreview'
  
  pod 'ActiveLabel'
  
  pod 'WechatOpenSDK-XCFramework'

#  pod 'WechatOpenSDK'
#  ,  '~> 1.8.0'
  
  pod 'KTCenterFlowLayout'

  //
  pod 'CropViewController'
  
#  pod 'FirebaseCrashlytics'
  
  # Pods for MyRealmProject
  pod 'RealmSwift', '~>10'
  
  pod "BSImagePicker"
  pod 'YPImagePicker'

  pod 'RxSwift', '~> 5.1.0'
  pod 'RxCocoa', '~> 5.1.0'
  pod 'CleanyModal'
  pod 'RxDataSources'
  
  pod 'KeychainSwift', '~> 20.0'
end

deployment_target = '11.0'

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = deployment_target
            end
        end
        project.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = deployment_target
        end
    end
end
