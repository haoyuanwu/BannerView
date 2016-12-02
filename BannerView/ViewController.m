//
//  ViewController.m
//  BannerView
//
//  Created by wuhaoyuan on 2016/11/21.
//  Copyright © 2016年 wuhaoyuan. All rights reserved.
//

#import "ViewController.h"
#import "BannerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    BannerView *bannerView = [[BannerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 160)];
    bannerView.urlArray = @[@"1",@"2",@"3",@"4"];
    [self.view addSubview:bannerView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
