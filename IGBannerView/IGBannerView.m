//
//  IGBannerView.m
//  IGBannerDemo
//
//  Created by 桂强 何 on 15/12/11.
//  Copyright © 2015年 桂强 何. All rights reserved.
//

#import "IGBannerVIew.h"
#import <SDWebImage/UIImageView+WebCache.h>

static const NSInteger TAG_OF_IMAGE_VIEW = 1000;
static const NSInteger TAG_OF_TITLE_VIEW = 2000;

@interface IGBannerView ()<UIGestureRecognizerDelegate,UIScrollViewDelegate>{
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    
    NSArray *items;
    
    NSTimer *timer;
}

@end

@implementation IGBannerView

- (id)initWithFrame:(CGRect)frame bannerItem:(id<IGBannerSupport>)firstItem, ... NS_REQUIRES_NIL_TERMINATION{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        NSMutableArray *tmpItems = [[NSMutableArray alloc] init];
        
        id<IGBannerSupport> eachItem;
        
        va_list argumentList;
        if (firstItem) {
            [tmpItems addObject: firstItem];
            va_start(argumentList, firstItem);
            while((eachItem = va_arg(argumentList, id<IGBannerSupport>))) {
                [tmpItems addObject: eachItem];
            }
            va_end(argumentList);
        }
        
        items = [NSArray arrayWithArray:tmpItems];
        
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame bannerItems:(NSArray<id<IGBannerSupport>>*)aitems{
    self = [super initWithFrame:frame];
    
    if (self) {
        items = aitems;
        
        if (!items || ![items isKindOfClass:[NSArray class]]) {
            items = [[NSArray alloc] init];
        }
        
        [self setup];
    }
    return self;
}

- (void)dealloc{
    [self cleanTimer];
    
}

-(void)setup{
    [self initParameters];
    [self setupViews];
    
    [self toggleAllowRunLoopDelay];
}

- (void)initParameters{
    _switchTimeInterval = 5.0f;
    _autoScrolling      = YES;
    _allowRunLoopDelay  = YES;
    
    _pageControlHeight          = 14;
    _pageControlBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.35];
    
    _titleHeight          = 20;
    _titleFont            = [UIFont systemFontOfSize:14];
    _titleBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.35];
    _titleColor           = [UIColor whiteColor];
    _showsTitle           = YES;
    
}

- (void)setupViews{
    
    scrollView                                = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.delegate                       = self;
    scrollView.showsVerticalScrollIndicator   = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled                  = YES;
    scrollView.directionalLockEnabled         = YES;
    scrollView.alwaysBounceHorizontal         = YES;
    scrollView.bounces                        = NO;
    [self addSubview:scrollView];

    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
    tapGestureRecognize.delegate = self;
    [scrollView addGestureRecognizer:tapGestureRecognize];



    pageControl                        = [[UIPageControl alloc] init];
    pageControl.frame                  = CGRectMake(0,
                                                    self.frame.size.height - _pageControlHeight,
                                                    self.frame.size.width,
                                                    _pageControlHeight);
    pageControl.backgroundColor        = _pageControlBackgroundColor;
    pageControl.currentPage            = 0;
    pageControl.userInteractionEnabled = NO;
    [pageControl addTarget:self
                    action:@selector(pageControlTapped:)
          forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:pageControl];
    
    // 加载数据
    [self reloadBanner];
}

