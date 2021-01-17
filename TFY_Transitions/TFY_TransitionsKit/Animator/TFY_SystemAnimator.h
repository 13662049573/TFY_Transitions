//
//  TFY_SystemAnimator.h
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/17.
//

#import <Foundation/Foundation.h>
#import "TFY_AnimatorProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface TFY_SystemAnimator : NSObject<AnimatorProtocol>
/*
typedef NS_ENUM(NSInteger, UIModalTransitionStyle) {
    UIModalTransitionStyleCoverVertical = 0,
    UIModalTransitionStyleFlipHorizontal __TVOS_PROHIBITED,
    UIModalTransitionStyleCrossDissolve,
    UIModalTransitionStylePartialCurl NS_ENUM_AVAILABLE_IOS(3_2) __TVOS_PROHIBITED,
};
 */
@property(nonatomic, assign) UIModalTransitionStyle style;
/// isFullScreen default is YES，isFullScreen = NO只有iOS 13+ 才有效
@property(nonatomic, assign) BOOL isFullScreen;
///请使用‘- animatorWithStyle: fullScreen:’
+ (instancetype)animatorWithTransitionStyle:(UIModalTransitionStyle)style;

+ (instancetype)animatorWithStyle:(UIModalTransitionStyle)style fullScreen:(BOOL)isFullScreen;
@end

NS_ASSUME_NONNULL_END
