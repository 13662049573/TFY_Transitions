//
//  TFY_AnimatorProtocol.h
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/17.
//

#import "TFY_Config.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AnimatorProtocol <UIViewControllerAnimatedTransitioning>

@required

/// 动画时间(默认值：0.45s，最小值必须大于0.01f)
@property(nonatomic, assign) NSTimeInterval transitionDuration;
/// Push / Pop 转场(default: NO ,modal 转场)
@property (nonatomic, assign) BOOL isPushOrPop;

/// 设置Pop/present侧滑交互的方向
@property(nonatomic, assign) Direction interactiveDirectionOfPush;

/// Pop/dismiss侧滑交互的方向。
- (Direction)interactiveDirectionOfPop;

@optional
/// 手势动画完成多少百分比后，释放手指可以完成转场,少于该值将取消转场。取值范围：[0 ，1），默认：0.5 ,小于等于0表示不支持百分比控制
- (CGFloat)percentOfFinishInteractiveTransition;
/// 动画完成多少百分比后，直接完成转场（默认：0 表示不启用）--> (0 ，1]
- (CGFloat)percentOfFinished;
/// 用来调节完成完成百分比，数值越大越快（默认：0，小于0.2 表示不启用）
- (CGFloat)speedOfPercent;

@end

NS_ASSUME_NONNULL_END
