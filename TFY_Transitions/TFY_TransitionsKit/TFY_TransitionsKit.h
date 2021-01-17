//
//  TFY_TransitionsKit.h
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/17.
//  最新版本: 2.0.0

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

FOUNDATION_EXPORT double TFY_TransitionsKitVersionNumber;

FOUNDATION_EXPORT const unsigned char TFY_TransitionsKitVersionString[];

#define TFY_TransitionsKitRelease 0

#if TFY_TransitionsKitRelease

#import <TFY_TransitionsKit/TFY_Config.h>
#import <TFY_TransitionsKit/UIViewController+Transitioning.h>
#import <TFY_TransitionsKit/TFY_TransitionDelegate.h>
#import <TFY_TransitionsKit/TFY_CATransitonAnimator.h>
#import <TFY_TransitionsKit/TFY_SwipeAnimator.h>
#import <TFY_TransitionsKit/TFY_CustomAnimator.h>
#import <TFY_TransitionsKit/TFY_SystemAnimator.h>
#import <TFY_TransitionsKit/TFY_Animator.h>

#else

#import "TFY_Config.h"
#import "UIViewController+Transitioning.h"
#import "TFY_TransitionDelegate.h"
#import "TFY_CATransitonAnimator.h"
#import "TFY_SwipeAnimator.h"
#import "TFY_CustomAnimator.h"
#import "TFY_SystemAnimator.h"
#import "TFY_Animator.h"


#endif
