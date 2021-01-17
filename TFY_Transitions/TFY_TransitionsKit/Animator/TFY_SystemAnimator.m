//
//  TFY_SystemAnimator.m
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/17.
//

#import "TFY_SystemAnimator.h"

@implementation TFY_SystemAnimator

+ (instancetype)animatorWithTransitionStyle:(UIModalTransitionStyle)style {
    TFY_SystemAnimator *anmt = [self new];
    anmt.style = style;
    return anmt;
}

+ (instancetype)animatorWithStyle:(UIModalTransitionStyle)style fullScreen:(BOOL)isFullScreen {
    TFY_SystemAnimator *anmt = [self new];
    anmt.style = style;
    if (@available(iOS 13.0, *)) {
        anmt.isFullScreen = isFullScreen;
        NSAssert(
                 style != UIModalTransitionStylePartialCurl,
                 @"%s iOS 13+ 不支持 UIModalTransitionStylePartialCurl", __func__
                 );
    }else {
        anmt.isFullScreen = YES;
    }
    
    return anmt;
}


#pragma mark - TLAnimatorProtocol
@synthesize transitionDuration;
@synthesize isPushOrPop;
@synthesize interactiveDirectionOfPush;

- (Direction)interactiveDirectionOfPop {
    return DirectionToRight;
}

//
- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    
}
- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.35;
}

@end
