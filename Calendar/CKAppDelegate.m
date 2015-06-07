#import "CKAppDelegate.h"

#import "NewCKViewController.h"
#import "UserLoginViewController.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "PostCheckMessageViewController.h"
#import "NSString_Post.h"
#import "DatabaseMethod.h"
#import "InformationViewController.h"
#import "Post_Service.h"
#import "ReceiveMessageViewController.h"

@implementation CKAppDelegate
{
    NSString * _checkRegister;
    CLLocationManager* locationManager;
    Post_Service *postService;
}

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self dbSerch];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    
    //get device token
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
                    |UIRemoteNotificationTypeSound
                    |UIRemoteNotificationTypeAlert) categories:nil];
        [application registerUserNotificationSettings:settings];
          [[UIApplication sharedApplication] registerForRemoteNotifications];
        
        NSLog(@"1");
    } else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    if([_checkRegister isEqualToString:@"1"])
    {
        
        
        self.PCMView = [[InformationViewController alloc]init];
        
        
        UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:self.PCMView];
        
        nav.navigationBarHidden = YES;
        nav.toolbarHidden = YES;
        
        self.window.rootViewController = nav;
        [self.window makeKeyAndVisible];
        
        
    }else
    {
        self.viewController = [[UserLoginViewController alloc] init];
        
        
        UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:self.viewController];
        
        nav.navigationBarHidden = YES;
        nav.toolbarHidden = YES;
        
        self.window.rootViewController = nav;
        [self.window makeKeyAndVisible];
    }

    
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (userInfo) {
        //弹出一个alertview,显示相应信息
        
        NSLog(@"%@," ,userInfo);
        
        NSDictionary * ReceiveRN = [userInfo objectForKey:@"aps"];
        
        NSString * _data_id = [ReceiveRN objectForKey:@"data_id"];
        NSString * _detail = [ReceiveRN objectForKey:@"detail"];
        NSString * _image = [ReceiveRN objectForKey:@"image"];
        NSString * _time = [ReceiveRN objectForKey:@"time"];
        NSString * _time_detail = [ReceiveRN objectForKey:@"time_detail"];
        NSString * _title = [ReceiveRN objectForKey:@"title"];
        NSString * _type = [ReceiveRN objectForKey:@"type"];
        NSString * _check_img = [ReceiveRN objectForKey:@"check_img"];
        NSString * _city = [ReceiveRN objectForKey:@"city"];
        NSString * _area = [ReceiveRN objectForKey:@"area"];
        NSString * _address = [ReceiveRN objectForKey:@"address"];
        
        [self InsertSQL:_data_id Detail:_detail Image:_image Time:_time TimeDetail:_time_detail Title:_title Type:_type Cehck_img:_check_img City:_city Area:_area Address:_address];
        
        
//        UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:self.pushView];
//        
        self.window.rootViewController=Nil;
        
        ReceiveMessageViewController *reView=[[ReceiveMessageViewController alloc]init];
        //初始化导航控制器的时候把上面创建的root1初始化给它
        UINavigationController *nav1=[[UINavigationController alloc]initWithRootViewController:reView];
        //最后，我们把window的根视图控制器设为导航控制器，这样导航控制器就能够显示在屏幕上
        self.window.rootViewController=nav1;
         [self.window makeKeyAndVisible];
    }

   
    
    return YES;
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}



#endif

#pragma mark - Methods

