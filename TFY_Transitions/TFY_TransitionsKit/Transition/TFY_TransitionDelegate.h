//
//  TFY_TransitionDelegate.h
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/17.
//

#import <Foundation/Foundation.h>
#import "TFY_AnimatorProtocol.h"
#import "TFY_PercentDrivenInteractiveTransition.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFY_TransitionDelegate : NSObject<UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>
// 交互手势(滑动方向即动画方向)。 必须在手势唤醒的时候(UIGestureRecognizerStateBegan)赋值，否则提前赋值会导致转场失败
@property (nonatomic, weak) UIPanGestureRecognizer * _Nullable interactiveRecognizer;

// 临时交互手势的方向（每次唤醒手势都需要重新设置）--> 只生效一次（优先级最高）
@property (nonatomic, assign) Direction tempInteractiveDirection;

/// 采用单例模式是为了实现，多级Push转场，防止后面的转场覆盖前面的，导致pop动画被后面的取代
+ (instancetype)sharedInstace;
+ (void)addAnimator:(id<AnimatorProtocol>)animator  forKey:(UIViewController *)key;
+ (void)removeAnimatorForKey:(UIViewController *)key;
+ (id<AnimatorProtocol>)animatorForKey:(UIViewController *)key;

@end

NS_ASSUME_NONNULL_END
