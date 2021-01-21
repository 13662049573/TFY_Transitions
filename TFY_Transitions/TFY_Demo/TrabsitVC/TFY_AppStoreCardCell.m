//
//  TFY_AppStoreCardCell.m
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/17.
//

#import "TFY_AppStoreCardCell.h"

@implementation TFY_AppStoreCardCell
{
   UIImageView *_imgView;
}

- (UIImageView *)imageView {
   if (_imgView == nil) {
       _imgView = [[UIImageView alloc] init];
       [self.contentView addSubview:_imgView];
       
       self.contentView.layer.cornerRadius = 10;
       self.contentView.clipsToBounds = YES;
   }
   return  _imgView;
}

- (void)layoutSubviews {
   [super layoutSubviews];
   
   self.imageView.frame = self.contentView.bounds;
}
@end
