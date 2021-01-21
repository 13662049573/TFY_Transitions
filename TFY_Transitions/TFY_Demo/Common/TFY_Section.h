//
//  TFY_Section.h
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_Section : NSObject
@property(nonatomic, copy) NSString *title;
@property(nonatomic, assign) BOOL show;
@property(nonatomic, strong) NSArray *rows;
@property(nonatomic, strong) NSArray *rowsOfSubTitle;
@end

NS_ASSUME_NONNULL_END
