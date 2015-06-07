//
//  PostCheckMessageViewController.m
//  Calendar
//
//  Created by YingHong on 2014/8/13.
//
//

#import "PostCheckMessageViewController.h"
#import "Post_Service.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "toolBarControllerView.h"
#import "NewCKViewController.h"
#import "ReceiveMessageViewController.h"
#import "NIDropDown.h"
#import "DatabaseMethod.h"
#import "EmergencyTableViewController.h"
#import "InformationViewController.h"

@interface PostCheckMessageViewController ()
{
    Post_Service *postService;
    UIAlertView *Alert_Success_fail ;
    toolBarControllerView *toolDelegate;
    
    
   NSMutableArray * arrCity;
   NSMutableArray * arrCityArea;
    
    NSString * cityName;
    NSString * areaName;
    NSString * RequestId;
    NSString * _nameStr;
    NSString * _usernameStr;
    NSString * _date;
    NSString * _time;
    NSString * _check_img;
    NSString * cityId;
    NSString * cityAreaId;
    
    UIView *backgroundView;
    UIView *datePikerView;
    
    UILabel * dateLb;
    
    UIImage *image;
}
@end

@implementation PostCheckMessageViewController
@synthesize dateAndTimeLb;
@synthesize EventAddress;
@synthesize cityBtn;
@synthesize areaBtn;
@synthesize Eventdetail;
@synthesize photoView;
@synthesize scrollView;
@synthesize EventTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)hideKeyboard
{
    [EventAddress resignFirstResponder];
    [Eventdetail resignFirstResponder];
    [EventTitle resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self selectdb];
    
    _check_img = @"0";
    
    scrollView.contentSize = CGSizeMake(320, 800);
    scrollView.bounces = YES;
    //toolBar init
    toolDelegate = [[toolBarControllerView alloc] initWithFrame:CGRectMake(0, 500, 320, 60)];
    
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background_2"]];
    toolDelegate.backgroundColor =background;
    __weak __typeof(self)weakSelf = self;
    toolDelegate.returmNumber = ^(int x)
    {
        NSLog(@"%d",x);
        if(x == 2)
        {
            [weakSelf goToCKView];
        }
        else if (x == 3)
        {
            [weakSelf goToReceiveMessageViewcontrollerMehod];
        }else if (x ==5)
        {
            [weakSelf EmergencyNotificationViewControllerMethod];
        }else if (x ==4)
        {
            [weakSelf InformationViewControllerMethod];
        }
    };
    
    [self.view addSubview:toolDelegate];
    //button init
    
    arrCity = [[NSMutableArray alloc] init];
    arrCityArea = [[NSMutableArray alloc] init];
  
    [self selectedCity];
    //收鍵盤
    UIToolbar *doneToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    doneToolbar.barStyle = UIBarStyleBlackTranslucent;
    
    doneToolbar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(hideKeyboard)],
                         nil];
    
    [doneToolbar sizeToFit];
    
     EventAddress.inputAccessoryView = doneToolbar;
     Eventdetail.inputAccessoryView = doneToolbar;
     EventTitle.inputAccessoryView = doneToolbar;
    
    EventAddress.text = @"臺大體育館";
    Eventdetail.text = @"今晚有團康活動歡迎參加";
    EventTitle.text = @"團康活動";
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)OptPut:(id)sender
{
    postService = [[Post_Service alloc]init] ;
    postService.listener=self;
    
    NSMutableString *post = [NSMutableString stringWithFormat:@"id=%@&name=%@&username=%@&title=%@&detail=%@&date=%@&time=%@&city=%@&area=%@&liner=%@&address=%@&image=%@&city_id=%@&area_id=%@",RequestId,_nameStr,_usernameStr,EventTitle.text,Eventdetail.text,_date,_time,cityName,areaName,@"...",EventAddress.text,_check_img,cityId,cityAreaId];
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
              [self uploadPhotos];
        }
    };
    
    
    [postService SetNSDictionary:post SetURL:@"http://172.20.10.2/ClubCloud/userServer/Request/Request.php"];
    UIAlertView * al = [[UIAlertView alloc]initWithTitle:@"訊息" message:@"已上傳成功！" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [al show];

   
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender getText:(NSString*)git_text getBt:(UIButton*)button
{
    //主控端
    if (button == cityBtn)
    {
        
        cityName = git_text;
        NSLog(@"%@",cityName);
        
        [self selectedCityArea:cityName];
    
    }else if (button == areaBtn)
    {
        areaName = git_text;
        NSLog(@"cityAreaName = %@",areaName);
        
    }
    
    
    
    [self rel];
}

-(void)rel{
    //    [dropDown release];
    
    dropDown = nil;
    
}

-(void)uploadPhotos
{
    //上傳圖片
    NSDictionary *dic =@{@"file":@"test",@"name":@"test"};
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObject:@"text/html"];
    
    CGSize imageSize  = CGSizeMake(640,960);
    UIImage * newimg = [self scaleFromImage:image toSize:imageSize];
    
    [manager POST:@"http://172.20.10.2/ClubCloud/userServer/Request/Request_upload.php" parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImagePNGRepresentation(newimg)name:@"file"fileName:[NSString stringWithFormat:@"%@.png",RequestId] mimeType:@"image/png"];
        
    }success:^(AFHTTPRequestOperation *operation,id responseObject) {
        NSLog(@"success");
        
    }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        NSLog(@"error= %@",error);
        
    }];
}
-(void)selectedCity
{
    [arrCity removeAllObjects];
    
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

- (void)goToCKView
{
    NSMutableArray * view_controllers =
    [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
    
    NewCKViewController * post = [[NewCKViewController alloc] initWithNibName:@"NewCKViewController" bundle:nil];
    [view_controllers removeLastObject];

    [view_controllers addObject:post];
      NSLog(@"%@",view_controllers);
    [self.navigationController setViewControllers:[NSArray arrayWithArray:view_controllers]animated:YES];
    
}
-(void)InformationViewControllerMethod
{
    NSMutableArray * view_controllers =
    [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
    
    InformationViewController * information = [[InformationViewController alloc] initWithNibName:@"InformationViewController" bundle:nil];
    [view_controllers removeLastObject];
    
    [view_controllers addObject:information];
      NSLog(@"%@",view_controllers);
    [self.navigationController setViewControllers:[NSArray arrayWithArray:view_controllers]animated:YES];
}
-(void)goToReceiveMessageViewcontrollerMehod
{
    NSMutableArray * view_controllers =
    [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
    ReceiveMessageViewController * recevie = [[ReceiveMessageViewController alloc] initWithNibName:@"ReceiveMessageViewController" bundle:nil];
    [view_controllers removeLastObject];

    [view_controllers addObject:recevie];
      NSLog(@"%@",view_controllers);
    [self.navigationController setViewControllers:[NSArray arrayWithArray:view_controllers]animated:YES];
}
-(void)EmergencyNotificationViewControllerMethod
{
    NSMutableArray * view_controllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
    EmergencyTableViewController * emergency = [[EmergencyTableViewController alloc] initWithNibName:@"EmergencyTableViewController" bundle:nil];
    
    [view_controllers removeLastObject];
    [view_controllers addObject:emergency];
      NSLog(@"%@",view_controllers);
    [self.navigationController setViewControllers:[NSArray arrayWithArray:view_controllers]animated:YES];
    
}


    
- (IBAction)selectAlbum:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    //設定MediaType類型(不做此設定會自動忽略圖庫中的所有影片)
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
    imagePicker.mediaTypes = mediaTypes;
    
    //設定開啓圖庫的類型(預設圖庫/全部/新拍攝)
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    _check_img = @"1";
    
    //以動畫方式顯示圖庫
    [self presentModalViewController:imagePicker animated:YES];

}
-(UIImage *) scaleFromImage: (UIImage *) _image toSize: (CGSize) size
{
    //縮放圖片 method
    UIGraphicsBeginImageContext(size);
    [_image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //取得使用的檔案格式
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]) {
        
        //取得圖片
        image  = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        [photoView setImage:image];
        
        // Create path.
//        NSData *imageData = UIImagePNGRepresentation(image); //convert image into .png format.
//        
//        NSFileManager *fileManager = [NSFileManager defaultManager];//create instance of NSFileManager
//        
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //create an array and store result of our search for the documents directory in it
//        
//        NSString *documentsDirectory = [paths objectAtIndex:0]; //create NSString object, that holds our exact path to the documents directory
//        
//        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"imageName1.png"]]; //add our image to the path
//        
//        [fileManager createFileAtPath:fullPath contents:imageData attributes:nil]; //finally save the path (image)
//        
//        
    }
    
    //    if ([mediaType isEqualToString:@"public.movie"]) {
    //
    //        //取得影片位置
    //        videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
    //    }
    //
   
  
    //已動畫方式返回先前畫面
    [picker dismissModalViewControllerAnimated:YES];
}


- (IBAction)selectCity:(id)sender
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
    // arrCityArea = nil;
    

}

- (IBAction)selectArea:(id)sender
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

- (IBAction)DateAndTime:(id)sender
{
    CGRect frame =CGRectMake(0, 0, 320, 480);//获取窗口大小
    backgroundView = [[UIView alloc] initWithFrame:frame];//实例一个UIView
    backgroundView.backgroundColor = [UIColor blackColor];//设置其背景色为黑色
    backgroundView.alpha = 0.7;//设置其透明为0.7
    
    [self.view addSubview:backgroundView];
    
    datePikerView = [[UIView alloc] init];
    
    datePikerView.frame = CGRectMake(10, 40, 300, 400);
    datePikerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:datePikerView];
    
    UIDatePicker * datePicker = [[UIDatePicker alloc] init];
    
    datePicker.frame = CGRectMake(0,0,300,400);
   
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    
    [datePicker addTarget:self action:@selector(getDateAndTime:) forControlEvents:UIControlEventValueChanged];
    
    dateLb = [[UILabel alloc] init];
    dateLb.frame  = CGRectMake(20, 260, 300, 40);
    
    [datePikerView addSubview:dateLb];

    
    UIButton * closeBt = [[UIButton alloc] init];
    closeBt.frame = CGRectMake(100, 320, 100, 100);
    [closeBt setTitle:@"確定" forState:UIControlStateNormal];
    [closeBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
   // closeBt.backgroundColor = [UIColor redColor];
    [closeBt addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [datePikerView addSubview:closeBt];
    
    [datePikerView addSubview:datePicker];

}
-(void)getDateAndTime:(UIDatePicker*)datePicker
{
    
    NSDate *date = datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString *dateString = [formatter stringFromDate:date];
    
    NSRange range = NSMakeRange(0, 10);
    
    _date = [dateString substringWithRange:range];
    
    
    NSRange range_time = NSMakeRange(11, 5);
    
    _time = [dateString substringWithRange:range_time];
    
    NSLog(@"%@",_time);
    
    dateAndTimeLb.text = dateString;
    dateLb.text = dateString;
    
    NSDateFormatter *formatter_str = [[NSDateFormatter alloc] init];
    [formatter_str setDateFormat:@"yyyyMMddHHmmss"];
    RequestId = [formatter_str stringFromDate:date];

  
}
-(void)closeView
{
    [backgroundView removeFromSuperview];
    [datePikerView removeFromSuperview];
}
//register db
-(void)selectdb
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
            _nameStr = [rs stringForColumn:@"user"];
            _usernameStr = [rs stringForColumn:@"name"];
            cityId = [rs stringForColumn:@"cityID"];
            cityAreaId = [rs stringForColumn:@"areaID"];
        }
        [db close];
        [rs close];
        
    }
    
    
    else{
        NSLog(@"無法開啓");
    }
    
    
    
}

@end
