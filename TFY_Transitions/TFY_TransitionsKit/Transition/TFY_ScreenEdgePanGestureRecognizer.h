//
//  TFY_ScreenEdgePanGestureRecognizer.h
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_ScreenEdgePanGestureRecognizer : UIPanGestureRecognizer<UIGestureRecognizerDelegate>
@property (readwrite, nonatomic, assign) UIRectEdge edges;
@end

NS_ASSUME_NONNULL_END
