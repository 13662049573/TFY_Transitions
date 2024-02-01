//
//  TFY_PresentationVC.h
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/17.
//

#import <UIKit/UIKit.h>
@class TFY_PopTransitVC;

/**
 * 自适应位置情况下的显示样式,可以配合animateTransition属性使用 */
typedef enum : NSUInteger {
    PopTypeActionSheet = 0,    // ActionSheet动画样式，底部弹出，靠底部显示
    PopTypeAlert = 1,          // AlertView动画样式，淡化居中显示
    PopTypeAlert2 = 2,         // f顶部掉下来、弹性，居中显示
} TransitionPopType;

/// 自定义动画样式
typedef void(^AnimateForTransition)(id <UIViewControllerContextTransitioning> _Nonnull transitionContext);

NS_ASSUME_NONNULL_BEGIN

@interface TFY_PresentationVC : UIPresentationController<UIViewControllerTransitioningDelegate>

/// 是否允许点击灰色蒙板处来dismiss，默认YES
@property(nonatomic, assign) BOOL allowTapDismiss;
/// 圆角，默认16
@property(nonatomic, assign) CGFloat cornerRadius;
/// 隐藏阴影layer，默认NO
@property(nonatomic, assign) BOOL hideShadowLayer;
/// 键盘显示与隐藏监听，default：YES
@property(nonatomic, assign) BOOL allowObserverForKeyBoard;

/// 转场动画时间，默认0.35s
@property(nonatomic, assign) NSTimeInterval transitionDuration;
/// 自定义动画样式(注意需要准守规则,可参考demo或文档)
@property(nonatomic, copy) AnimateForTransition animateTransition;

/// 栈顶控制器
+ (UIViewController *)topController;

/// 当前设备是不是iPhone X系列
+ (BOOL)isIPhoneX;


/**
 * 转场形式显示popView
 * 自适应位置
 * ⚠️调用该方法时，请先设定好popView的frame
 *
 *  popView 要显示的View
 *  pType 显示类型
 *  返回转场代理TFY_PopTransition对象
 */
+ (instancetype)showView:(UIView *)popView popType:(TransitionPopType)pType;

/**
 * 转场形式显示popView
 * 指定位置(在view超出屏幕范围情况下会自动匹配边界【调整origin】，以保证view整体都在屏幕显示)
 * ⚠️调用该方法时，请先设定好popView的frame
 *
 * popView 要显示的View
 * point popView的最终坐标（origin相对mainScreen）
 * 返回转场代理TFY_PopTransition对象
 */
+ (instancetype)showView:(UIView *)popView toPoint:(CGPoint)point;

/**
 * 显示popView, 由InitialFrame(初始) --过渡到--> FinalFrame(最终)
 * popView 要显示的View
 * iFrame present前的frame(初始)
 * fFrame presented后的frame(最终)
 * 返回转场代理TFY_PopTransition对象
 */
+ (instancetype)showView:(UIView *)popView
            initialFrame:(CGRect)iFrame
              finalFrame:(CGRect)fFrame;
/**
 * 隐藏popView
 * 如果TFY_PopTransition没有被引用，则在隐藏后会自动释放
 * 如果popView没有被引用，在隐藏后也会自动释放
 */
- (void)dismiss;
- (void)dismissWithCompletion: (void (^ __nullable)(void))completion;
- (void)dismissViewControllerAnimated: (BOOL)flag completion: (void (^ __nullable)(void))completion;

/**
 * 实时更新view的size ，显示后也可以更新
 */
- (void)updateContentSize;

@end

NS_ASSUME_NONNULL_END
