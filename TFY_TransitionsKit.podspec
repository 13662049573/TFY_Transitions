
Pod::Spec.new do |spec|

  spec.name         = "TFY_TransitionsKit"

  spec.version      = "2.0.0"

  spec.summary      = "控制器转换动画"

  spec.description  = <<-DESC
控制器转换动画
                   DESC

  spec.homepage     = "https://github.com/13662049573/TFY_Transitions"

  spec.license      = "MIT"
 
  spec.author       = { "田风有" => "420144542@qq.com" }
  
  spec.platform     = :ios, "12.0"


  spec.source       = { :git => "https://github.com/13662049573/TFY_Transitions.git", :tag => spec.version }


  spec.source_files  = "TFY_Transitions/TFY_TransitionsKit/TFY_TransitionsKit.h"

  spec.subspec 'Transition' do |ss|
    ss.dependency "TFY_TransitionsKit/Transition/Animator"
    ss.source_files  = "TFY_Transitions/TFY_TransitionsKit/Transition/**/*.{h,m}"
  end

  spec.subspec 'Config' do |ss|
    ss.source_files  = "TFY_Transitions/TFY_TransitionsKit/Transition/Config/**/*.{h,m}"
  end

  spec.subspec 'Animator' do |ss|
    ss.dependency "TFY_TransitionsKit/Transition/Config"
    ss.source_files  = "TFY_Transitions/TFY_TransitionsKit/Transition/Animator/**/*.{h,m}"
  end 

  spec.frameworks = "UIKit", "Foundation"


  spec.requires_arc = true

end
