//
//  UserLoginViewController.m
//  Calendar
//
//  Created by YingHong on 2014/7/25.
//
//

#import "UserLoginViewController.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "RegisterViewController.h"
#import "Post_Service.h"
#import "NIDropDown.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "NSString_Post.h"
#import "CKAppDelegate.h"
#import "toolBarControllerView.h"

@interface UserLoginViewController ()
{
    Post_Service *postService;
    
    toolBarControllerView * toolBarView;
    
    NSMutableArray * arrCity;
    NSMutableArray * arrCityArea;
    NSMutableArray * arrDistrict_id;
    
    NSString * ID ;
    NSString * cityName;
    NSString * cityId;
    NSString * cityAreaName;
    NSString * cityAreaId;
}
@end

@implementation UserLoginViewController
@synthesize idPostTextField;
@synthesize cityAreaBtn;
@synthesize cityBtn;
@synthesize idBtn;
@synthesize viewControllers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"登入界面";
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    
    arrCity = [[NSMutableArray alloc] init];
    arrCityArea = [[NSMutableArray alloc] init];
    
    [self selectedCity];
    
   
    // Do any additional setup after loading the view from its nib.
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![idPostTextField isExclusiveTouch])
    {
        [idPostTextField resignFirstResponder];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)NextPage:(NSString*)aResult
{
    if([aResult isEqualToString:@"驗證成功"])
    {
        NSMutableArray * view_controllers =
        [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        
        RegisterViewController * dateView = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
        
        NSString * _idcheck = [ID stringByAppendingString:idPostTextField.text ];
        
        dateView.ID = _idcheck;
        dateView.cityName = cityName;
        dateView.cityId = cityId;
        dateView.cityAreaName = cityAreaName;
        dateView.cityAreaId = cityAreaId;
        [view_controllers removeLastObject];
        [view_controllers addObject:dateView];
        
        [self.navigationController setViewControllers:[NSArray arrayWithArray:view_controllers]animated:YES];
    }

}
- (IBAction)callService:(id)sender
{
    
    postService = [[Post_Service alloc]init] ;
    postService.listener=self;
    
    NSString * _idcheck = [ID stringByAppendingString:idPostTextField.text ];
    
    NSLog(@"%@",_idcheck);
    
    NSMutableString *post = [NSMutableString stringWithFormat:@"user_id=%@",_idcheck];
    
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
        
        if([_Message isEqualToString:@"驗證成功"])
        {
            [weakSelf NextPage:@"驗證成功"];
        }
    };
    
   
    [postService SetNSDictionary:post SetURL:@"http://172.20.10.2/ClubCloud/userServer/Register/Register1.php"];

}

- (IBAction)idClicked:(id)sender
{
    NSArray * arr = [[NSArray alloc] init];
    arr = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"N", @"M", @"O", @"P", @"Q", @"R", @"S", @"T", @"U" , @"V", @"W", @"X", @"Y", @"Z",nil];
    NSArray * arrImage = [[NSArray alloc] init];
  //  arrImage = [NSArray arrayWithObjects:[UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], [UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], [UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], [UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], [UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], nil];
    //  NSLog(@"%@",dropDown);

    if(dropDown == nil)
    {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :arrImage :@"down"];
        dropDown.delegate = self;
        
    }
    else
    {
        [dropDown hideDropDown:sender];
        [self rel];

        // NSLog(@"%@",dropDown.)
    }
    arrImage = nil;
    arr = nil;

}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender getText:(NSString*)git_text getBt:(UIButton*)button
{
    //主控端
    if (button == cityBtn)
    {
        [self selectedCity:git_text];
        
        cityName = git_text;
        NSLog(@"%@",cityName);
        
        NSLog(@"test = %@",[NSString_Post getInstance].device_token);

        [self selectedCityArea:cityName];

        
    }
    else if(button == idBtn)
    {
        ID= git_text;
        
    }else if (button == cityAreaBtn)
    {
        cityAreaName = git_text;
        NSLog(@"cityAreaName = %@",cityAreaName);
        
        [self selectedCityAreaId:git_text];
    }
    

    
    [self rel];
}

