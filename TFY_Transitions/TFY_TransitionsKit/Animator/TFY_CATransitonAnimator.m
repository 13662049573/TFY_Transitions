//
//  TFY_CATransitonAnimator.m
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/17.
//

#import "TFY_CATransitonAnimator.h"

@interface TFY_CATransitonAnimator ()<CAAnimationDelegate>
{
    id<UIViewControllerContextTransitioning> _transitionContext;
    BOOL _isPresenting;
}
@end

@implementation TFY_CATransitonAnimator

#pragma mark - TFY_AnimatorProtocol
@synthesize transitionDuration;
@synthesize isPushOrPop;
@synthesize interactiveDirectionOfPush;

- (Direction)interactiveDirectionOfPop {
    return _directionOfDismiss;
}

- (CGFloat)percentOfFinishInteractiveTransition {
    return 0;
}

#pragma mark - creat instancetype
+ (instancetype)animatorWithTransitionType:(TransitionType)tType
                                 direction:(Direction)direction
                   transitionTypeOfDismiss:(TransitionType)tTypeOfDismiss
                        directionOfDismiss:(Direction)directionOfDismiss
{
    if (@available(iOS 13.0, *)) {
        BOOL flag = tType != TransitionSuckEffect &&
                    tType != TransitionRippleEffect &&
                    tType != TransitionCameraIrisHollowOpen &&
                    tType != TransitionCameraIrisHollowClose &&
                    tTypeOfDismiss != TransitionSuckEffect &&
                    tTypeOfDismiss != TransitionRippleEffect &&
                    tTypeOfDismiss != TransitionCameraIrisHollowOpen &&
                    tTypeOfDismiss != TransitionCameraIrisHollowClose;
        
        NSAssert(flag, @"TFY_CATransitonAnimator：您使用了在iOS 13+ 无效TFY_TransitionType");
    }
    
    TFY_CATransitonAnimator *animator = [self new];
    animator.tType = tType;
    animator.direction = direction;
    animator.tTypeOfDismiss = tTypeOfDismiss;
    animator.directionOfDismiss = directionOfDismiss;
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
    
    UIView *containerView = transitionContext.containerView;
    UIView *fromView;
    UIView *toView;
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) { // iOS 8+ fromView/toView可能为nil
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    } else {
        fromView = fromViewController.view;
        toView = toViewController.view;
    }
    
    BOOL isPresenting;
    if(self.isPushOrPop) {
        NSInteger toIndex = [toViewController.navigationController.viewControllers indexOfObject:toViewController];
        NSInteger fromIndex = [fromViewController.navigationController.viewControllers indexOfObject:fromViewController];
        isPresenting = (toIndex > fromIndex);
    }else {
        isPresenting = (toViewController.presentingViewController == fromViewController);
    }
    
    _isPresenting = isPresenting;
    if (isPresenting)
        toView.frame = [transitionContext finalFrameForViewController:toViewController];
        [containerView addSubview:toView];
    
    if (!isPresenting) { // dismiss
        if (self.isPushOrPop) {
            [containerView addSubview:toView];
        }else {
            // 对于dismiss动画，我们希望fromView滑开，显示toView。
            // 因此，我们必须将toView放在containerView上，下面则是创建一个toView快照，并将其当作toView
            toView = [toViewController.view snapshotViewAfterScreenUpdates:NO];
            [containerView addSubview:toView];
            toView.tag = 100;
        }
    }
    
    _transitionContext = transitionContext;
    CATransition *animation = [CATransition animation];
    animation.duration = [self transitionDuration:transitionContext];
    animation.type =  getType( isPresenting ? self.tType : self.tTypeOfDismiss);
    animation.subtype = getSubtype(isPresenting ? self.direction : self.directionOfDismiss);
    animation.delegate = self;
    animation.removedOnCompletion = YES;
    
    [containerView.window.layer addAnimation:animation forKey:nil];
}

NSString * getType(TransitionType type) {
    NSString *text = @"";
    switch (type) {
        case TransitionFade: //淡化效果
            text =  @"fade";
            break;
        case TransitionMoveIn://滑入效果
            text =  @"moveIn";
            break;
        case TransitionPush: //推进效果
            text =  @"push";
            break;
        case TransitionReveal://滑出效果
            text =  @"reveal";
            break;
        case TransitionCube: //立方体效果
            text =  @"cube";
            break;
        case TransitionSuckEffect://吮吸效果
            text =  @"suckEffect";
            break;
        case TransitionOglFlip: //翻转效果
            text =  @"oglFlip";
            break;
        case TransitionRippleEffect: //波纹效果
            text =  @"rippleEffect";
            break;
        case TransitionPageCurl://翻页效果
            text =  @"pageCurl";
            break;
        case TransitionPageUnCurl://反翻页效果
            text =  @"pageUnCurl";
            break;
        case TransitionCameraIrisHollowOpen: //开镜头效果
            text =  @"cameraIrisHollowOpen";
            break;
        case TransitionCameraIrisHollowClose://关镜头效果
            text =  @"cameraIrisHollowClose";
            break;
        default:
            break;
    }
    return text;
}


NSString * getSubtype(Direction direction) {
    NSString *subtype = @"";
    if (direction == DirectionToTop) {
        subtype = @"fromTop";
    }else if(direction == DirectionToLeft) {
        subtype = @"fromRight";
    }else if(direction == DirectionToBottom) {
        subtype = @"fromBottom";
    }else if(direction == DirectionToRight) {
        subtype = @"fromLeft";
    }
    
    return subtype;
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (!_isPresenting) {
        UIView *view = [_transitionContext.containerView viewWithTag:100];
        if (view) {
            [view removeFromSuperview];
        }
    }
    if(flag){
        BOOL wasCancelled = [_transitionContext transitionWasCancelled];
        [_transitionContext completeTransition:!wasCancelled];
    }else {
        [_transitionContext completeTransition:NO];
    }
    
    _transitionContext = nil;
}


@end
