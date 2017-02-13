//
//  ViewController.m
//  ImageEnlarge
//
//  Created by SIMPLE PLAN on 2017/2/13.
//  Copyright © 2017年 SIMPLE PLAN. All rights reserved.
//

#import "ViewController.h"
#import "imageView.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <Masonry/Masonry.h>
@interface ViewController ()
{
    imageView *_photoImage;
}
@property (nonatomic,strong)NSArray *arr;
@property (nonatomic, strong) NSArray *modelsArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
    
}

-(void)createView
{
    _photoImage =[[imageView alloc]init];
    _arr =[[NSArray alloc]init];
    self.title = @"你好";
    self.view.backgroundColor =[UIColor whiteColor];
    _arr = @[@"http://ww2.sinaimg.cn/thumbnail/904c2a35jw1emu3ec7kf8j20c10epjsn.jpg",
             @"http://ww2.sinaimg.cn/thumbnail/98719e4agw1e5j49zmf21j20c80c8mxi.jpg",
             @"http://ww2.sinaimg.cn/thumbnail/67307b53jw1epqq3bmwr6j20c80axmy5.jpg",
             @"http://ww2.sinaimg.cn/thumbnail/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg"
             ];
    NSMutableArray *temp = [NSMutableArray new];
    for (int i=0; i<_arr.count; i++) {
        UIButton *button =[[UIButton alloc]initWithFrame:CGRectMake(30+i*75, 100, 50, 50)];
        [button sd_setImageWithURL:[NSURL URLWithString:_arr[i]] forState:UIControlStateNormal];
        button.tag = i+10;
        button.backgroundColor =[UIColor redColor];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    UILabel *label = [[UILabel alloc]init];
    [self.view addSubview:label];
    label.text = @"效果:点击图片，进入大图浏览模式";
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(200);
        make.centerX.equalTo(self.view);
        
    }];
    
    self.modelsArray = [temp copy];

}
- (void)buttonClick:(UIButton *)button
{
    
    [_photoImage showImg:_arr withTag:button.tag+90];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImageBt:)];
    [_photoImage.slideScroll addGestureRecognizer:tap];
    
    
}

//隐藏
- (void)hideImageBt:(UITapGestureRecognizer *)tap{
    NSLog(@"点击了隐藏");
    
    //通过改变透明度，来展示
    [UIView animateWithDuration:0.3 animations:^{
        _photoImage.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        //移除view
        [_photoImage.bgView removeFromSuperview];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
