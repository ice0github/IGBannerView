//
//  IGBannerItem.m
//  IGBannerDemo
//
//  Created by 桂强 何 on 15/12/11.
//  Copyright © 2015年 桂强 何. All rights reserved.
//

#import "IGBannerItem.h"

@implementation IGBannerItem

- (instancetype)initWithTitle:(NSString *)atitle image:(id)aimage tag:(NSInteger)atag{
    self = [super init];
    if (self) {
        _title = atitle;
        _image = aimage;
        _tag   = atag;
    }
    return self;
}

+ (instancetype)itemWithTitle:(NSString *)atitle image:(id)aimage tag:(NSInteger)atag{
    return [[IGBannerItem alloc] initWithTitle:atitle image:aimage tag:atag];
}

@end