-(void)rel{
    //    [dropDown release];
    
    dropDown = nil;
    
}

- (IBAction)cityAreaBtn:(id)sender
{
    NSArray * arrImage;
    
    if(dropDown == nil)
    {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arrCityArea :arrImage :@"down"];
        dropDown.delegate = self;
        
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
        
        // NSLog(@"%@",dropDown.)
    }
    arrImage = nil;
   // arrCityArea = nil;

    

}

- (IBAction)cityClicked:(id)sender
{
   
    NSArray * arrImage;

    if(dropDown == nil)
    {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arrCity :arrImage :@"down"];
        dropDown.delegate = self;

    }
    else {
        [dropDown hideDropDown:sender];
                [self rel];
        
        // NSLog(@"%@",dropDown.)
    }
    arrImage = nil;
 //   arrCity = nil;
    
    
}



-(void)selectedCity:(NSString*)city_id
{
    
    NSFileManager *fmdb = [NSFileManager defaultManager];
    
    NSString *documentspath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSString *db_path =[documentspath stringByAppendingPathComponent:@"City.db"];
    
    if ( ! [fmdb fileExistsAtPath:db_path] )
    {
        NSString *source_path = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"City.db"];
        
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
        NSString *de=[[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"city.db"];
        success=[fm copyItemAtPath:de toPath:writableDBPath error:nil];
        if (!success) {
            NSLog(@"error");
        }
    }
    FMDatabase *db=[FMDatabase databaseWithPath:writableDBPath];
    
    if([db open]){
        [db setShouldCacheStatements:YES];
        NSString * sqlQuery = [NSString stringWithFormat:@"SELECT city_id FROM city_table where territory_name ='%@'",city_id];
        FMResultSet *rs=[db executeQuery:sqlQuery];
    
        while ([rs next])
        {
            
            NSString *_cityId = [rs stringForColumn:@"city_id"];
            NSLog(@"%@",_cityId);
            
            
            cityId = _cityId;
            NSLog(@"city_id=%@",_cityId);

        }
        [db close];
        [rs close];
        
    }
    
    
    else{
        NSLog(@"無法開啓");
    }
    
}

-(void)selectedCityArea:(NSString*)city_Area
{
    
    NSLog(@"start");
    [arrCityArea removeAllObjects];
    
    NSFileManager *fmdb = [NSFileManager defaultManager];
    
    NSString *documentspath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSString *db_path =[documentspath stringByAppendingPathComponent:@"City.db"];
    
    if ( ! [fmdb fileExistsAtPath:db_path] )
    {
        NSString *source_path = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"City.db"];
        
        if ( [fmdb copyItemAtPath:source_path toPath:db_path error:nil] )
        {
            NSLog(@"ok");
        }
    }
    
    //陣列別理
    //[list removeAllObjects];
    //開啟fmdb
    NSMutableArray *_items=[NSMutableArray arrayWithCapacity:0];
    fm=[NSFileManager defaultManager];
    //    paths=NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    //    documentsDirectory=[paths objectAtIndex:0];
    NSString *documents_path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    writableDBPath=db_path;
    
    success=[fm fileExistsAtPath:writableDBPath];
    if (!success) {
        NSString *de=[[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"city.db"];
        success=[fm copyItemAtPath:de toPath:writableDBPath error:nil];
        if (!success) {
            NSLog(@"error");
        }
    }
    FMDatabase *db=[FMDatabase databaseWithPath:writableDBPath];
    NSLog(@"city_Area = %@",city_Area);
    if([db open]){
        [db setShouldCacheStatements:YES];
        
        NSString * sqlQuery = [NSString stringWithFormat:@"SELECT district_name FROM city_detail_table where territory_name = '%@' ",city_Area];
        
        FMResultSet *rs=[db executeQuery:sqlQuery];
        
        while ([rs next])
        {
            NSString *_cityList = [rs stringForColumn:@"district_name"];
            [arrCityArea addObject:_cityList];
            NSLog(@"%@",arrCityArea);
            
        }
        [db close];
        [rs close];
        
    }
    
    
    else
    {
        
        NSLog(@"無法開啓");
    }
    
   
}

