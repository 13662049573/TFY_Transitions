//
//  TFY_CATransitonAnimator.h
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/17.
//

#import <Foundation/Foundation.h>
#import "TFY_AnimatorProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFY_CATransitonAnimator : NSObject<AnimatorProtocol>
// 此处不继承UIPresentationController，
// 1. 是为了解除循环引用（toVc --> transitionDelegate（单例） --> animatior --> toVc）
// 2. 此处需求只需要遵守基本协议即可，不继承UIPresentationController也没影响

@property(nonatomic, assign) TransitionType tType;
@property(nonatomic, assign) Direction direction;
@property(nonatomic, assign) TransitionType tTypeOfDismiss;
@property(nonatomic, assign) Direction directionOfDismiss;

+ (instancetype)animatorWithTransitionType:(TransitionType)tType
                                 direction:(Direction)direction
                   transitionTypeOfDismiss:(TransitionType)tTypeOfDismiss
                        directionOfDismiss:(Direction)directionOfDismiss;
@end

NS_ASSUME_NONNULL_END
