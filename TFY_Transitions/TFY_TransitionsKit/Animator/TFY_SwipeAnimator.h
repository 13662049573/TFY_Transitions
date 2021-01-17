//
//  TFY_SwipeAnimator.h
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/17.
//

#import <Foundation/Foundation.h>
#import "TFY_AnimatorProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFY_SwipeAnimator : NSObject<AnimatorProtocol>
/// push方向/present
@property (nonatomic, readwrite) Direction pushDirection;
/// pop方向/dismiss
@property (nonatomic, readwrite) Direction popDirection;
/// 滑入方式
@property (nonatomic, assign) SwipeType swipeType;

+ (instancetype)animatorWithSwipeType:(SwipeType)swipeType
                        pushDirection:(Direction)pushDirection
                         popDirection:(Direction)popDirection;
@end

NS_ASSUME_NONNULL_END
