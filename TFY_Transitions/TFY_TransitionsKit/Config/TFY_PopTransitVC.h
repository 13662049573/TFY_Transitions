//
//  TFY_PopTransitVC.h
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/17.
//

#import <UIKit/UIKit.h>
#import "TFY_Config.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFY_PopTransitVC : UIViewController

@property(nonatomic, weak) UIView *popView;
/// 实时更新view的size
- (void)updateContentSize;
@end

NS_ASSUME_NONNULL_END
