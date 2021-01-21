//
//  TFY_LoadingView.h
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_LoadingView : UIView
/// 默认显示2秒，无标题
+ (instancetype)show;
+ (void)hide;

/// duration <= 0 : 一直持续，需要手动hide
+ (instancetype)showWithDuration:(NSTimeInterval)duration;

@end

NS_ASSUME_NONNULL_END
