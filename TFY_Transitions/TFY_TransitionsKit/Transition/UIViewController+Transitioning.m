//
//  UIViewController+Transitioning.m
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/17.
//

#import "UIViewController+Transitioning.h"
#import <objc/runtime.h>
#import "TFY_TransitionDelegate.h"
#import "TFY_CATransitonAnimator.h"
#import "TFY_SwipeAnimator.h"
#import "TFY_CustomAnimator.h"
#import "TFY_SystemAnimator.h"

@implementation UIViewController (Transitioning)

#pragma mark Runtime 方法交换
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = [UIViewController class];
        Method method1 = class_getInstanceMethod(cls, NSSelectorFromString(@"dealloc"));
        Method method2 = class_getInstanceMethod(cls, @selector(tfy_dealloc));
        method_exchangeImplementations(method1, method2);
    });
}

- (void)tfy_dealloc{
    [TFY_TransitionDelegate removeAnimatorForKey:self];
    [self tfy_dealloc];
}

#pragma mark Runtime 对象关联
- (void)setTransitionDelegate:(TFY_TransitionDelegate * _Nonnull)transitionDelegate {
    objc_setAssociatedObject(self, @selector(transitionDelegate), transitionDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TFY_TransitionDelegate *)transitionDelegate {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setWillPresentViewController:(UIViewController * _Nullable)willPresentViewController{
    objc_setAssociatedObject(self, @selector(willPresentViewController), willPresentViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController *)willPresentViewController {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDisableInteractivePopGestureRecognizer:(BOOL)disableInteractivePopGestureRecognizer {
    objc_setAssociatedObject(self,
                             @selector(disableInteractivePopGestureRecognizer),
                             @(disableInteractivePopGestureRecognizer),
                             OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)disableInteractivePopGestureRecognizer {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

#pragma mark 注册手势
// push or present
- (void)registerInteractiveTransitionToViewController:(UIViewController *)viewController animator:(id <AnimatorProtocol>)animator
{
    // 手势
    Direction direction = animator.interactiveDirectionOfPush;
    if (direction < DirectionToTop) {
        if ([animator respondsToSelector:@selector(interactiveDirectionOfPop)]) {
            direction = [animator interactiveDirectionOfPop];
        }
    }
    SEL sel = @selector(interactivePushRecognizerAction:);
    UIScreenEdgePanGestureRecognizer *interactiveTransitionRecognizer;
    if (@available(iOS 13.0, *)) {
        // UIScreenEdgePanGestureRecognizer 在iOS 13 好像失效，暂时用自定义手势代替
        interactiveTransitionRecognizer = (UIScreenEdgePanGestureRecognizer *)[[TFY_ScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:sel];
    }else {
        interactiveTransitionRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:sel];
    }
    interactiveTransitionRecognizer.edges = [self getEdgeWithDirection:direction];
    [self.view addGestureRecognizer:interactiveTransitionRecognizer];
    
    if(animator.transitionDuration == 0){ // 默认值
        animator.transitionDuration = 0.35f;
    }
    
    TFY_TransitionDelegate *tDelegate = [TFY_TransitionDelegate sharedInstace];
    [TFY_TransitionDelegate addAnimator:animator forKey:viewController];
   
    viewController.transitionDelegate = tDelegate;
    self.willPresentViewController = viewController;
    
    if(animator.isPushOrPop) {
        self.navigationController.delegate = tDelegate;
    }else {
        viewController.modalPresentationStyle = UIModalPresentationCustom;
        viewController.transitioningDelegate = tDelegate;
    }
    
    // 注册手势
    if(animator.interactiveDirectionOfPush > DirectionToTop &&
       animator.interactiveDirectionOfPush != animator.interactiveDirectionOfPop){
        
        [viewController registerInteractivePopRecognizerWithDirection: animator.interactiveDirectionOfPop];
    }
}

- (void)interactivePushRecognizerAction:(UIPanGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        if (self.willPresentViewController.transitionDelegate == nil) {
            return;
        }
        
        id <AnimatorProtocol>animator = [TFY_TransitionDelegate animatorForKey:self.willPresentViewController];
        NSAssert(animator, @"animator = nil,异常");
        if (animator == nil) return;
        
        if ([animator respondsToSelector:@selector(percentOfFinishInteractiveTransition)] &&
            [animator percentOfFinishInteractiveTransition] <= 0) {
            // 不支持百分比控制
            self.willPresentViewController.transitionDelegate.interactiveRecognizer = nil;
        }else {
            self.willPresentViewController.transitionDelegate.interactiveRecognizer = gestureRecognizer;
        }
        
        if (animator.isPushOrPop){
            NSAssert(![self isMemberOfClass:[UINavigationController class]], @"%s 方法n不能用UINavigationController发起调用，请直接用view controllerd调用", __func__);
            NSAssert(self.navigationController, (@"控制器 %@ 没有navigationController，无法push"), self);
            NSAssert(![animator isMemberOfClass:[TFY_SystemAnimator class]], (@"TFY_SystemAnimator 只支持modal"), self);
            [self.navigationController pushViewController:self.willPresentViewController animated:YES];
        }else {
            [self presentViewController:self.willPresentViewController animated:YES completion:nil];
        }
    }
}


// register pop or dismiss interactive recognizer for transition
- (UIScreenEdgePanGestureRecognizer *)registerInteractivePopRecognizerWithDirection:(Direction)direction {
    
    if (self.disableInteractivePopGestureRecognizer) return nil;
    
    SEL sel = @selector(interactivePopRecognizerAction:);
    UIScreenEdgePanGestureRecognizer *interactiveTransitionRecognizer;
    
    if (@available(iOS 13.0, *)) {
        // UIScreenEdgePanGestureRecognizer 在iOS 13 好像失效，暂时用自定义手势代替
        interactiveTransitionRecognizer = (UIScreenEdgePanGestureRecognizer *)[[TFY_ScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:sel];
    }else {
        interactiveTransitionRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:sel];
    }
    
    interactiveTransitionRecognizer.edges = [self getEdgeWithDirection:direction];
    [self.view addGestureRecognizer:interactiveTransitionRecognizer];
    return interactiveTransitionRecognizer;
}

- (UIRectEdge)getEdgeWithDirection:(Direction)direction {
    return direction == DirectionToLeft ? UIRectEdgeRight : UIRectEdgeLeft;
}

- (void)interactivePopRecognizerAction:(UIPanGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        if (self.transitionDelegate == nil) {
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        
        id <AnimatorProtocol>animator = [TFY_TransitionDelegate animatorForKey:self];
        NSAssert(animator, @"animator = nil,异常");
        if (animator == nil) return;
        
        if ([animator respondsToSelector:@selector(percentOfFinishInteractiveTransition)] &&
            [animator percentOfFinishInteractiveTransition] <= 0) {
            // 不支持百分比控制
            self.transitionDelegate.interactiveRecognizer = nil;
        }else {
            self.transitionDelegate.interactiveRecognizer = gestureRecognizer;
        }
        
        if (animator.isPushOrPop){
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}


#pragma mark API
#pragma mark - modal
- (void)presentViewController:(UIViewController *)vc
              transitionStyle:(UIModalTransitionStyle)style
                   completion:(void (^ __nullable)(void))completion
{
    [self presentViewController:vc transitionStyle:style fullScreen:YES completion:completion];
}

/// 非全屏模式，只支持iOS 13+
- (void)presentViewController:(UIViewController *)vc
              transitionStyle:(UIModalTransitionStyle)style
                   fullScreen:(BOOL)isFullScreen
               completion:(void (^ __nullable)(void))completion
{
    if (@available(iOS 13.0, *)) {
        NSAssert(
                 style != UIModalTransitionStylePartialCurl,
                 @"%s iOS 13+ 不支持 UIModalTransitionStylePartialCurl",
                 __func__
                 );
    }
    
    vc.modalPresentationStyle = isFullScreen ?  0 : -2;
    vc.modalTransitionStyle = style;
    
    [self presentViewController:vc animated:YES completion:completion];
    
    [vc registerInteractivePopRecognizerWithDirection:DirectionToBottom];
}


- (void)presentViewController:(UIViewController *)viewController
                     animator:(id<AnimatorProtocol>)animator
                   completion:(void (^ __nullable)(void))completion;
{
    animator.isPushOrPop = NO;
    if([animator isMemberOfClass:[TFY_SystemAnimator class]]) {
        TFY_SystemAnimator *anim = (TFY_SystemAnimator *)animator;
        [self presentViewController:viewController
                    transitionStyle:anim.style
                         fullScreen:anim.isFullScreen
                         completion:completion];
        return;
    }
    
    if(animator.transitionDuration == 0){ // 默认值
        animator.transitionDuration = 0.35f;
    }
    
    Direction dir = DirectionToRight;
    if ([animator respondsToSelector:@selector(interactiveDirectionOfPop)]) {
        dir = [animator interactiveDirectionOfPop];
    }
    TFY_TransitionDelegate *tDelegate = [TFY_TransitionDelegate sharedInstace];
    [TFY_TransitionDelegate addAnimator:animator forKey:viewController];
    
    [viewController registerInteractivePopRecognizerWithDirection: dir];
    viewController.transitionDelegate = tDelegate;
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    viewController.transitioningDelegate = tDelegate;
    [self presentViewController:viewController animated:YES completion:completion];
}

- (void)presentViewController:(UIViewController *)vc
                    swipeType:(SwipeType)swipeType
             presentDirection:(Direction)presentDirection
             dismissDirection:(Direction)dismissDirection
                   completion:(void (^ __nullable)(void))completion
{
    TFY_SwipeAnimator *animator = [[TFY_SwipeAnimator alloc] init];
    animator.isPushOrPop = NO;
    animator.swipeType = swipeType;
    animator.pushDirection = presentDirection;
    animator.popDirection = dismissDirection;
    
    [self presentViewController:vc animator:animator completion:completion];
}

- (void)presentViewController:(UIViewController *)vc
               transitionType:(TransitionType)tType
                    direction:(Direction)direction
             dismissDirection:(Direction)directionOfDismiss
                   completion:(void (^ __nullable)(void))completion
{
    TFY_CATransitonAnimator *animator;
    animator = [TFY_CATransitonAnimator animatorWithTransitionType:tType
                                                       direction:direction
                                         transitionTypeOfDismiss:tType
                                              directionOfDismiss:directionOfDismiss];
    
    [self presentViewController:vc animator:animator completion:completion];
}

- (void)presentViewController:(UIViewController *)vc
              customAnimation:(void (^)(id<UIViewControllerContextTransitioning> transitionContext, BOOL isPresenting))animation
                   completion:(void (^ __nullable)(void))completion
{
    TFY_CustomAnimator *animator = [TFY_CustomAnimator animatorWithAnimation:animation];
    [self presentViewController:vc animator:animator completion:completion];
}

#pragma mark - Push / pop
- (void)pushViewController:(UIViewController *)viewController animator:(id<AnimatorProtocol>)animator
{
    // 不能是UINavigationController
    NSAssert(![self isMemberOfClass:[UINavigationController class]], @"%s 方法不能用UINavigationController发起调用，请直接用view controllerd调用", __func__);
    NSAssert(self.navigationController, (@"控制器 %@ 没有navigationController，无法push"), self);
    NSAssert(![animator isMemberOfClass:[TFY_SystemAnimator class]], (@"TFY_SystemAnimator 只支持modal"), self);
    
    animator.isPushOrPop = YES;
    if(animator.transitionDuration == 0){ // 默认值
        animator.transitionDuration = 0.35f;
    }
    
    Direction dir = DirectionToRight;
    if ([animator respondsToSelector:@selector(interactiveDirectionOfPop)]) {
        dir = [animator interactiveDirectionOfPop];
    }
    [viewController registerInteractivePopRecognizerWithDirection: dir];
    
    [TFY_TransitionDelegate addAnimator:animator forKey:viewController];
    TFY_TransitionDelegate *tDelegate = [TFY_TransitionDelegate sharedInstace];
    
    viewController.transitionDelegate = tDelegate;
    self.navigationController.delegate = tDelegate;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)pushViewController:(UIViewController *)vc
                swipeType:(SwipeType)swipeType
            pushDirection:(Direction)pushDirection
             popDirection:(Direction)popDirection
{
    TFY_SwipeAnimator *animator = [[TFY_SwipeAnimator alloc] init];
    animator.isPushOrPop = YES;
    animator.swipeType = swipeType;
    animator.pushDirection = pushDirection;
    animator.popDirection = popDirection;

    [self pushViewController:vc animator:animator];
}

- (void)pushViewController:(UIViewController *)vc
            transitionType:(TransitionType)tType
                 direction:(Direction)direction
          dismissDirection:(Direction)directionOfPop
{
    TFY_CATransitonAnimator *animator;
    animator = [TFY_CATransitonAnimator animatorWithTransitionType:tType
                                                       direction:direction
                                         transitionTypeOfDismiss:tType
                                              directionOfDismiss:directionOfPop];
    [self pushViewController:vc animator:animator];
}

- (void)pushViewController:(UIViewController *)vc
           customAnimation:(void (^)( id<UIViewControllerContextTransitioning> transitionContext, BOOL isPush))animation
{
    TFY_CustomAnimator *animator = [TFY_CustomAnimator animatorWithAnimation:animation];
    animator.animation = animation;
   
    [self pushViewController:vc animator:animator];
}


@end