- (void)customizeInterface {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    
    UIImage *backgroundImage = nil;
    NSDictionary *textAttributes = nil;
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        backgroundImage = [UIImage imageNamed:@"navigationbar_background_tall"];
        
        textAttributes = @{
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                           NSForegroundColorAttributeName: [UIColor blackColor],
                           };
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        backgroundImage = [UIImage imageNamed:@"navigationbar_background"];
        
        textAttributes = @{		
                           UITextAttributeFont: [UIFont boldSystemFontOfSize:18],
                           UITextAttributeTextColor: [UIColor blackColor],
                           UITextAttributeTextShadowColor: [UIColor clearColor],
                           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
                           };
#endif
    }
    
    [navigationBarAppearance setBackgroundImage:backgroundImage
                                  forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"??");
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
        if (application.applicationState == UIApplicationStateActive) {
            NSLog(@"active");
            //程序当前正处于前台
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
            if (userInfo) {
                //弹出一个alertview,显示相应信息
                NSLog(@"%@," ,userInfo);
                
                NSDictionary * ReceiveRN = [userInfo objectForKey:@"aps"];
                
                NSString * _data_id = [ReceiveRN objectForKey:@"data_id"];
                NSString * _detail = [ReceiveRN objectForKey:@"detail"];
                NSString * _image = [ReceiveRN objectForKey:@"image"];
                NSString * _time = [ReceiveRN objectForKey:@"time"];
                NSString * _time_detail = [ReceiveRN objectForKey:@"time_detail"];
                NSString * _title = [ReceiveRN objectForKey:@"title"];
                NSString * _type = [ReceiveRN objectForKey:@"type"];
                NSString * _check_img = [ReceiveRN objectForKey:@"check_img"];
                NSString * _city = [ReceiveRN objectForKey:@"city"];
                NSString * _area = [ReceiveRN objectForKey:@"area"];
                NSString * _address = [ReceiveRN objectForKey:@"address"];
                
                [self InsertSQL:_data_id Detail:_detail Image:_image Time:_time TimeDetail:_time_detail Title:_title Type:_type Cehck_img:_check_img City:_city Area:_area Address:_address];
            }
            
        }
        else if(application.applicationState == UIApplicationStateBackground)
        {
            NSLog(@"inactive");
            //程序处于后台
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
            
            
            if (userInfo) {
                //弹出一个alertview,显示相应信息
                NSLog(@"%@," ,userInfo);
                
                NSDictionary * ReceiveRN = [userInfo objectForKey:@"aps"];
                
                NSString * _data_id = [ReceiveRN objectForKey:@"data_id"];
                NSString * _detail = [ReceiveRN objectForKey:@"detail"];
                NSString * _image = [ReceiveRN objectForKey:@"image"];
                NSString * _time = [ReceiveRN objectForKey:@"time"];
                NSString * _time_detail = [ReceiveRN objectForKey:@"time_detail"];
                NSString * _title = [ReceiveRN objectForKey:@"title"];
                NSString * _type = [ReceiveRN objectForKey:@"type"];
                NSString * _check_img = [ReceiveRN objectForKey:@"check_img"];
                NSString * _city = [ReceiveRN objectForKey:@"city"];
                NSString * _area = [ReceiveRN objectForKey:@"area"];
                NSString * _address = [ReceiveRN objectForKey:@"address"];
                
                [self InsertSQL:_data_id Detail:_detail Image:_image Time:_time TimeDetail:_time_detail Title:_title Type:_type Cehck_img:_check_img City:_city Area:_area Address:_address];
                
            }
            
            completionHandler(UIBackgroundFetchResultNewData);
            locationManager = nil;
            
                
           // [self test]; //測試傳送後台
           // [self startStandardUpdates]; //開啓ＧＰＳ
        }  
    

}
- (void)startStandardUpdates
{
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    
    [locationManager startUpdatingLocation];
    
//    CLLocation *location = [locationManager location];
//    
//    
//    CLLocationCoordinate2D coordinate = [location coordinate];
//    
//    
//    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
//    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
//    
//    //NSLog(@”dLatitude : %@”, latitude);
//    //NSLog(@”dLongitude : %@”,longitude);
//    NSLog(@"MY HOME :%@", latitude);
//    NSLog(@"MY HOME: %@ ", longitude);

}
- (void)test
{
    postService = [[Post_Service alloc]init] ;
    postService.listener=self;
    
    NSMutableString *post = [NSMutableString stringWithFormat:@"id=%@&name=%@&username=%@&title=%@&detail=%@&date=%@&time=%@&city=%@&area=%@&liner=%@&address=%@&image=%@&city_id=%@&area_id=%@",@"1242134231",@"sdfsdf",@"fsdaf",@"sfas",@"sda",@"sfds",@"areaName",@"...",@"EventAddress.text",@"_check_img",@"cityId",@"cityAreaId"];
    //
    NSLog(@"%@",post);
    __weak typeof(self) weakSelf = self;
    
    postService.finishCallback = ^( Post_Service *aService )
    {
        
        NSString *dataString=aService.dataString;
        
        NSLog(@"dataString:%@",dataString);
        
        NSData *data=[dataString dataUsingEncoding:NSUTF8StringEncoding];
        
        
        NSDictionary *jsonObjects = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"jsonObjects:%@",jsonObjects);
        
        NSString*_result = [jsonObjects objectForKey:@"result"];
        NSString*_Message =[jsonObjects objectForKey:@"Message"];
        
        NSLog(@"Message=%@",_Message);
        NSLog(@"result:%@",_result);
        
        if([_Message isEqualToString:@"訊息新增成功！"])
        {
            
        }
    };
    
    
    [postService SetNSDictionary:post SetURL:@"http://172.20.10.2/ClubCloud/userServer/Request/Request.php"];
    
    
}

