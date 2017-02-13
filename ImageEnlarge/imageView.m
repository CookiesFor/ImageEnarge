//
//  imageView.m
//  ImageEnlarge
//
//  Created by SIMPLE PLAN on 2017/2/13.
//  Copyright © 2017年 SIMPLE PLAN. All rights reserved.
//

#import "imageView.h"

#define kScreenSize [UIScreen mainScreen].bounds.size

@interface imageView()
{
    UIScrollView *lastScroll;
    UIImageView *selectImageView;
    UILabel *countLab;
    NSInteger totalPage;
}
@end

@implementation imageView
- (void)showImg:(NSArray *)photoArray withTag:(NSInteger)integer
{
    totalPage = photoArray.count;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //创建黑色背景
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.tag =1314;
    //创建可滑动的scrollView
    _slideScroll = [[UIScrollView alloc] init];
    _slideScroll.center = _bgView.center;
    _slideScroll.bounds = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
    _slideScroll.delegate = self;
    _slideScroll.pagingEnabled = YES;
    _slideScroll.showsVerticalScrollIndicator = NO;
    _slideScroll.showsHorizontalScrollIndicator = NO;
    _slideScroll.contentSize = CGSizeMake(kScreenSize.width * photoArray.count, kScreenSize.height);
    _slideScroll.contentOffset = CGPointMake(kScreenSize.width * (integer - 100), 0);
    _slideScroll.userInteractionEnabled =YES;
    [_bgView addSubview:_slideScroll];
    [window addSubview:_bgView];
    
    for (int i = 0; i < photoArray.count; i++) {
        //创建放大的scrollview
        UIScrollView *showPhotoScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
        showPhotoScroll.center = CGPointMake(_slideScroll.bounds.size.width/2+i*kScreenSize.width, _slideScroll.bounds.size.height/2);
        showPhotoScroll.showsVerticalScrollIndicator=YES;
        showPhotoScroll.showsHorizontalScrollIndicator=YES;
        showPhotoScroll.bounces = NO;
        showPhotoScroll.userInteractionEnabled =YES;
        //添加imageview
        UIImageView*imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled= YES;

        [imageView sd_setImageWithURL:[NSURL URLWithString:photoArray[i]] placeholderImage:[UIImage imageNamed:@"加载图片"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            CGSize imageSize = image.size;
            imageView.center = CGPointMake(kScreenSize.width/2, kScreenSize.height/2);
            imageView.bounds = CGRectMake(0, 0, kScreenSize.width, imageSize.height/imageSize.width * kScreenSize.width);
            
        }];
        imageView.userInteractionEnabled =YES;
        if (i==integer-100) {
            selectImageView=imageView;
            lastScroll = showPhotoScroll;
        }
        showPhotoScroll.contentSize = imageView.frame.size;
        showPhotoScroll.delegate = self;
        //分别设置scrollview和imageview的tag
        showPhotoScroll.tag = i + 200;
        imageView.tag = i + 300;
        showPhotoScroll.maximumZoomScale = 2.0;//可放大的最大倍数
        showPhotoScroll.minimumZoomScale = 1.0;//可缩小的最小倍数
        [showPhotoScroll addSubview:imageView];
        [_slideScroll addSubview:showPhotoScroll];
    }
    _bgView.userInteractionEnabled =YES;
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    if (!countLab) {
        //创建数字小标
        countLab = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenSize.height - 100/375.0*kScreenSize.width, kScreenSize.width, 15/375.0*kScreenSize.width)];
        countLab.textAlignment = NSTextAlignmentCenter;
        countLab.textColor = [UIColor whiteColor];
        countLab.font = [UIFont systemFontOfSize:15/375.0*kScreenSize.width];
    }
    countLab.text = [NSString stringWithFormat:@"%ld/%ld",(integer-100)+1,totalPage];
    [_bgView addSubview:countLab];
}
//scrollview的代理方法
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (scrollView != _slideScroll) {
        return selectImageView;
    }
    return nil;
}
//停止放大的时候修改坐标
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if (scrollView != _slideScroll) {
        scrollView.contentSize=CGSizeMake(selectImageView.bounds.size.width*scale, selectImageView.bounds.size.height*scale);
        int pageNum = _slideScroll.contentOffset.x/kScreenSize.width;
        scrollView.center=CGPointMake(_slideScroll.bounds.size.width/2+pageNum*kScreenSize.width, _slideScroll.bounds.size.height/2);
        selectImageView.center = CGPointMake(scrollView.contentSize.width/2, scrollView.contentSize.height>kScreenSize.height ? scrollView.contentSize.height/2 : kScreenSize.height/2);
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _slideScroll&&lastScroll) {
        lastScroll.zoomScale = 1.0;
        selectImageView.center = CGPointMake(kScreenSize.width/2, kScreenSize.height/2);
        int pageNum = scrollView.contentOffset.x/kScreenSize.width+1;
        for (UIScrollView*scroll in _slideScroll.subviews) {
            if (scroll.tag==(pageNum-1)+200) {
                lastScroll = scroll;
            }
        }
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //在停止滑动的时候，找到当前scrollview对应的子视图上面的imageview
    if (scrollView == _slideScroll) {
        int pageNum = scrollView.contentOffset.x/kScreenSize.width+1;
        for (UIScrollView*scroll in _slideScroll.subviews) {
            if (scroll.tag==(pageNum-1)+200) {
                for (UIImageView*imageView in scroll.subviews) {
                    if (imageView.tag==(pageNum-1)+300) {
                        selectImageView=imageView;
                    }
                }
            }
        }
        countLab.text =  [NSString stringWithFormat:@"%d/%ld",pageNum,totalPage];
    }
}


@end
