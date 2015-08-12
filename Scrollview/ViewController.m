//
//  ViewController.m
//  Scrollview
//
//  Created by 杨琴 on 15/8/10.
//  Copyright (c) 2015年 yangqin. All rights reserved.
//

#import "ViewController.h"

#define kPageCount 6

@interface ViewController ()<UIScrollViewDelegate>
{
    NSInteger _currentPage;
}

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *allDatas;
@property (nonatomic, strong) NSMutableArray *displayDatas; // 当前显示的3个view

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated
{
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
       self.pageControl.numberOfPages = kPageCount;
    
    self.allDatas = [NSMutableArray arrayWithCapacity:1];
    self.displayDatas = [NSMutableArray arrayWithCapacity:1];
    _currentPage = 0;
    
    [self setupDatas];
    [self reloadDisplayDatasCurrentPage:_currentPage];
       [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width + 1, 0) animated:NO];
    self.pageControl.currentPage = _currentPage;

}

- (void)setupDatas
{
    CGRect frame = CGRectMake(0, 0, self.scrollView.frame.size.width, CGRectGetHeight(self.scrollView.frame));
    
    for (int i = 0; i < kPageCount; i++) {
        
        UIView *view = [[UIView alloc] initWithFrame:frame];
        view.tag = i;
        view.backgroundColor = i % 2 ? [UIColor greenColor] : [UIColor blueColor];
        [self.allDatas addObject:view];
    }
}

- (void)reloadDisplayDatasCurrentPage:(NSInteger)page
{
    if (page >= self.allDatas.count || page < 0) {
        return;
    }
    if (self.displayDatas.count > 1) {
        [self.displayDatas removeAllObjects];
    }
    
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    if (page == [self.allDatas count] - 1) {
        
        [self.displayDatas addObject:self.allDatas[page - 1]];
        [self.displayDatas addObject:self.allDatas[page]];
        [self.displayDatas addObject:self.allDatas[0]];
    } else if (page == 0) {
        [self.displayDatas addObject:self.allDatas[kPageCount - 1]];
        [self.displayDatas addObject:self.allDatas[page]];
        [self.displayDatas addObject:self.allDatas[page + 1]];
    } else {
        [self.displayDatas addObject:self.allDatas[page - 1]];
        [self.displayDatas addObject:self.allDatas[page]];
        [self.displayDatas addObject:self.allDatas[page + 1]];
    }
    
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < self.displayDatas.count; i++) {
        UIView *view = self.displayDatas[i];
        CGRect frame = view.frame;
        frame.origin.x = i * CGRectGetWidth(frame);
        view.frame = frame;
        [self.scrollView addSubview:view];
    }
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0) animated:NO];
    self.pageControl.currentPage = _currentPage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
   }

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat off = scrollView.contentOffset.x;
    NSInteger page = floorf( off / CGRectGetWidth(self.scrollView.frame));
    if (page >= 2) {
        _currentPage = [self validPageValue:_currentPage + 1];
        [self reloadDisplayDatasCurrentPage:_currentPage];
    }
    if (off <= 0) {
        _currentPage = [self validPageValue:_currentPage - 1];
        [self reloadDisplayDatasCurrentPage:_currentPage];
    }
    NSLog(@"page =%ld", (long)page);
    
}
- (NSInteger)validPageValue:(NSInteger)value
{
    if(value < 0)    value = kPageCount - 1;
    if(value == kPageCount)  value = 0;
    return value;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
