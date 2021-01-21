//
//  UIViewController+Transitioning.h
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/17.
//

#import <UIKit/UIKit.h>
#import "TFY_AnimatorProtocol.h"
#import "TFY_ScreenEdgePanGestureRecognizer.h"

@class TFY_TransitionDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Transitioning)

/// 转场动画(面向present/push To View Controller)
@property(nonatomic, weak, readonly) TFY_TransitionDelegate *transitionDelegate;
///  注册push/present手势后，要转场的控制器
@property(nonatomic, weak, readonly) UIViewController *willPresentViewController;

/** 侧滑pop/dismiss交互手势启用开关。默认开启（NO）
 * 1.特性：当pop/dismiss的方向为DirectionToLeft（向左动画退场）时，通过右侧滑（屏幕右侧向左滑动）启动交互；
 *        其它则都是通过左侧滑启动交互
 * 2.手势控制转场百分比： 当前只有SwipeAnimator类型动画支持转场百分比控制
 * 3.关闭： 在push操作前设置`vc`的`disableInteractivePopGestureRecognizer = YES`，可以禁止侧滑交互
 */
@property(nonatomic, assign) BOOL disableInteractivePopGestureRecognizer;

/** 注册手势，通过UIScreenEdgePanGestureRecognizer手势触发push/present
 *  viewController 要转场的控制器
 *  animator 动画管理对象  ⚠️：必须初始化`isPushOrPop`，`interactiveDirection`属性
 */
- (void)registerInteractiveTransitionToViewController:(UIViewController *)viewController
                                             animator:(id <AnimatorProtocol>)animator;


//====================== 👇下面2个API是通用API ==========================//

// NOTE：下面不同类型的Animator实现的转场效果有些类似，只是实现方案有所差异
/**
 * present 转场控制器。
 * viewController 要转场的控制器 对应 willPresentViewController 属性
 * animator 转场动画管理对象
 *        目前提供“TFY_SystemAnimator”、“TFY_SwipeAnimator”、“TFY_CATransitionAnimator”、“TFY_CuStomAnimator” 、 “TFY_Animator”供选择，
 *        也可以由开发者自己写一个这样的对象，需要 严格遵守 TFY_AnimatorProtocal协议（可以参考模版TFY_AnimatorTemplate）
 * completion 完成转场的回调
 */
- (void)presentViewController:(UIViewController *)viewController
                     animator:(id<AnimatorProtocol>)animator
                   completion:(void (^ __nullable)(void))completion;

/**
 * push 转场控制器。
 * viewController 要转场的控制器
 * animator 转场动画管理对象
 *        目前提供“TFY_SwipeAnimator”、“TFY_CATransitionAnimator”、“TFY_CuStomAnimator” 、 “TFY_Animator”供选择，
 *        也可以由开发者自己写一个这样的对象，需要 严格遵守 TFY_AnimatorProtocal协议（可以参考模版TFY_AnimatorTemplate）
 */
- (void)pushViewController:(UIViewController *)viewController animator:(id<AnimatorProtocol>)animator;


//====================== 👇下面的API是👆上面两个的简化使用 ==========================//
#pragma mark - Present / Dismiss
/**
 * present转场控制器。
 * vc 要转场的控制器
 * animation 自定义动画（分presenting和dismiss）
 *        isPresenting = YES，Present；isPresenting = NO，Dismiss，
 *        ⚠️ 动画结束一定要调用[transitionContext completeTransition:YES];
 *
 * completion 完成转场的回调
 * NOTE: 由于自定义情况下，系统不会将当前c控制器（self）从窗口移除，所以dismiss后，系统不会调用`- viewDidAppear:`和`- viewWillAppear:`等方法
 */
- (void)presentViewController:(UIViewController *)vc
              customAnimation:(void (^)( id<UIViewControllerContextTransitioning> transitionContext, BOOL isPresenting))animation
                   completion:(void (^ __nullable)(void))completion;


- (void)presentViewController:(UIViewController *)vc
                    swipeType:(SwipeType)swipeType
             presentDirection:(Direction)presentDirection
             dismissDirection:(Direction)dismissDirection
                   completion:(void (^ __nullable)(void))completion;

/**
 * push 转场控制器。
 * vc 要转场的控制器
 * animation 自定义动画
 *        isPush = YES，push；isPush = NO，pop，
 *        ⚠️ 动画结束一定要调用[transitionContext completeTransition:YES];
 */
- (void)pushViewController:(UIViewController *)vc
           customAnimation:(void (^)( id<UIViewControllerContextTransitioning> transitionContext, BOOL isPush))animation;


@end

NS_ASSUME_NONNULL_END