- (void)cleanBanner{
    [scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)reloadBanner{
    [self cleanBanner];
    
    pageControl.numberOfPages = items.count;
    
    CGSize scrollViewSize = scrollView.frame.size;
    
    
    for (NSInteger i = 0; i < items.count; i++) {
        id<IGBannerSupport> item = [items objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(i * scrollViewSize.width,
                                     0.f,
                                     scrollViewSize.width,
                                     scrollViewSize.height);
        imageView.tag = TAG_OF_IMAGE_VIEW + i;
        imageView.contentMode = UIViewContentModeScaleToFill;
        
        id tmpImage = [item ig_image];
        
        if (tmpImage && [tmpImage isKindOfClass:[UIImage class]]) {
            imageView.image = tmpImage;
        }else if (tmpImage && [tmpImage isKindOfClass:[NSURL class]]){
            [imageView sd_setImageWithURL:(NSURL*)tmpImage
                         placeholderImage:_placeholderImage];
            
        }else if (tmpImage && [tmpImage isKindOfClass:[NSString class]] && [tmpImage length] > 0){
            [imageView sd_setImageWithURL:[NSURL URLWithString:tmpImage]
                         placeholderImage:_placeholderImage];
            
        }else{
            imageView.image = _placeholderImage;
        }
        
        [scrollView addSubview:imageView];
        
        NSString *title = [item ig_title];
        
        if (title && [title isKindOfClass:[NSString class]]) {
            UILabel *label        = [[UILabel alloc] init];
            label.frame           = CGRectMake(imageView.frame.origin.x,
                                               scrollViewSize.height-_titleHeight-_pageControlHeight,
                                               imageView.frame.size.width,
                                               _titleHeight);
            label.backgroundColor = _titleBackgroundColor;
            label.textColor       = _titleColor;
            label.textAlignment   = NSTextAlignmentCenter;
            label.lineBreakMode   = NSLineBreakByTruncatingTail;
            label.font            = _titleFont;
            label.tag             = TAG_OF_TITLE_VIEW + i;
            label.text            = title;
            label.hidden          = !_showsTitle;
            [scrollView addSubview:label];
        }
    }
    
    scrollView.contentSize = CGSizeMake(scrollViewSize.width * items.count,
                                        self.frame.size.height);

}

#pragma mark - ----> 自动适配界面
-(void)layoutSelf{
    
    scrollView.frame = self.bounds;
    
    pageControl.frame = CGRectMake(0,
                                   self.frame.size.height - _pageControlHeight,
                                   self.frame.size.width,
                                   _pageControlHeight);

    
    CGSize scrollViewSize = scrollView.frame.size;
    for (NSInteger i = 0; i < items.count; i++) {
        UIView *imageView = [scrollView viewWithTag:TAG_OF_IMAGE_VIEW + i];
        UIView *titleView = [scrollView viewWithTag:TAG_OF_TITLE_VIEW + i];

        if (imageView && [imageView isKindOfClass:[UIImageView class]]) {
            imageView.frame = CGRectMake(i * scrollViewSize.width,
                                         0.f,
                                         scrollViewSize.width,
                                         scrollViewSize.height);
        }
        
        if (titleView && [titleView isKindOfClass:[UILabel class]]) {
            titleView.frame = CGRectMake(imageView.frame.origin.x,
                                         scrollViewSize.height-_titleHeight-_pageControlHeight,
                                         imageView.frame.size.width,
                                         _titleHeight);
        }
    }
    
    scrollView.contentSize = CGSizeMake(scrollViewSize.width * items.count,
                                        self.frame.size.height);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self layoutSelf];
}


#pragma mark - Actions

- (void)pageControlTapped:(id)sender{
    UIPageControl *pc = (UIPageControl *)sender;
    [self moveToTargetPage:pc.currentPage];
}

- (void)singleTapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer{
    NSInteger targetPage = (scrollView.contentOffset.x / scrollView.frame.size.width);
    if (targetPage > -1 && targetPage < items.count) {
        id<IGBannerSupport> item = [items objectAtIndex:targetPage];
        //delegate
        if (_delegate) {
            [_delegate bannerView:self didSelectAtIndex:targetPage withItem:item];
        }
    }
}

#pragma mark - ScrollView Move

- (void)moveToTargetPage:(NSInteger)targetPage{
    CGFloat targetX = targetPage * scrollView.frame.size.width;
    [self moveToTargetPosition:targetX];
}

- (void)switchFocusImageItems{
    CGFloat targetX = scrollView.contentOffset.x + scrollView.frame.size.width;
    [self moveToTargetPosition:targetX];
}

- (void)moveToTargetPosition:(CGFloat)targetX
{
    if (targetX >= scrollView.contentSize.width) {
        targetX = 0.0;
    }
    
    [scrollView setContentOffset:CGPointMake(targetX, 0) animated:YES] ;
    pageControl.currentPage = (int)(scrollView.contentOffset.x / scrollView.frame.size.width);
}
#pragma mark - Access Method

- (NSArray<id<IGBannerSupport>>*)items{
    return items;
}

- (void)setItems:(NSArray<id<IGBannerSupport>>*)neoItems{
    items = neoItems?neoItems:@[];
    [self reloadBanner];
}

- (void)setAutoScrolling:(BOOL)enable
{
    if (_autoScrolling != enable) {
        _autoScrolling = enable;
        [self toggleAutoScrolling];
    }
}

- (void)toggleAutoScrolling{
    if (_autoScrolling) {
        [self setupTimer];
        if (!_allowRunLoopDelay) {
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        }
    }else{
        [self cleanTimer];
    }
}

- (void)setAllowRunLoopDelay:(BOOL)allowRunLoopDelay{
    if (_allowRunLoopDelay != allowRunLoopDelay) {
        _allowRunLoopDelay = allowRunLoopDelay;
        [self toggleAllowRunLoopDelay];
    }
}

- (void)toggleAllowRunLoopDelay{
    if (timer) {
        [self cleanTimer];
    }
    if (_autoScrolling) {
        [self toggleAutoScrolling];
    }
}

#pragma mark - ----> Timer
- (void)setupTimer{
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:_switchTimeInterval
                                                 target:self
                                               selector:@selector(switchFocusImageItems)
                                               userInfo:nil
                                                repeats:YES];

    }
}