-(void)selectedCityAreaId:(NSString*)city_AreaName
{
    [arrCityArea removeAllObjects];
    
    NSFileManager *fmdb = [NSFileManager defaultManager];
    
    NSString *documentspath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSString *db_path =[documentspath stringByAppendingPathComponent:@"City.db"];
    
    if ( ! [fmdb fileExistsAtPath:db_path] )
    {
        NSString *source_path = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"City.db"];
        
        if ( [fmdb copyItemAtPath:source_path toPath:db_path error:nil] )
        {
            NSLog(@"ok");
        }
    }
    
    //陣列別理
    //[list removeAllObjects];
    //開啟fmdb
    NSMutableArray *_items=[NSMutableArray arrayWithCapacity:0];
    fm=[NSFileManager defaultManager];
    //    paths=NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    //    documentsDirectory=[paths objectAtIndex:0];
    NSString *documents_path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    writableDBPath=db_path;
    
    success=[fm fileExistsAtPath:writableDBPath];
    if (!success) {
        NSString *de=[[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"city.db"];
        success=[fm copyItemAtPath:de toPath:writableDBPath error:nil];
        if (!success) {
            NSLog(@"error");
        }
    }
    FMDatabase *db=[FMDatabase databaseWithPath:writableDBPath];

    if([db open]){
        [db setShouldCacheStatements:YES];
        
        NSString * sqlQuery = [NSString stringWithFormat:@"SELECT district_id FROM city_detail_table where district_name = '%@' and territory_name = '%@' ",city_AreaName,cityName];
        
        FMResultSet *rs=[db executeQuery:sqlQuery];
        
        while ([rs next])
        {
            NSString *_cityAreaId = [rs stringForColumn:@"district_id"];
            NSLog(@"_cityAreaId = %@",_cityAreaId);
            
            cityAreaId = _cityAreaId;
            
        }
        [db close];
        [rs close];
        
    }
    
    
    else
    {
        
        NSLog(@"無法開啓");
    }
    
    
}

-(void)selectedCity
{
    
    NSFileManager *fmdb = [NSFileManager defaultManager];
    
    NSString *documentspath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSString *db_path =[documentspath stringByAppendingPathComponent:@"City.db"];
    
    if ( ! [fmdb fileExistsAtPath:db_path] )
    {
        NSString *source_path = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"City.db"];
        
        if ( [fmdb copyItemAtPath:source_path toPath:db_path error:nil] )
        {
            NSLog(@"ok");
        }
    }
    
    //陣列別理
    //[list removeAllObjects];
    //開啟fmdb
    NSMutableArray *_items=[NSMutableArray arrayWithCapacity:0];
    fm=[NSFileManager defaultManager];
    //    paths=NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    //    documentsDirectory=[paths objectAtIndex:0];
    NSString *documents_path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    writableDBPath=db_path;
    
    success=[fm fileExistsAtPath:writableDBPath];
    if (!success) {
        NSString *de=[[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"city.db"];
        success=[fm copyItemAtPath:de toPath:writableDBPath error:nil];
        if (!success) {
            NSLog(@"error");
        }
    }
    FMDatabase *db=[FMDatabase databaseWithPath:writableDBPath];
    
    if([db open]){
        [db setShouldCacheStatements:YES];
        FMResultSet *rs=[db executeQuery:@"SELECT * FROM city_table "];
        
        while ([rs next])
        {
            NSString *_cityList = [rs stringForColumn:@"territory_name"];
            [arrCity addObject:_cityList];
            
        }
        [db close];
        [rs close];
        
    }
    
    
    else{
        NSLog(@"無法開啓");
    }
    
    //[self.tabledata reloadData];
    
}

@end
