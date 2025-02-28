//
//  SJTestViewController.m
//  SJVideoPlayer_Example
//
//  Created by 畅三江 on 2019/7/19.
//  Copyright © 2019 changsanjiang. All rights reserved.
//

#import "SJTestViewController.h"
#import <SJVideoPlayer/SJVideoPlayer.h>
#import <Masonry/Masonry.h>
#import <SJUIKit/SJUIKit.h>
#import "SJSourceURLs.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJTestViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *playerContainerView;
@property (nonatomic, strong) SJVideoPlayer *player;


@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SJTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupViews];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    _tableView.backgroundColor = UIColor.whiteColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;

    [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"123"];
    
    SJEdgeControlButtonItem *item = [SJEdgeControlButtonItem frameLayoutWithCustomView:_tableView tag:1001];
    [self.player.defaultEdgeControlLayer.centerAdapter addItem:item];
    [self.player.defaultEdgeControlLayer.centerAdapter reload];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 99;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:@"123" forIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
#ifdef DEBUG
    NSLog(@"%d \t %s", (int)__LINE__, __func__);
#endif
}

#pragma mark -
- (void)_setupViews {
    self.title = NSStringFromClass(self.class);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _player = [SJVideoPlayer player];
    [_playerContainerView addSubview:self.player.view];
    [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    __weak typeof(self) _self = self;
    _player.controlLayerAppearObserver.appearStateDidChangeExeBlock = ^(id<SJControlLayerAppearManager>  _Nonnull mgr) {
        __strong typeof(_self) self = _self;
        if ( !self ) return ;
        self.player.popPromptController.bottomMargin = mgr.isAppeared ? self.player.defaultEdgeControlLayer.bottomContainerView.bounds.size.height : 16;
    };
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.player vc_viewDidAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.player vc_viewWillDisappear];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.player vc_viewDidDisappear];
}

- (BOOL)prefersStatusBarHidden {
    return [self.player vc_prefersStatusBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.player vc_preferredStatusBarStyle];
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

@end
NS_ASSUME_NONNULL_END

#import <SJRouter/SJRouter.h>
@interface SJTestViewController (RouteHandler)<SJRouteHandler>

@end

@implementation SJTestViewController (RouteHandler)

+ (NSString *)routePath {
    return @"test";
}

+ (void)handleRequest:(SJRouteRequest *)request topViewController:(UIViewController *)topViewController completionHandler:(SJCompletionHandler)completionHandler {
    [topViewController.navigationController pushViewController:[[SJTestViewController alloc] initWithNibName:@"SJTestViewController" bundle:nil] animated:YES];
}

@end
