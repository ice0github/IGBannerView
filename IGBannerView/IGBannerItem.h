//
//  IGBannerItem.h
//  IGBannerDemo
//
//  Created by 桂强 何 on 15/12/11.
//  Copyright © 2015年 桂强 何. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IGBannerSupport.h"

@interface IGBannerItem : NSObject<IGBannerSupport>

@property (nonatomic,copy   ,getter = ig_title) NSString  *title;
@property (nonatomic,strong ,getter = ig_image) id        image;

@property (nonatomic,strong ) id        extra;
@property (nonatomic, assign) NSInteger tag;

/**
 *  构造方法
 *
 *  @param atitle 标题
 *  @param aimage 图片，UIImage、NSURL和NSString都可以
 *  @param atag   标记
 *
 *  @return 返回Item实例
 */
- (instancetype)initWithTitle:(NSString *)title image:(id)image tag:(NSInteger)tag;

/**
 *  构造方法-类方法版本
 *
 *  @param atitle 标题
 *  @param aimage 图片，UIImage、NSURL和NSString都可以
 *  @param atag   标记
 *
 *  @return 返回Item实例
 */
+ (instancetype)itemWithTitle:(NSString *)title image:(id)image tag:(NSInteger)tag;


@end