-(void)getGPS
{
    CLLocation *location = [locationManager location];
    
    
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    
    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    
        //NSLog(@”dLatitude : %@”, latitude);
        //NSLog(@”dLongitude : %@”,longitude);
    NSLog(@"MY HOME :%@", latitude);
    NSLog(@"MY HOME: %@ ", longitude);
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"update location err-\n%@", error);
}

// Delegate method from the CLLocationManagerDelegate protocol.

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    NSLog(@"%@",err);
}


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)_deviceToken
{
    NSString* adeviceToken = [[[[_deviceToken description]
                                stringByReplacingOccurrencesOfString: @"<" withString: @""]
                               stringByReplacingOccurrencesOfString: @">" withString: @""]
                              stringByReplacingOccurrencesOfString: @" " withString: @""];
    [NSString_Post getInstance].device_token = adeviceToken;

    NSLog(@"%@",adeviceToken);
    
    
    
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"LocalNotification" message:notification.alertBody delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
    NSDictionary* dic = [[NSDictionary alloc]init];
    //这里可以接受到本地通知中心发送的消息
    dic = notification.userInfo;
    NSLog(@"user info = %@",[dic objectForKey:@"key"]);
    
    // 图标上的数字减1
    application.applicationIconBadgeNumber -= 1;
    
}

//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
//{
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
//    
//  
//    if (userInfo) {
//        //弹出一个alertview,显示相应信息
//        NSLog(@"%@," ,userInfo);
//        
//        NSDictionary * ReceiveRN = [userInfo objectForKey:@"aps"];
//        
//        NSString * _data_id = [ReceiveRN objectForKey:@"data_id"];
//        NSString * _detail = [ReceiveRN objectForKey:@"detail"];
//        NSString * _image = [ReceiveRN objectForKey:@"image"];
//        NSString * _time = [ReceiveRN objectForKey:@"time"];
//        NSString * _time_detail = [ReceiveRN objectForKey:@"time_detail"];
//        NSString * _title = [ReceiveRN objectForKey:@"title"];
//        NSString * _type = [ReceiveRN objectForKey:@"type"];
//        NSString * _check_img = [ReceiveRN objectForKey:@"check_img"];
//        NSString * _city = [ReceiveRN objectForKey:@"city"];
//        NSString * _area = [ReceiveRN objectForKey:@"area"];
//        NSString * _address = [ReceiveRN objectForKey:@"address"];
//        
//        [self InsertSQL:_data_id Detail:_detail Image:_image Time:_time TimeDetail:_time_detail Title:_title Type:_type Cehck_img:_check_img City:_city Area:_area Address:_address];
//    }
//    
//    
//
//}

