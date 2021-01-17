//
//  TFY_TransitFunction.m
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/17.
//

#import "TFY_TransitFunction.h"

@implementation TFY_TransitFunction

UIRectEdge getRectEdge(Direction direction) {
    UIRectEdge edge = UIRectEdgeLeft;
    if (direction == DirectionToTop) {
        edge = UIRectEdgeBottom;
    }else if(direction == DirectionToLeft) {
        edge = UIRectEdgeRight;
    }else if(direction == DirectionToBottom) {
        edge = UIRectEdgeTop;
    }else if(direction == DirectionToRight) {
        edge = UIRectEdgeLeft;
    }
    return edge;
}

UIImage * snapshotImage(UIView *view) {
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:contextRef];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshot;
}

UIImage * resizableSnapshotImage(UIView *view, CGRect inRect) {
    if (CGRectEqualToRect(inRect, CGRectNull) || CGRectEqualToRect(inRect, CGRectZero)) {
        inRect = view.bounds;
    }
    UIGraphicsBeginImageContext(inRect.size);
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:contextRef];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshot;
}

@end
