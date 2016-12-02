//
//  BannerView.h
//  BannerView
//
//  Created by wuhaoyuan on 2016/11/21.
//  Copyright © 2016年 wuhaoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BannerView : UIView

@property (nonatomic,strong) void(^touchBlock)(NSInteger);
/**
 照片地址数组
 */
@property (nonatomic,strong) NSArray *urlArray;
@end
