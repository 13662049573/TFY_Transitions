//
//  TFY_SwipeAnimator.m
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/17.
//

#import "TFY_SwipeAnimator.h"

@implementation TFY_SwipeAnimator
#pragma mark - TLAnimatorProtocol
@synthesize transitionDuration;
@synthesize isPushOrPop;
@synthesize interactiveDirectionOfPush;

- (Direction)interactiveDirectionOfPop {
    return _popDirection;
}


+ (instancetype)animatorWithSwipeType:(SwipeType)swipeType
                        pushDirection:(Direction)pushDirection
                         popDirection:(Direction)popDirection
{
    TFY_SwipeAnimator *anm = [self new];
    anm.swipeType = swipeType;
    anm.pushDirection = pushDirection;
    anm.popDirection = popDirection;
    return anm;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return [transitionContext isAnimated] ? self.transitionDuration : 0.f;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    BOOL isPresentingOrPush;
    if(self.isPushOrPop) {
        NSInteger toIndex = [toViewController.navigationController.viewControllers indexOfObject:toViewController];
        NSInteger fromIndex = [fromViewController.navigationController.viewControllers indexOfObject:fromViewController];
        isPresentingOrPush = (toIndex > fromIndex);
    }else {
        isPresentingOrPush = (toViewController.presentingViewController == fromViewController);
    }
    
    // 1. TLSwipeTypeIn 在dismiss时需保证fromView和toView都有值
    // 2. TLSwipeTypeOut 在presetting和dismiss时需保证fromView和toView都有值
    if (!self.isPushOrPop && ((self.swipeType == SwipeTypeIn && !isPresentingOrPush) || self.swipeType == SwipeTypeOut)) {
        fromView = [self getViewWithConetoller:fromViewController];
        toView = [self getViewWithConetoller:toViewController];
    }
    
//    tl_Log(@"to:%p, fromV:%p, toSuper:%p, fromSuper: %p",toView,fromView,toView.superview,fromView.superview);
    
    // CGVector 向量
    CGVector offset = [self getOffsetIsPush:isPresentingOrPush];
    CGRect fromFrame = [transitionContext initialFrameForViewController:fromViewController];
    CGRect toFrame = [transitionContext finalFrameForViewController:toViewController];
    
    UIView *topView = nil; // 用动画的View
    UIView *bottomView = nil;
    UIView *superViewOfToView = toView.superview;
    UIView *superViewOfFromView = fromView.superview;
    if (isPresentingOrPush) {
        switch (self.swipeType) {
            case SwipeTypeInAndOut:
            case SwipeTypeIn:
                [containerView addSubview:toView];
                topView = toView;
                bottomView = fromView;
                break;
            case SwipeTypeOut:
                [containerView addSubview:fromView];
                topView = fromView;
                bottomView = toView;
                [containerView insertSubview:bottomView belowSubview:topView];
                break;
            default:
                NSAssert(NO, @"swipeType: %zi 越界[0...2]", self.swipeType);
                break;
        }
    } else {
        switch (self.swipeType) {
            case SwipeTypeInAndOut:
            case SwipeTypeOut:
                [containerView insertSubview:toView belowSubview:fromView];
                topView = fromView;
                bottomView = toView;
                break;
            case SwipeTypeIn:
                [containerView addSubview:toView];
                topView = toView;
                bottomView = fromView;
                break;
            default:
                NSAssert(NO, @"swipeType: %zi 越界[0...2]", self.swipeType);
                break;
        }
    }
    if ([topView isEqual:toView]) {
        topView.frame = [self initialFrameWhithFrame:toFrame offset:offset presentOrPush:isPresentingOrPush];
        bottomView.frame = fromFrame;
    }else{
        topView.frame = [self initialFrameWhithFrame:fromFrame offset:offset presentOrPush:isPresentingOrPush];
        bottomView.frame = toFrame;
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        CGRect frame = [topView isEqual:toView] ? toFrame : fromFrame;
        topView.frame = [self finalFrameWhithFrame:frame offset:offset presentOrPush:isPresentingOrPush];
        
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        if (wasCancelled) {
            if (self->_swipeType != SwipeTypeInAndOut) {
                [superViewOfToView addSubview:toView];
            }else{
                [toView removeFromSuperview];
            }
        }else {
            // presenting or dismiss
            if (!self->isPushOrPop) {
                // presenting
                if (isPresentingOrPush) {
                    if (self->_swipeType == SwipeTypeOut) {
                        [superViewOfFromView addSubview:fromView];
                    }
                }else { // dismiss
                    if (self->_swipeType != SwipeTypeInAndOut) {
                        [superViewOfToView addSubview:toView];
                    }
                }
            }
        }
        [transitionContext completeTransition:!wasCancelled];
    }];
}

- (UIView *)getViewWithConetoller:(UIViewController *)viewController {
    if ([viewController isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)viewController;
        return nav.topViewController.view;
    }else{
        return viewController.view;
    }
}

- (CGVector)getOffsetIsPush:(BOOL)isPush {
    Direction direction = isPush ? self.pushDirection : self.popDirection;
    CGVector offset;
    if (direction == DirectionToTop){ // 坐标轴为第四象限（为正数）
        offset = CGVectorMake(0.f, -1.f);
    }else if (direction == DirectionToBottom){
        offset = CGVectorMake(0.f, 1.f);
    }else if (direction == DirectionToLeft){
        offset = CGVectorMake(-1.f, 0.f);
    }else if (direction == DirectionToRight){
        offset = CGVectorMake(1.f, 0.f);
    }else{
        if (isPush) {
             NSAssert(NO, @"pushDirection: %zi 越界[0...3]", direction);
        }else {
            NSAssert(NO, @"popDirection: %zi 越界[0...3]", direction);
        }
        offset = CGVectorMake(0.f, 1.f); // 这句代码去警告
    }
    return offset;
}

- (CGRect)initialFrameWhithFrame:(CGRect)frame offset:(CGVector)offset presentOrPush:(BOOL)isPresentOrPush {
    NSInteger flag = 0;
    NSInteger vectorValue = offset.dx == 0 ? offset.dy : offset.dx;
    vectorValue = vectorValue > 0 ? -vectorValue : vectorValue;
    if (isPresentOrPush) {
        flag = self.swipeType == SwipeTypeOut ? 0 : vectorValue;
        
    }else {
        flag = self.swipeType == SwipeTypeIn ? vectorValue : 0;
    }
    
    CGFloat offsetX = frame.size.width * offset.dx * flag;
    CGFloat offsetY = frame.size.height * offset.dy * flag;
    return CGRectOffset(frame, offsetX, offsetY);
}

- (CGRect)finalFrameWhithFrame:(CGRect)frame offset:(CGVector)offset presentOrPush:(BOOL)isPresentOrPush {
    NSInteger flag = 0;
    NSInteger vectorValue = offset.dx == 0 ? offset.dy : offset.dx;
    vectorValue = vectorValue > 0 ? vectorValue : -vectorValue;
    if (isPresentOrPush) {
        flag = self.swipeType == SwipeTypeOut ? vectorValue : 0;
        
    }else {
        flag = self.swipeType == SwipeTypeIn ? 0 : vectorValue;
    }
    
    CGFloat offsetX = frame.size.width * offset.dx * flag;
    CGFloat offsetY = frame.size.height * offset.dy * flag;
    return CGRectOffset(frame, offsetX, offsetY);
}

@end
