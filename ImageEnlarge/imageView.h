//
//  imageView.h
//  ImageEnlarge
//
//  Created by SIMPLE PLAN on 2017/2/13.
//  Copyright © 2017年 SIMPLE PLAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface imageView : UIView<UIScrollViewDelegate>
{
    UIScrollView *_slideScroll;
    UIView *_bgView;
}
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIScrollView *slideScroll;

- (void)showImg:(NSArray *)photoArray withTag:(NSInteger)integer;

@end
