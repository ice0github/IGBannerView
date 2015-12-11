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

/**
 *  当有其他的ScrollView在滚动的时候，允许系统延迟Timer的回调，默认YES
 */
@property (nonatomic, assign) BOOL           allowRunLoopDelay;
/**
 *  是否允许Banner自动滚动，默认 Yes
 */
@property (nonatomic, assign) BOOL           autoScrolling;
/**
 *  Banner切换图片的频率， 默认 5s
 */
@property (nonatomic, assign) NSTimeInterval switchTimeInterval;
/**
 *  Banner代理，主要实现点击事件的转发
 */
@property (nonatomic, weak) id<IGBannerViewDelegate> delegate;

/**
 *  是否显示标题，默认 YES
 */
@property (nonatomic, assign) BOOL    showsTitle;
/**
 *  标题 的字体颜色色， 默认 白色
 */
@property (nonatomic, strong) UIColor *titleColor;
/**
 *  标题 的背景色， 默认 黑色（透明度35%）
 */
@property (nonatomic, strong) UIColor *titleBackgroundColor;
/**
 *  标题 的字体，默认 14（系统字体）
 */
@property (nonatomic, strong) UIFont  *titleFont;
/**
 *  标题 的高度，默认 20
 */
@property (nonatomic, assign) CGFloat titleHeight;

/**
 *  Page Controller 的高度，默认 14
 */
@property (nonatomic, assign) CGFloat pageControlHeight;
/**
 *  Page Controller 的背景色， 默认 黑色（透明度35%）
 */
@property (nonatomic, strong) UIColor *pageControlBackgroundColor;

/**
 *  缺省图，请务必设置一个
 */
@property (nonatomic,strong) UIImage   *placeholderImage;

/**
 *  可以设置标记，方便实现业务
 */
@property (nonatomic,assign) NSInteger flag;
/**
 *  额外携带的对象，方便实现业务
 */
@property (nonatomic,strong) id        extra;


- (id)initWithFrame:(CGRect)frame bannerItem:(id<IGBannerSupport>)item, ... NS_REQUIRES_NIL_TERMINATION;
- (id)initWithFrame:(CGRect)frame bannerItems:(NSArray<id<IGBannerSupport>>*)items;

/**
 *  获取BannerView当前的Item列表
 *
 *  @return Item列表
 */
- (NSArray<id<IGBannerSupport>>*)items;

/**
 *  更换Item列表，并重置BannerView
 *
 *  @param neoItems Item列表
 */
- (void)setItems:(NSArray<id<IGBannerSupport>>*)neoItems;

/**
 *  移除并重新创建ScrollView的SubView
 */
- (void)reloadBanner;


@end

@protocol IGBannerViewDelegate <NSObject>

@required
-(void)bannerView:(IGBannerView*)bannerView didSelectAtIndex:(NSInteger)index withItem:(id<IGBannerSupport>)item;

@end