-(void)InsertSQL:(NSString *)_data_id Detail:(NSString*)_detail Image:(NSString*)_image Time:(NSString*)_time TimeDetail:(NSString*)_time_detail Title:(NSString*)_title Type:(NSString*)_type Cehck_img:(NSString*)_check_img City:(NSString*)_city Area:(NSString*)_area Address:(NSString*)_address
{
    NSFileManager *fmdb = [NSFileManager defaultManager];
    
    NSString *documentspath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSString *db_path =[documentspath stringByAppendingPathComponent:@"newRevicePost.db"];
    
    if ( ! [fmdb fileExistsAtPath:db_path] )
    {
        NSString *source_path = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"newRevicePost.db"];
        
        if ( [fmdb copyItemAtPath:source_path toPath:db_path error:nil] )
        {
            NSLog(@"ok");
        }
    }
    
    //開啟fmdb
    NSMutableArray *_items=[NSMutableArray arrayWithCapacity:0];
    fm=[NSFileManager defaultManager];
    //    paths=NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    //    documentsDirectory=[paths objectAtIndex:0];
    NSString *documents_path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    writableDBPath=db_path;
    
    success=[fm fileExistsAtPath:writableDBPath];
    if (!success) {
        NSString *de=[[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"newRevicePost.db"];
        success=[fm copyItemAtPath:de toPath:writableDBPath error:nil];
    }
    FMDatabase *db=[FMDatabase databaseWithPath:writableDBPath];
    
    if ([db open])
    {
        
        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",@"NewRDTable",@"data_id",@"title",@"detail",@"time",@"time_detail",@"image",@"type",@"check_img",@"city",@"area",@"address",_data_id,_title,_detail,_time,_time_detail,_image,_type,_check_img,_city,_area,_address];
        
        NSLog(@"%@",insertSql);
        BOOL res = [db executeUpdate:insertSql];
        
        if (!res)
        {
            NSLog(@"error when insert db table");
        } else
        {
            NSLog(@"success to insert db table");
        }
        [db close];
    }
    
}

-(void)dbSerch
{
    
    NSFileManager *fmdb = [NSFileManager defaultManager];
    
    NSString *documentspath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSString *db_path =[documentspath stringByAppendingPathComponent:@"checkRegiste.db"];
    
    if ( ! [fmdb fileExistsAtPath:db_path] )
    {
        NSString *source_path = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"checkRegiste.db"];
        
        if ( [fmdb copyItemAtPath:source_path toPath:db_path error:nil] )
        {
            NSLog(@"ok");
        }
    }
    
    //開啟fmdb
    NSMutableArray *_items=[NSMutableArray arrayWithCapacity:0];
    fm=[NSFileManager defaultManager];
    //    paths=NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    //    documentsDirectory=[paths objectAtIndex:0];
    NSString *documents_path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    writableDBPath=db_path;
    
    success=[fm fileExistsAtPath:writableDBPath];
    if (!success) {
        NSString *de=[[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"checkRegiste.db"];
        success=[fm copyItemAtPath:de toPath:writableDBPath error:nil];
    }
    FMDatabase *db=[FMDatabase databaseWithPath:writableDBPath];
    
    if([db open]){
        [db setShouldCacheStatements:YES];
        NSString * sqlQuery = [NSString stringWithFormat:@"SELECT * FROM '%@'",@"check"];
        FMResultSet *rs=[db executeQuery:sqlQuery];
        
        while ([rs next])
        {
            
            NSString *_chekc = [rs stringForColumn:@"check_register"];
            NSLog(@"%@",_chekc);
            
            
            _checkRegister = _chekc;
            NSLog(@"_chekc=%@",_chekc);
            
        }
        [db close];
        [rs close];
        
    }
    
    
    else{
        NSLog(@"無法開啓");
    }
    

}

@end