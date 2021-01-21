//
//  TFY_AppStoreCardAmiator.h
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_AppStoreCardAmiator : NSObject<AnimatorProtocol>
@property(nonatomic, assign) CGRect fromRect;
@property(nonatomic, weak) UIView *cardView;
@property(nonatomic, weak) UIView *textView;

@property(nonatomic, weak, readonly) id<UIViewControllerContextTransitioning>transitionContext;
@end

NS_ASSUME_NONNULL_END
