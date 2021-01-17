//
//  TFY_CustomAnimator.m
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/17.
//

#import "TFY_CustomAnimator.h"

@implementation TFY_CustomAnimator
#pragma mark - AnimatorProtocol
@synthesize transitionDuration;
@synthesize isPushOrPop;
@synthesize interactiveDirectionOfPush;

- (Direction)interactiveDirectionOfPop {
    return DirectionToRight;
}

+ (instancetype)animatorWithAnimation:(void (^)(id<UIViewControllerContextTransitioning> transitionContext, BOOL isPresenting))animation {
    TFY_CustomAnimator *animator = [self new];
    animator.animation = animation;
    return animator;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return [transitionContext isAnimated] ? self.transitionDuration : 0.f;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    BOOL isPresentingOrPush;
    if(self.isPushOrPop) {
        NSInteger toIndex = [toViewController.navigationController.viewControllers indexOfObject:toViewController];
        NSInteger fromIndex = [fromViewController.navigationController.viewControllers indexOfObject:fromViewController];
        isPresentingOrPush = (toIndex > fromIndex);
    }else {
        isPresentingOrPush = (toViewController.presentingViewController == fromViewController);
    }
    
    if (isPresentingOrPush) {
        toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    }
    
    if (self.animation) {
         self.animation(transitionContext, isPresentingOrPush);
    }else {
        NSAssert(NO, @"TLCustomAnimator： animation属性没有赋值");
    }
}

@end
