//
//  IGBannerView.h
//  IGBannerDemo
//
//  Created by 桂强 何 on 15/12/11.
//  Copyright © 2015年 桂强 何. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGBannerItem.h"

@protocol IGBannerViewDelegate;

@interface IGBannerView : UIView

@property (nonatomic, assign) BOOL           allowRunLoopDelay; // default is YES，当有其他的ScrollView在滚动的时候，允许系统延迟Timer的回调
@property (nonatomic, assign) BOOL           autoScrolling; // default is YES;
@property (nonatomic, assign) NSTimeInterval switchTimeInterval; // default for 5s;

@property (nonatomic, weak) id<IGBannerViewDelegate> delegate;

/* 标题栏属性 */
@property (nonatomic, assign) BOOL    showsTitle; // default is NO
@property (nonatomic, strong) UIColor *titleColor; // default is white
@property (nonatomic, strong) UIColor *titleBackgroundColor; // default is black(alpha is 35%)
@property (nonatomic, strong) UIFont  *titleFont; // default is system(14)
@property (nonatomic, assign) CGFloat titleHeight; // default is 20

/* Page Control属性 */
@property (nonatomic, assign) CGFloat pageControlHeight; // default is 14;
@property (nonatomic, strong) UIColor *pageControlBackgroundColor; // default is black(alpha is 35%)


@property (nonatomic,strong) UIImage   *placeholderImage;

@property (nonatomic,assign) NSInteger flag;
@property (nonatomic,strong) id        extra;

- (id)initWithFrame:(CGRect)frame bannerItem:(id<IGBannerSupport>)item, ... NS_REQUIRES_NIL_TERMINATION;
- (id)initWithFrame:(CGRect)frame bannerItems:(NSArray<id<IGBannerSupport>>*)items;

- (NSArray<id<IGBannerSupport>>*)items;

- (void)setItems:(NSArray<id<IGBannerSupport>>*)neoItems;

- (void)reloadBanner;


@end

@protocol IGBannerViewDelegate <NSObject>

@required
-(void)bannerView:(IGBannerView*)bannerView didSelectAtIndex:(NSInteger)index withItem:(id<IGBannerSupport>)item;

@end
