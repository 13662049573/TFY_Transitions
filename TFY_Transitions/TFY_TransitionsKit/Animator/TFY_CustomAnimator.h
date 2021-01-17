//
//  TFY_CustomAnimator.h
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/17.
//

#import <Foundation/Foundation.h>
#import "TFY_AnimatorProtocol.h"

/// 自定义动画样式
typedef void(^TransitionAnimation)(id <UIViewControllerContextTransitioning>_Nonnull, BOOL);

NS_ASSUME_NONNULL_BEGIN

@interface TFY_CustomAnimator : NSObject<AnimatorProtocol>
@property(nonatomic, copy) TransitionAnimation animation;
+ (instancetype)animatorWithAnimation:(void (^)(id<UIViewControllerContextTransitioning> transitionContext, BOOL isPresenting))animation;
@end

NS_ASSUME_NONNULL_END
