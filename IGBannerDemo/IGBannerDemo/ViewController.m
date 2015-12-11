//
//  ViewController.m
//  IGBannerDemo
//
//  Created by 桂强 何 on 15/12/11.
//  Copyright © 2015年 桂强 何. All rights reserved.
//

#import "ViewController.h"
#import "IGBannerView.h"


typedef NS_ENUM(NSInteger, BannerFlag) {
    BannerFlagLocation = 0,
    BannerFlagNetworking
};

typedef NS_ENUM(NSInteger, ReloadButtonType) {
    ReloadButtonTypeLocation = 20,
    ReloadButtonTypeNetwork
    
};

@interface ViewController ()<IGBannerViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    IGBannerView *banner;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildUI];
}

#pragma mark - ----> 界面

- (void)buildUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupActionButton];

    
    banner = [[IGBannerView alloc] initWithFrame:CGRectMake(0, 60, self.view.bounds.size.width, 200)
                                              bannerItem:[IGBannerItem itemWithTitle:@"标题1"
                                                                               image:[UIImage imageNamed:@"lm_0"]
                                                                                 tag:0],
                      [IGBannerItem itemWithTitle:nil
                                            image:[UIImage imageNamed:@"lm_1"]
                                              tag:1],
                      [IGBannerItem itemWithTitle:@"标题3"
                                            image:[UIImage imageNamed:@"lm_2"]
                                              tag:2],
                      nil];
    
    banner.delegate      = self;
    [self.view addSubview:banner];
    

    UITableView *table    = [[UITableView alloc] init];
    table.frame           = CGRectMake(0, 60+200, self.view.bounds.size.width, self.view.bounds.size.height-60-200);
    table.dataSource      = self;
    table.delegate        = self;
    table.allowsSelection = NO;
    [self.view addSubview:table];
}

- (void)setupActionButton{
    UIButton *reloadBannerButton = nil;
    
    reloadBannerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    reloadBannerButton.frame = CGRectMake(0, 20, 70, 40);
    reloadBannerButton.tag = ReloadButtonTypeLocation;
    [reloadBannerButton setTitle:@"Reload L" forState:UIControlStateNormal];
    [reloadBannerButton addTarget:self
                           action:@selector(handleReloadBannerButtonClicked:)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reloadBannerButton];
    
    reloadBannerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    reloadBannerButton.frame = CGRectMake(80, 20, 70, 40);
    reloadBannerButton.tag = ReloadButtonTypeNetwork;
    [reloadBannerButton setTitle:@"Reload N" forState:UIControlStateNormal];
    [reloadBannerButton addTarget:self
                           action:@selector(handleReloadBannerButtonClicked:)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reloadBannerButton];
    
    UIButton *allowRunloopDelay = [UIButton buttonWithType:UIButtonTypeSystem];
    allowRunloopDelay.frame = CGRectMake(160, 20, 70, 40);
    [allowRunloopDelay setTitle:@"Delay" forState:UIControlStateNormal];
    [allowRunloopDelay setTitle:@"Real" forState:UIControlStateSelected];
    [allowRunloopDelay addTarget:self
                          action:@selector(handleRunloopButtonClicked:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:allowRunloopDelay];
}

#pragma mark - ----> Banner Delegate
-(void)bannerView:(IGBannerView*)bannerView didSelectAtIndex:(NSInteger)index withItem:(id<IGBannerSupport>)item{
    if (item) {
        NSString *flagString = @"未知";
        
        switch (bannerView.flag) {
            case BannerFlagLocation:
                flagString = @"本地图片";
                break;
            case BannerFlagNetworking:
                flagString = @"网络图片";
                break;
            default:
                break;
        }
        
        [[[UIAlertView alloc] initWithTitle:@"提示"
                                    message:[NSString stringWithFormat:@"%@-%ld",flagString,index]
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles: nil] show];
    }
}

#pragma mark - ----> TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

static NSString *cellID = @"BannerTest";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    cell.textLabel.text = [NSString stringWithFormat:@"Row - %ld",indexPath.row];
    return cell;
}

#pragma mark - ----> 事件
/**
 *  刷新Banner的数据
 *
 */
- (void)handleReloadBannerButtonClicked:(UIButton*)sender{
    NSArray *items = nil;
    
    switch (sender.tag) {
        case ReloadButtonTypeLocation:
            items = @[
                      [IGBannerItem itemWithTitle:@"标题1"
                                            image:[UIImage imageNamed:@"lrm_0"]
                                              tag:0],
                      [IGBannerItem itemWithTitle:@"标题2"
                                            image:[UIImage imageNamed:@"lrm_1"]
                                              tag:1],
                      [IGBannerItem itemWithTitle:@"标题3"
                                            image:[UIImage imageNamed:@"lrm_2"]
                                              tag:2],
                      ];
            break;
        case ReloadButtonTypeNetwork:
            items = @[
                      [IGBannerItem itemWithTitle:@"标题1"
                                            image:@"http://g.picphotos.baidu.com/album/s%3D1600%3Bq%3D90/sign=0fc65cfb54fbb2fb302b5c147f7a1bd5/960a304e251f95ca87e0c610c8177f3e6709527a.jpg"
                                              tag:0],
                      [IGBannerItem itemWithTitle:@"标题2"
                                            image:@"http://a.picphotos.baidu.com/album/s%3D1600%3Bq%3D90/sign=d6080af5f7246b607f0eb672dbc8213d/4610b912c8fcc3ceabfc9d959345d688d43f2053.jpg"
                                              tag:1],
                      [IGBannerItem itemWithTitle:@"标题3"
                                            image:@"http://c.picphotos.baidu.com/album/s%3D1600%3Bq%3D90/sign=d155f3392fdda3cc0fe4bc2631d90270/f636afc379310a55297ab452b64543a98226103d.jpg"
                                              tag:2],
                      ];
            break;
        default:
            break;
    }
    
    [banner setItems:items];
}

/**
 *  改变RunLoop延迟的设置
 *
 */
- (void)handleRunloopButtonClicked:(UIButton*)sender{

    sender.selected = !sender.selected;

    banner.allowRunLoopDelay = !sender.selected;
}


@end
