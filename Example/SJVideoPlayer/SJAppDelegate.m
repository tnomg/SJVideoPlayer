//
//  SJAppDelegate.m
//  SJVideoPlayer
//
//  Created by changsanjiang on 06/08/2019.
//  Copyright (c) 2019 changsanjiang. All rights reserved.
//

#import "SJAppDelegate.h"
#import "SJVideoPlayer.h"
#import "SJRotationManager.h"

#warning Configuring rotation control. 请配置旋转控制!

static BOOL _iPhone_shouldAutorotate(UIViewController *vc) {
    NSString *class = NSStringFromClass(vc.class);
    
    // 禁止哪些控制器旋转.
    // - `return NO` 将只旋转播放器视图. 为了避免`所有控制器`同`播放器`一起旋转, 可以在此直接`return NO;`.
    //
    // return NO;
    
    // - 为避免控制器同播放器一起旋转, 此处为禁止Demo中SJ前缀的控制器旋转.
    if ( [class hasPrefix:@"SJ"] ) {
        return NO;
    }
    
    return YES;
}

@implementation UIViewController (RotationControl)
/// 该控制器是否可以旋转
- (BOOL)shouldAutorotate {
    // 此处为设置 iPhone 哪些控制器可以旋转
    if ( UIUserInterfaceIdiomPhone == UI_USER_INTERFACE_IDIOM() )
        return _iPhone_shouldAutorotate(self);
    
    // 此处为设置 iPad 所有控制器都可以旋转
    // - 请根据实际情况进行修改.
    else if ( UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM() ) {
        return YES;
    }
    return NO;
}

/// 旋转支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    // 此处为设置 iPhone 某个控制器旋转支持的方向
    // - 请根据实际情况进行修改.
    if ( UIUserInterfaceIdiomPhone == UI_USER_INTERFACE_IDIOM() ) {
        // 如果self不支持旋转, 返回仅支持竖屏
        if ( _iPhone_shouldAutorotate(self) == NO )
            return UIInterfaceOrientationMaskPortrait;
    }
    
    // 此处为设置 iPad 仅支持横屏
    // - 请根据实际情况进行修改.
    else if ( UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM() ) {
        return UIInterfaceOrientationMaskLandscape;
    }

    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end


@implementation UITabBarController (RotationControl)
- (UIViewController *)sj_topViewController {
    if ( self.selectedIndex == NSNotFound )
        return self.viewControllers.firstObject;
    return self.selectedViewController;
}

- (BOOL)shouldAutorotate {
    return [[self sj_topViewController] shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [[self sj_topViewController] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[self sj_topViewController] preferredInterfaceOrientationForPresentation];
}
@end

@implementation UINavigationController (RotationControl)
- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}

- (nullable UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (nullable UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}
@end


#pragma mark -

@implementation SJAppDelegate

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

#ifdef DEBUG
    NSLog(@"%@", NSTemporaryDirectory());
#endif
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.backgroundColor = [UIColor whiteColor];
    NSString *name = UIUserInterfaceIdiomPhone == UI_USER_INTERFACE_IDIOM()?@"Main":@"iPadMain";
    _window.rootViewController = [[UIStoryboard storyboardWithName:name bundle:nil] instantiateInitialViewController];
    [_window makeKeyAndVisible];


    SJVideoPlayer.update(^(SJVideoPlayerSettings * _Nonnull common) {
        common.placeholder = [UIImage imageNamed:@"placeholder"];
        common.progress_thumbSize = 8;
        common.progress_trackColor = [UIColor colorWithWhite:0.8 alpha:1];
        common.progress_bufferColor = [UIColor whiteColor];
    });
    
    // Override point for customization after application launch.
    return YES;
}
@end
