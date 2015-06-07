//
//  EmergencyNotificationViewController.m
//  Calendar
//
//  Created by YingHong on 2014/10/24.
//
//

#import "EmergencyNotificationViewController.h"
#import "Post_Service.h"
#import "DatabaseMethod.h"

@interface EmergencyNotificationViewController ()
{
    NSString * _ID;
    
  
    
    CLLocationManager* locationManager;

    Post_Service *postService;
}
@end

@implementation EmergencyNotificationViewController
@synthesize detailLb;
@synthesize dateLb;
@synthesize titleLb;
@synthesize _data_id;
@synthesize _username;
@synthesize _detail;
@synthesize _time_detail;
@synthesize _time;
@synthesize _type;
@synthesize _Title;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//
    [self UpdateSQL];
    [self startStandardUpdates];
       
    titleLb.text = _Title;
    NSString * _nowTime = [NSString stringWithFormat:@"%@ %@",_time,_time_detail];
    dateLb.text = _nowTime;
    detailLb.text = _detail;
    // Do any additional setup after loading the view from its nib.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)UpdateSQL
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
        
        // NSString *updateSql = [NSString stringWithFormat:@"UPDATE Scheduling set (title = '%@',message = '%@',check_img ='%@') WHERE ('%@','%@','%@')",titleEditor.text,textEditor.text,@"1",titleEditor.text,textEditor.text,@"1"];
        
        NSString *updateSql = [NSString stringWithFormat:@"UPDATE NewRDTable set check_img ='%@' WHERE title='%@' ",@"1",_Title];
        NSLog(@"HERE%@",updateSql);
        
        BOOL res = [db executeUpdate:updateSql];
        
        if (!res)
        {
            NSLog(@"error when updateSql db table");
        } else
        {
            NSLog(@"success to updateSql db table");
        }
        [db close];
        // fileManager = nil;
    }
    
}

- (IBAction)Return:(id)sender
{
    [self startStandardUpdates];
    
    CLLocation *location = [locationManager location];
    
    
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    
    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    
    //NSLog(@”dLatitude : %@”, latitude);
    //NSLog(@”dLongitude : %@”,longitude);
    NSLog(@"MY HOME :%@", latitude);
    NSLog(@"MY HOME: %@ ", longitude);
    
    postService = [[Post_Service alloc]init] ;
    postService.listener=self;
    
    NSMutableString *post = [NSMutableString stringWithFormat:@"id=%@&username=%@&latitude=%@&longitude=%@&user_status=%@",_data_id,_username,latitude,longitude,@"2"];
    //
    NSLog(@"post = %@",post);
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
    
    
    [postService SetNSDictionary:post SetURL:@"http://172.20.10.2/ClubCloud/userServer/Response/update_data.php"];
    
    UIAlertView * al = [[UIAlertView alloc]initWithTitle:@"訊息" message:@"已成功回報" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [al show];

    
}

- (IBAction)Help:(id)sender
{
    
    [self startStandardUpdates];
    
    CLLocation *location = [locationManager location];
    
    
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    
    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    
    //NSLog(@”dLatitude : %@”, latitude);
    //NSLog(@”dLongitude : %@”,longitude);
    NSLog(@"MY HOME :%@", latitude);
    NSLog(@"MY HOME: %@ ", longitude);
    
    postService = [[Post_Service alloc]init] ;
    postService.listener=self;
    
    NSMutableString *post = [NSMutableString stringWithFormat:@"id=%@&username=%@&latitude=%@&longitude=%@&user_status=%@",_data_id,_username,latitude,longitude,@"3"];
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
    
    
    [postService SetNSDictionary:post SetURL:@"http://172.20.10.2/ClubCloud/userServer/Response/update_data.php"];
    
    
    UIAlertView * al = [[UIAlertView alloc]initWithTitle:@"訊息" message:@"已成功救援請在原地稍後！" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [al show];


    
}

- (void)startStandardUpdates
{
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    
    [locationManager startUpdatingLocation];
    
    
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"update location err-\n%@", error);
}


- (IBAction)backMethod:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
