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

+ (UIWindow *)appKeyWindow {
    UIWindow *keywindow = nil;
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene *scene in UIApplication.sharedApplication.connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                if (@available(iOS 15.0, *)) {
                    keywindow = scene.keyWindow;
                }
                if (keywindow == nil) {
                    for (UIWindow *window in scene.windows) {
                        if (window.windowLevel == UIWindowLevelNormal && window.hidden == NO && CGRectEqualToRect(window.bounds, UIScreen.mainScreen.bounds)) {
                            keywindow = window;
                            break;
                        }
                    }
                }
            }
        }
    }
    return keywindow;
}


@end
