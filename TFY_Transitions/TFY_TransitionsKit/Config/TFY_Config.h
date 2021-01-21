//
//  TFY_Config.h
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/17.
//

#import <UIKit/UIKit.h>

// 方向,指向的方向（Top：bottom --> top，动画由Top：bottom到top）
typedef enum : NSUInteger {
    DirectionToTop = 1 << 0,
    DirectionToLeft = 1 << 1,
    DirectionToBottom = 1 << 2,
    DirectionToRight = 1 << 3,
} Direction;

// TFY_SwipeAnimator动画类型：如有控制器A和B， 操作： A push to B Or B pop to A
typedef enum : NSUInteger {
    SwipeTypeInAndOut = 0, // push：B从A的上面滑入，pop：B从A的上面抽出.
    SwipeTypeIn,           // push：B从A的上面滑入，pop：A从B的上面滑入.效果类似CATransition动画中的kCATransitionMoveIn
    SwipeTypeOut,          // push：A从B的上面抽出，pop：B从A的上面抽出.效果类似CATransition动画中的kCATransitionReveal
} SwipeType;

// TFY_CATransitonAnimator 动画类型，对应官方的CATransitionType
typedef enum : NSUInteger {
    TransitionFade,
    TransitionMoveIn,
    TransitionPush,
    TransitionReveal,
    // 以下是官方未公开的API（私有，可能影响上架）
    TransitionCube,                       // 立体翻转
    TransitionSuckEffect,                 // 收缩效果.如一块布被抽走 （iOS 13 失效）
    TransitionOglFlip,                    // 翻转
    TransitionRippleEffect,               // 波纹涟漪 （iOS 13 失效）
    TransitionPageCurl,                   // 上翻页
    TransitionPageUnCurl,                 // 下翻页
    TransitionCameraIrisHollowOpen,       // 开镜头 （iOS 13 失效）
    TransitionCameraIrisHollowClose,      // 关镜头 （iOS 13 失效）
} TransitionType;



/** RGB颜色 */
#define UIColorFromRGBA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

#define UIColorFromRGB(rgbValue) UIColorFromRGBA(rgbValue, 1.0)

#define transit_Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

/** 亮灰色背景主题 */
#define transit_LightGardBgColor [UIColor groupTableViewBackgroundColor]
/** 蓝色主题 */
#define transit_BlueTintColor UIColorFromRGBA(0x0b9cf0, 1.f)
/** 红色主题 */
#define transit_RedTintColor transit_Color(220, 0, 0)
/** 绿色主题 */
#define transit_GreenTintColor transit_Color(33, 205, 65)
/** 白色主题 */
#define transit_WhiteTintColor transit_Color(255, 255, 255)
/** 字体主题 */
#define transit_TextTintColor UIColorFromRGBA(0x333333, 1.f)
/** 灰色字体主题 */
#define transit_GardTextTintColor UIColorFromRGBA(0x666666, 1.f)
/** 屏幕宽度 */
#define transit_ScreenW ([UIScreen mainScreen].bounds.size.width)
/** 屏幕高度 */
#define transit_ScreenH ([UIScreen mainScreen].bounds.size.height)
/** 状态栏高度 */
#define transit_StatusBarH ([UIApplication sharedApplication].statusBarFrame.size.height)
/** Nav Bar高度 */
#define transit_NavBarH (iMStatusBarH + 44.f)
/** Tab Bar高度 */
#define transit_TabBarH 44.f
/** iPhone X home bar */
#define transit_iPhoneXHomeBarH  (transit_isLandscape ? 21.f : 34.f)

/** 横屏 */
#define transit_isLandscape (transit_ScreenW > transit_ScreenH)

#define transit_isIPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? ((NSInteger)(([[UIScreen mainScreen] currentMode].size.height/[[UIScreen mainScreen] currentMode].size.width)*100) == 216) : NO)


#import "TFY_TransitFunction.h"
