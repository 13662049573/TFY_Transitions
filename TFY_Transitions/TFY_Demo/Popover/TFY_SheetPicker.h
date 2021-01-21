//
//  TFY_SheetPicker.h
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/17.
//

#import <UIKit/UIKit.h>

typedef void(^SelcteHandler)(NSInteger row);

@class TFY_SheetPicker;
@protocol SheetPickerDelegate <NSObject>
@optional
/** 选中某行 */
- (void)sheetPicker:(TFY_SheetPicker *_Nonnull)picker didSelectRow:(NSInteger)row;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TFY_SheetPicker : UIView
/** 选中某行回调 */
@property (nonatomic, copy) SelcteHandler selcteHandler;
/** 字段list */
@property(nonatomic, strong) NSArray <NSString *>*items;
/** 默认选中行 */
@property(nonatomic, assign) NSInteger curRow;
/** 显示行数，默认5行（行高50） */
@property(nonatomic, assign) NSInteger showRows;

@property (nonatomic, weak) id <SheetPickerDelegate> delegate;

/**
 * 实例方法
 * curRow: 显示时需要默认选中的行 */
+ (instancetype)showPickerWithItems:(NSArray <NSString *>*)items
               defaultSelectRow:(NSInteger)curRow
               didSelectHnadler:(SelcteHandler)handler;
/**
 * 实例方法
 * curRow: 显示时需要默认选中的行 */
+ (instancetype)showPickerWithItems:(NSArray <NSString *>*)items
                   defaultSelectRow:(NSInteger)curRow
                           delegate:(id <SheetPickerDelegate>)delegate;

/// 指定选中某row行
- (void)scrollToRow:(NSInteger)row animated:(BOOL)animated;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
