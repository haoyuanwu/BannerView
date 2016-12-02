//
//  BannerView.m
//  BannerView
//
//  Created by wuhaoyuan on 2016/11/21.
//  Copyright © 2016年 wuhaoyuan. All rights reserved.
//

#import "BannerView.h"
#import "BannerCollectionViewCell.h"

@interface BannerView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    //图片的数组
    NSMutableArray *imageArr;
    //计时器
    NSTimer *timer;
    //记录滑动的位置
    CGFloat scrollX;

    //滑块
    UIView *silderView;
}
@property (nonatomic,strong) UICollectionView *collectionView;
@end

static NSString *identifier = @"cellid";
@implementation BannerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        imageArr = [[NSMutableArray alloc] initWithCapacity:1];
        [self addSubview:self.collecionView];
        
        silderView = [[UIView alloc] init];
        silderView.backgroundColor = [UIColor redColor];
        [self addSubview:silderView];
        
    }
    return self;
}

-(void)setUrlArray:(NSArray *)urlArray{
    _urlArray = urlArray;
    if (urlArray.count == 0) {
        return;
    }
    imageArr = [NSMutableArray arrayWithArray:urlArray];
    [imageArr insertObject:_urlArray.lastObject atIndex:0];
    [imageArr insertObject:_urlArray.firstObject atIndex:imageArr.count];
    [self.collecionView reloadData];
    [self.collecionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:(UICollectionViewScrollPositionNone) animated:NO];
    silderView.frame = CGRectMake(0, self.frame.size.height - 2, self.frame.size.width/_urlArray.count, 2);
    [self openTimer];
}

//打开定时器
- (void)openTimer{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        scrollX = self.collecionView.contentOffset.x;
        scrollX += self.frame.size.width;
        NSInteger index = scrollX/self.frame.size.width;
        if (index < imageArr.count) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }else{
            scrollX = self.frame.size.width;
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (scrollX == self.collecionView.contentSize.width - self.frame.size.width) {
                scrollX = self.frame.size.width;
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            }
        });
    }];
}

- (UICollectionView *)collecionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.itemSize = self.frame.size;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[BannerCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return imageArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BannerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",imageArr[indexPath.item]];
//    cell.imageView.image = imageArr[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.touchBlock) {
        self.touchBlock(indexPath.item);
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    silderView.transform = CGAffineTransformMakeTranslation(scrollView.contentOffset.x/_urlArray.count, 0);
    if (!timer) {
        if (scrollX == self.collecionView.contentSize.width - self.frame.size.width) {
            scrollX = self.frame.size.width;
            [self.collecionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:(UICollectionViewScrollPositionNone) animated:NO];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //手动滑动关闭计时器
    [timer invalidate];
    timer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    scrollView.userInteractionEnabled = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    scrollView.userInteractionEnabled = YES;
    scrollX = scrollView.contentOffset.x;
    if (scrollX == 0) {
        self.collecionView.contentOffset = CGPointMake(self.frame.size.width * (imageArr.count-2), 0);
    }else if (scrollX == (imageArr.count-1) * self.frame.size.width) {
        self.collecionView.contentOffset = CGPointMake(self.frame.size.width, 0);
    }
    scrollX = scrollView.contentOffset.x;
    //再次打开计时器
    [self openTimer];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
