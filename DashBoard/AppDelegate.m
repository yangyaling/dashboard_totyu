//
//  AppDelegate.m
//  DashBoard
//
//  Created by totyu3 on 17/1/17.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import "AppDelegate.h"
#import "SDWebImageDownloader.h"
#import "SDWebImageManager.h"
#import <AVFoundation/AVFoundation.h>
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) UIAlertController *UserAlert;
@property (nonatomic, strong) UIAlertController *VisualSetAlert;
@end

@implementation AppDelegate

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    NSLog(@"%@ %@",notification.userInfo[@"alerttype"],notification.alertBody);
    if ([notification.userInfo[@"alerttype"]isEqualToString:@"alertinfo"]) {
        [CATransaction setCompletionBlock:^{
            
            //弹出alert框之前先dismiss
            [_UserAlert dismissViewControllerAnimated:YES completion:nil];    //在KeyWindow上弹出alert框(每个页面都能看到)
            _UserAlert = [UIAlertController alertControllerWithTitle:notification.alertTitle message:notification.alertBody preferredStyle:UIAlertControllerStyleAlert];
            [_UserAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                [_UserAlert dismissViewControllerAnimated:YES completion:nil];
            }]];
            [LGFKeyWindow.rootViewController presentViewController:_UserAlert animated:YES completion:nil];
        }];
    } else {
        [CATransaction setCompletionBlock:^{
            _VisualSetAlert = [UIAlertController alertControllerWithTitle:notification.alertTitle message:notification.alertBody preferredStyle:UIAlertControllerStyleAlert];
            [_VisualSetAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                [_VisualSetAlert dismissViewControllerAnimated:YES completion:nil];
            }]];
            UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            alertWindow.rootViewController = [UIViewController new];
            alertWindow.windowLevel = UIWindowLevelAlert + 1;
            [alertWindow makeKeyAndVisible];
            [alertWindow.rootViewController presentViewController:_VisualSetAlert animated:YES completion:nil];
        }];
    }
}

//当通过点击推送进入或者回到App的时候触发
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    [self ShowMain];
    completionHandler();
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{

    NSLog(@"%@ %@",notification.request.content.userInfo[@"alerttype"],notification.request.content.body);
    if ([notification.request.content.userInfo[@"alerttype"]isEqualToString:@"alertinfo"]) {
        [CATransaction setCompletionBlock:^{
        
            //弹出alert框之前先dismiss
            [_UserAlert dismissViewControllerAnimated:YES completion:nil];    //在KeyWindow上弹出alert框(每个页面都能看到)
            _UserAlert = [UIAlertController alertControllerWithTitle:notification.request.content.title message:notification.request.content.body preferredStyle:UIAlertControllerStyleAlert];
            [_UserAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                [_UserAlert dismissViewControllerAnimated:YES completion:nil];
            }]];
            [LGFKeyWindow.rootViewController presentViewController:_UserAlert animated:YES completion:nil];
        }];
    } else {
        [CATransaction setCompletionBlock:^{
            _VisualSetAlert = [UIAlertController alertControllerWithTitle:notification.request.content.title message:notification.request.content.body preferredStyle:UIAlertControllerStyleAlert];
            [_VisualSetAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                [_VisualSetAlert dismissViewControllerAnimated:YES completion:nil];
            }]];
            UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            alertWindow.rootViewController = [UIViewController new];
            alertWindow.windowLevel = UIWindowLevelAlert + 1;
            [alertWindow makeKeyAndVisible];
            [alertWindow.rootViewController presentViewController:_VisualSetAlert animated:YES completion:nil];
        }];
    }
}

-(void)ShowLogin{
    
    self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
}

-(void)ShowMain{
    
    self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"MainView"];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //注册通知
    [self NotificationRegister:application];

    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [[UIScreen mainScreen] setBrightness:1.0f];
    [[UINavigationBar appearance] setTintColor:SystemColor(1.0)];
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    if ([[SystemUserDict valueForKey:@"logintype"] isEqualToString:@"1"]) {
        [self ShowMain];
    } else {
        [self ShowLogin];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preferredContentSizeChanged:) name:UIContentSizeCategoryDidChangeNotification object:nil];
    return YES;
}

-(void)NotificationRegister:(UIApplication *)application{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //iOS10特有
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        // 必须写代理，不然无法监听通知的接收与点击
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                // 点击允许
                NSLog(@"注册成功");
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                }];
            } else {
                // 点击不允许
                NSLog(@"注册失败");
            }
        }];
    }else if ([[UIDevice currentDevice].systemVersion floatValue] >8.0){
        //iOS8 - iOS10
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
    }else if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        //iOS8系统以下
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    }
    // 注册获得device Token
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)preferredContentSizeChanged:(NSNotification *)notification{
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    UIApplication* app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
    //永久后台无声音乐
    NSURL *url=[[NSBundle mainBundle]URLForResource:@"TestMusic" withExtension:@"m4a"];
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:Nil];
    [_player setVolume:0.0];
    [_player setNumberOfLoops:LONG_MAX];
    [_player play];
    [[AVAudioSession sharedInstance]setCategory: AVAudioSessionCategoryPlayback error: nil];
    [[AVAudioSession sharedInstance]setActive:YES error: nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
     [_player stop];
    [application setApplicationIconBadgeNumber:0];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
