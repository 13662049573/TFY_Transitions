//
//  TFY_ModalFirstController.h
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/17.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ContentTypeSystemAnimator,
    ContentTypeSwipeAnimator,
    ContentTypeCATransitionAnimator,
    ContentTypeCuStomAnimator,
    ContentTypeOther,
} ContentType;

NS_ASSUME_NONNULL_BEGIN

@interface TFY_ModalFirstController : UITableViewController
@property(nonatomic, assign) ContentType type;
@end

NS_ASSUME_NONNULL_END
