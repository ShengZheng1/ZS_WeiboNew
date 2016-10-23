//
//  AppDelegate.m
//  ZS_Weibo
//
//  Created by apple on 16/10/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "MMDrawerController.h"
#import "RightViewController.h"
#import "LeftViewController.h"
#import "BaseNavigationController.h"
@class MMDrawerController;

#define  kWeiboAuthDataKey @"kWeiboAuthDataKey"

@interface AppDelegate ()<SinaWeiboDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //创建window
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    //创建标签控制器
    MainTabBarController *tab = [[MainTabBarController alloc]init];
    
    //左边控制器
    LeftViewController *left = [[LeftViewController alloc]init];
    //右边控制器
    RightViewController *right = [[RightViewController alloc]init];
    //导航
    BaseNavigationController *leftNavi = [[BaseNavigationController alloc]initWithRootViewController:left];
    
    BaseNavigationController *rightNavi = [[BaseNavigationController alloc]initWithRootViewController:right];
    
    //创建MMDraw
    MMDrawerController *mmDraw = [[MMDrawerController alloc]initWithCenterViewController:tab leftDrawerViewController:leftNavi rightDrawerViewController:rightNavi];
    
    //设置侧滑宽度
    mmDraw.maximumLeftDrawerWidth = 180;
    mmDraw.maximumRightDrawerWidth = 80;
    
    //设置打开方式
    mmDraw.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    //设置关闭方式
    mmDraw.closeDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    
    //设置滑动动画的Block
    [mmDraw setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        UIViewController * sideDrawerViewController;
        //动画要执行的内容
        //每一次需要执行滑动动画时，到Manager中获取相应的block
        MMExampleDrawerVisualStateManager *manager = [MMExampleDrawerVisualStateManager sharedManager];
        //获取Block
        MMDrawerControllerDrawerVisualStateBlock block = [manager drawerVisualStateBlockForDrawerSide:drawerSide];
        //执行block
        if (block) {
            block(drawerController,drawerSide,percentVisible);
        }
       
    }];

    
    
    //设置根视图控制器
    self.window.rootViewController = mmDraw;
    
    //初始化微博SDK
    _sinaWeibo = [[SinaWeibo alloc]initWithAppKey:@"3391634869" appSecret:@"d274799ba2f765a8fc4137f13bde4ba3"
        appRedirectURI:@"http://www.baidu.com" andDelegate:self];
    
    //读取登录信息
    BOOL isAuth = [self readAuthData];
    //判读是否已登录
    if (isAuth == NO) {
        [self.sinaWeibo logIn];
        NSLog(@"从未登录过");
    }
    else{
        NSLog(@"已登录微博：%@",self.sinaWeibo.accessToken);
    }
    
    return YES;
}

#pragma mark - SinaWeiboDelegate
//登录成功
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    NSLog(@"登录成功:%@",sinaweibo.accessToken);
    [self saveOAuthData];
    
    NSLog(@"%@",NSHomeDirectory());
}
//注销微博
- (void)logOutWeibo{
    //登出微博
    [_sinaWeibo logOut];
}
//注销之后所调用
- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"注销成功");
    //删除登陆信息
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kWeiboAuthDataKey];
    
}
//登录失败
- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    NSLog(@"登录失败");
}

#pragma mark - 保持登录状态
//将登录后的数据，保存在本地磁盘。token ,uid
- (void)saveOAuthData
{
    //用户令牌 token
    NSString *token = _sinaWeibo.accessToken;
    //用户ID uid
    NSString *uid = _sinaWeibo.userID;
    //认证的有效期限
    NSDate *expirationDate = _sinaWeibo.expirationDate;
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = @{@"accessToken":token,@"uid":uid,@"expirationData":expirationDate};
    //将认证数据，保存到属性列表中
    [userDef setObject:dic forKey:kWeiboAuthDataKey];
    //数据同步
    [userDef synchronize];
}

//读取登录信息
- (BOOL)readAuthData{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    //读取数据
    NSDictionary *dic = [userDef objectForKey:kWeiboAuthDataKey];
    if (dic == nil) {
        return NO;
    }
    //获取保存的数据
    NSString *token = [dic objectForKey:@"accessToken"];
    NSString *uid = [dic objectForKey:@"uid"];
    NSDate *date = [dic objectForKey:@"expirationData"];
    //读取成功,使用保存过的数据
    if (token == nil || uid == nil || date == nil) {
        return NO;
    }
    //读取成功，使用保存过的数据
    _sinaWeibo.accessToken = token;
    _sinaWeibo.userID = uid;
    _sinaWeibo.expirationDate = date;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.zhengsheng.ZS_Weibo" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ZS_Weibo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ZS_Weibo.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