- (void)cleanTimer{
    if (timer && timer.isValid) {
        [timer invalidate];
    }
    timer = nil;
}

#pragma mark - ----> Title

-(void)setShowsTitle:(BOOL)showsTitle{
    if (_showsTitle != showsTitle) {
        _showsTitle = showsTitle;
        [scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UILabel class]]) {
                [(UILabel*)obj setHidden:!_showsTitle];
            }
        }];
    }
}

-(void)setTitleColor:(UIColor *)color{
    _titleColor = color;
    [scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UILabel class]]) {
            [(UILabel*)obj setTextColor:_titleColor];
        }
    }];
}
-(void)setTitleBackgroundColor:(UIColor *)aColor{
    _titleBackgroundColor = aColor;
    [scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UILabel class]]) {
            [(UILabel*)obj setBackgroundColor:_titleBackgroundColor];
        }
    }];
}

-(void)setTitleFont:(UIFont *)aFont{
    _titleFont = aFont;
    [scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UILabel class]]) {
            [(UILabel*)obj setFont:_titleFont];
        }
    }];
}

-(void)setTitleHeight:(CGFloat)height{
    if (_titleHeight != height) {
        _titleHeight = MAX(height, 0);
        
        [self resetTitleLabelFrame];
    }
}

- (void)resetTitleLabelFrame{
    CGSize scrollViewSize = scrollView.frame.size;
    [scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UILabel class]]) {
            [(UILabel*)obj setFrame:CGRectMake(obj.frame.origin.x,
                                               scrollViewSize.height-_titleHeight-_pageControlHeight,
                                               scrollViewSize.width,
                                               _titleHeight)];
        }
    }];
}

#pragma mark - ----> Page Controller
-(void)setPageControlHeight:(CGFloat)height{
    if (_pageControlHeight != height) {
        _pageControlHeight = MAX(height, 0);
        
        pageControl.frame = CGRectMake(0,
                                       self.frame.size.height - _pageControlHeight,
                                       self.frame.size.width,
                                       _pageControlHeight);
        
        [self resetTitleLabelFrame];
    }
}

-(void)setPageControlBackgroundColor:(UIColor *)color{
    _pageControlBackgroundColor = color;
    pageControl.backgroundColor = _pageControlBackgroundColor;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)ascrollView
{
    pageControl.currentPage = (NSInteger)(scrollView.contentOffset.x / scrollView.frame.size.width);
}




@end
