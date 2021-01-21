//
//  TFY_AppStoreDetialController.h
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/17.
//

#import <UIKit/UIKit.h>
@class TFY_AppStoreCardAmiator;
NS_ASSUME_NONNULL_BEGIN

@interface TFY_AppStoreDetialController : UIViewController
@property(nonatomic, copy) NSString *imgName;

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *textLabel;
@end

NS_ASSUME_NONNULL_END
