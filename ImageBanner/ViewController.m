//
//  ViewController.m
//  ImageBanner
//
//  Created by 朱云 on 16/3/25.
//  Copyright © 2016年 yunxtk. All rights reserved.
//

#import "ViewController.h"

static NSInteger HEIGHT =  320;
static NSUInteger currentImage = 1;
static CGFloat const chageImageTime = 3.0;
#define  SCREENWIDHT [UIScreen mainScreen].bounds.size.width
@interface ViewController ()<UIScrollViewDelegate>{
    NSTimer * _moveTime;
    //用于确定滚动式由人导致的还是计时器到了,系统帮我们滚动的,YES,则为系统滚动,NO则为客户滚动(ps.在客户端中客户滚动一个广告后,这个广告的计时器要归0并重新计时)
    BOOL _isTimeUp;
}
@property (strong,nonatomic) NSArray* arrayImages;
@property (strong,nonatomic) UIImageView* leftImageView;
@property (strong,nonatomic) UIImageView* currentImageView;
@property (strong,nonatomic) UIImageView* rightImageView;
@property (strong,nonatomic) UIScrollView* scrollView;
@property (nonatomic,strong) UIPageControl* pageControl;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arrayImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"1.jpg"],[UIImage imageNamed:@"2.jpg"],[UIImage imageNamed:@"3.jpg"], nil];
    CGRect rect = CGRectMake(0, 0, SCREENWIDHT, 320);
    rect.size.height = HEIGHT;
    _scrollView = [[UIScrollView alloc] initWithFrame:rect];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    _scrollView.contentOffset = CGPointMake(SCREENWIDHT, 0);
    _scrollView.contentSize = CGSizeMake(SCREENWIDHT * 3,HEIGHT);
    [self.view addSubview:_scrollView];
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, HEIGHT, SCREENWIDHT, 35)];
    [self.view addSubview:_pageControl];
    _pageControl.enabled = NO;
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = _arrayImages.count;
    _pageControl.backgroundColor = [UIColor blackColor];
    [self addSubImageViews];
    _moveTime = [NSTimer scheduledTimerWithTimeInterval:chageImageTime target:self selector:@selector(animalMoveImage) userInfo:nil repeats:YES];
    _isTimeUp = NO;
}
- (void)addSubImageViews{
    CGRect rect = CGRectMake(0, 0, SCREENWIDHT, HEIGHT);
    _leftImageView = [[UIImageView alloc] initWithFrame:rect];
    _leftImageView.image = _arrayImages[0];
    [_scrollView addSubview:_leftImageView];
    
    rect.origin.x += SCREENWIDHT;
    _currentImageView =  [[UIImageView alloc] initWithFrame:rect];
    _currentImageView.image = _arrayImages[1];
    [_scrollView addSubview:_currentImageView];
    rect.origin.x += SCREENWIDHT;
    _rightImageView = [[UIImageView alloc] initWithFrame:rect];
    _rightImageView.image = _arrayImages[2];
    [_scrollView addSubview:_rightImageView];
}
#pragma mark - 计时器到时,系统滚动图片
- (void)animalMoveImage
{
    //第一次滚动距离，后面不在使用
    [_scrollView setContentOffset:CGPointMake(SCREENWIDHT * 2, 0) animated:YES];
    _isTimeUp = YES;
    [NSTimer scheduledTimerWithTimeInterval:0.4f target:self selector:@selector(scrollViewDidEndDecelerating:) userInfo:nil repeats:NO];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.scrollView.contentOffset.x == 0){
        currentImage = (currentImage-1+3)%_arrayImages.count;
        _pageControl.currentPage = (_pageControl.currentPage - 1+3)%_arrayImages.count;
    }else if(self.scrollView.contentOffset.x == SCREENWIDHT * 2){
        currentImage = (currentImage+1)%_arrayImages.count;
        _pageControl.currentPage = (_pageControl.currentPage + 1)%_arrayImages.count;
    }else{
        return;
    }
    
    _leftImageView.image = _arrayImages[(currentImage-1+3)%_arrayImages.count];
    _currentImageView.image = _arrayImages[currentImage%_arrayImages.count];
    _rightImageView.image = _arrayImages[(currentImage+1)%_arrayImages.count];
    NSLog(@"currentImage %ld",currentImage);
    self.scrollView.contentOffset = CGPointMake(SCREENWIDHT, 0);
    
    //手动控制图片滚动应该取消那个三秒的计时器
    if (!_isTimeUp) {
        [_moveTime setFireDate:[NSDate dateWithTimeIntervalSinceNow:chageImageTime]];
    }
    _isTimeUp = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
