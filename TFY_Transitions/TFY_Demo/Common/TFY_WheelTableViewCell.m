//
//  TFY_WheelTableViewCell.m
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/20.
//

#import "TFY_WheelTableViewCell.h"

@interface TFY_WheelTableViewCell ()
@property(nonatomic , strong)UILabel *a_label,*b_label;
@end

@implementation TFY_WheelTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, transit_ScreenW-20, 20)];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleLabel.textColor = UIColor.blackColor;
        [self.contentView addSubview:self.titleLabel];
        
        self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame), transit_ScreenW-20, 20)];
        self.subTitleLabel.font = [UIFont systemFontOfSize:12];
        self.subTitleLabel.textColor = UIColor.blueColor;
        self.subTitleLabel.text = @"--------------方向设置-------------";
        self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.subTitleLabel];
        
        
        self.a_label = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.subTitleLabel.frame)+20, 60, 20)];
        self.a_label.text = @"A-->B";
        self.a_label.textColor = UIColor.orangeColor;
        self.a_label.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.a_label];
        
        NSArray *array = [NSArray arrayWithObjects:@"Top",@"Left",@"Bottom",@"Right", nil];
        if (@available(iOS 14.0, *)) {
            self.sgmtA = [[UISegmentedControl alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.a_label.frame)+10, CGRectGetMaxY(self.subTitleLabel.frame)+20, transit_ScreenW-2*(CGRectGetWidth(self.a_label.frame)+10), 25) actions:array];
        } else {
            self.sgmtA = [[UISegmentedControl alloc] initWithItems:array];
            self.sgmtA.frame = CGRectMake(CGRectGetWidth(self.a_label.frame)+10, CGRectGetMaxY(self.subTitleLabel.frame)+20, transit_ScreenW-transit_ScreenW-2*(CGRectGetWidth(self.a_label.frame)+10), 25);
        }
        self.sgmtA.selectedSegmentIndex = 3;
        self.sgmtA.tintColor = [UIColor redColor];
        [self.contentView addSubview:self.sgmtA];
        
        self.b_label = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.sgmtA.frame)+10, 60, 20)];
        self.b_label.text = @"A<--B";
        self.b_label.textColor = UIColor.orangeColor;
        self.b_label.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.b_label];
        
        if (@available(iOS 14.0, *)) {
            self.sgmtB = [[UISegmentedControl alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.b_label.frame)+10, CGRectGetMaxY(self.sgmtA.frame)+10, transit_ScreenW-2*(CGRectGetWidth(self.b_label.frame)+10), 25) actions:array];
        } else {
            self.sgmtB = [[UISegmentedControl alloc] initWithItems:array];
            self.sgmtB.frame = CGRectMake(CGRectGetWidth(self.b_label.frame)+10, CGRectGetMaxY(self.sgmtA.frame)+10, transit_ScreenW-2*(CGRectGetWidth(self.b_label.frame)+10), 25);
        }
        self.sgmtB.selectedSegmentIndex = 1;
        self.sgmtB.tintColor = [UIColor redColor];
        [self.contentView addSubview:self.sgmtB];
    }
    return self;
}



@end
