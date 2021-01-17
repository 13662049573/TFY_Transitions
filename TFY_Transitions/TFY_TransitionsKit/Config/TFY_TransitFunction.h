//
//  TFY_TransitFunction.h
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/17.
//

#import <Foundation/Foundation.h>
#import "TFY_Config.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFY_TransitFunction : NSObject

UIRectEdge getRectEdge(Direction direction);
UIImage * snapshotImage(UIView *view);  // 快照，将View转换成图片
UIImage * resizableSnapshotImage(UIView *view, CGRect inRect);

@end

NS_ASSUME_NONNULL_END
