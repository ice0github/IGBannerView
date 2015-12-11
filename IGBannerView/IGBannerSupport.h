//
//  IGBannerSupport.h
//  IGBannerDemo
//  实现该代理的NSObject都可以作为BannerView的Item
//  Created by 桂强 何 on 15/12/11.
//  Copyright © 2015年 桂强 何. All rights reserved.
//


@protocol IGBannerSupport <NSObject>

@required
- (NSString*)ig_title; // 标题
- (id)ig_image; // 图片，可以是URL、NSString或者UIImage

@end