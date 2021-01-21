//
//  TFY_TransitionDelegate.m
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/17.
//

#import "TFY_TransitionDelegate.h"

@interface TFY_TransitionDelegate ()
@property(nonatomic, strong) id<AnimatorProtocol> currentAnimator;
/// 动画负责者集合
@property(nonatomic, strong) NSMutableDictionary <NSString *, id<AnimatorProtocol>>*animators;

/// 是否为push/Presentation操作. 默认：NO，pop/dismiss
@property(nonatomic, assign) BOOL isPush;
@end

@implementation TFY_TransitionDelegate
static TFY_TransitionDelegate *_instace;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [super allocWithZone:zone];
    });
    return _instace;
}

+ (instancetype)sharedInstace {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [[self alloc] init];
    });
    return _instace;
}

- (NSMutableDictionary<NSString *,id<AnimatorProtocol>> *)animators {
    if (_animators == nil) {
        _animators = [NSMutableDictionary dictionary];
    }
    return  _animators;
}

+ (void)addAnimator:(id<AnimatorProtocol>)animator  forKey:(UIViewController *)key {
    NSString *KEY = [self keyWithViewController:key];
    [[[self sharedInstace] animators] setObject:animator forKey:KEY];
    _instace.currentAnimator = animator;
}

+ (void)removeAnimatorForKey:(UIViewController *)key {
    NSString *KEY = [self keyWithViewController:key];
    if ([[[[self sharedInstace] animators] allKeys] containsObject:KEY]) {
        [[[self sharedInstace] animators] removeObjectForKey:KEY];
        _instace.currentAnimator = nil;
    }
}

+ (id<AnimatorProtocol>)animatorForKey:(UIViewController *)key {
    NSString *KEY = [self keyWithViewController:key];
    if ([[[[self sharedInstace] animators] allKeys] containsObject:KEY]) {
        _instace.currentAnimator = [[[self sharedInstace] animators] objectForKey:KEY];
        return  _instace.currentAnimator;
    }
    return nil;
}

+ (NSString *)keyWithViewController:(UIViewController *)viewController {
    NSAssert([viewController isKindOfClass:[UIViewController class]], @"key: %@ 不是UIViewController类型]", viewController);

    return [NSString stringWithFormat:@"%p", viewController];
}

// push / pop
#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    UIViewController *key;
    if(operation == UINavigationControllerOperationPush) {
        key = toVC;
        _isPush = YES;
    }else if (operation == UINavigationControllerOperationPop) {
        key = fromVC;
        _isPush = NO;
    }else {
        _isPush = NO;
        return nil;
    }
    return [[self class] animatorForKey:key];
}

#pragma mark 转场手势交互管理者（push / pop）
- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    id <AnimatorProtocol> tempAnimator = (id<AnimatorProtocol>)animationController;
    return [self interactiveTransitionWithAnimator:tempAnimator];
}

// present / dismiss
#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    _isPush = YES;
    return [[self class] animatorForKey:presented];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    _isPush =NO;
    return [[self class] animatorForKey:dismissed];
}

#pragma mark 转场手势交互管理者（present / dismiss）
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    _isPush = YES;
    id <AnimatorProtocol> tempAnimator =  (id<AnimatorProtocol>)animator;
    return [self interactiveTransitionWithAnimator:tempAnimator];
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    _isPush = NO;
    id <AnimatorProtocol> tempAnimator =  (id<AnimatorProtocol>)animator;
    return [self interactiveTransitionWithAnimator:tempAnimator];
}

- (TFY_PercentDrivenInteractiveTransition *)interactiveTransitionWithAnimator:(id <AnimatorProtocol>)animator {
    if (_interactiveRecognizer) {
        UIRectEdge edge = [self getPopEdge];
        TFY_PercentDrivenInteractiveTransition *interactiveTransition;
        interactiveTransition = [[TFY_PercentDrivenInteractiveTransition alloc] initWithGestureRecognizer:_interactiveRecognizer edgeForDragging: edge];
        _interactiveRecognizer = nil;
        
        if ([animator respondsToSelector:@selector(percentOfFinishInteractiveTransition)]) {
            CGFloat percent = [animator percentOfFinishInteractiveTransition];
            interactiveTransition.percentOfFinishInteractiveTransition = percent;
        }
        if ([animator respondsToSelector:@selector(percentOfFinished)]) {
            interactiveTransition.percentOfFinished = [animator percentOfFinished];
        }
        if ([animator respondsToSelector:@selector(speedOfPercent)]) {
            interactiveTransition.speedOfPercent = [animator speedOfPercent];
        }
        return interactiveTransition;
    } else {
        return nil;
    }
}

- (UIRectEdge)getPopEdge {
    // 临时类型
    if(_tempInteractiveDirection >= DirectionToTop && _tempInteractiveDirection <= DirectionToRight ){
        UIRectEdge edge = getRectEdge(_tempInteractiveDirection);
        _tempInteractiveDirection = -1;
        return edge;
    }
    
    if (_isPush) {
        Direction direction = _instace.currentAnimator.interactiveDirectionOfPush;
        if (direction >= DirectionToTop) {
            return getRectEdge(direction);
        }
    }
    
    // push/Presentation direction 未设置是取pop/dismiss的值
    UIRectEdge edge = UIRectEdgeLeft;
    if ([_instace.currentAnimator respondsToSelector:@selector(interactiveDirectionOfPop)]) {
        edge = getRectEdge([_instace.currentAnimator interactiveDirectionOfPop]);
    }
    return edge;
}


@end
