//
//  TFY_WheelTableViewCell.h
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_WheelTableViewCell : UITableViewCell
@property (strong, nonatomic)  UILabel *titleLabel;
@property (strong, nonatomic)  UILabel *subTitleLabel;
@property (strong, nonatomic)  UISegmentedControl *sgmtA;
@property (strong, nonatomic)  UISegmentedControl *sgmtB;
@end

NS_ASSUME_NONNULL_END
