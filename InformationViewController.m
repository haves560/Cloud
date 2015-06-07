//
//  InformationViewController.m
//  Calendar
//
//  Created by YingHong on 2014/10/15.
//
//

#import "InformationViewController.h"
#import "DatabaseMethod.h"
#import "Post_Service.h"
#import "RBCustomDatePickerView.h"
#import "toolBarControllerView.h"
#import "NewCKViewController.h"
#import "ReceiveMessageViewController.h"
#import "PostCheckMessageViewController.h"
#import "EmergencyTableViewController.h"
@interface InformationViewController ()
{
    UIImage *image;
    Post_Service *postService;
    toolBarControllerView *toolDelegate;
}

@end

@implementation InformationViewController
@synthesize user_lb;
@synthesize name_lb;
@synthesize phoneNnmbe_lb;
@synthesize city_lb;
@synthesize aera_lb;
@synthesize photo_img;
@synthesize _userStr;
@synthesize _nameStr;
@synthesize _PhoneNumberStr;
@synthesize _cityStr;
@synthesize _areaStr;
@synthesize scrollView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
    
    scrollView.contentSize = CGSizeMake(320, 600);
    scrollView.bounces = YES;

}
- (void)viewWillAppear:(BOOL)animated
{
     [super viewWillAppear:animated];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];//create instance of NSFileManager
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //create an array and store result of our search for the documents directory in it
    
    NSString *documentsDirectory = [paths objectAtIndex:0]; //create NSString object, that holds our exact path to the documents directory
    
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"imageName.png"]]; //add our image to the path
    
    photo_img.image = [UIImage imageWithContentsOfFile:fullPath];

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self selectdb];
    
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
        }else if (x == 1)
        {
            [weakSelf goToPostCheckMessageMethod];
        }else if (x ==5)
        {
            [weakSelf EmergencyNotificationViewControllerMethod];
        }
    };
    
    [self.view addSubview:toolDelegate];
    

    
    NSFileManager *fileManager = [NSFileManager defaultManager];//create instance of NSFileManager
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //create an array and store result of our search for the documents directory in it
    
    NSString *documentsDirectory = [paths objectAtIndex:0]; //create NSString object, that holds our exact path to the documents directory
    
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"imageName.png"]]; //add our image to the path
        photo_img.image = [UIImage imageWithContentsOfFile:fullPath];
    
    user_lb.text = _userStr;
    name_lb.text = _nameStr;
    phoneNnmbe_lb.text = _PhoneNumberStr;
    city_lb.text = _cityStr;
    aera_lb.text = _areaStr;
    
    // Do any additional setup after loading the view from its nib.
}

//toolMethod
-(void)goToCKView
{
    
    NSMutableArray * view_controllers =
    [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
    
    NewCKViewController * post = [[NewCKViewController alloc] initWithNibName:@"NewCKViewController" bundle:nil];
    
    [view_controllers removeLastObject];
    [view_controllers addObject:post];
    
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
-(void)goToPostCheckMessageMethod
{
    NSMutableArray * view_controllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
    PostCheckMessageViewController * postChek = [[PostCheckMessageViewController alloc] initWithNibName:@"PostCheckMessageViewController" bundle:nil];
    
    [view_controllers removeLastObject];
    [view_controllers addObject:postChek];
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
            _userStr = [rs stringForColumn:@"user"];
            _nameStr = [rs stringForColumn:@"name"];
            _PhoneNumberStr = [rs stringForColumn:@"cellPhone"];
            _cityStr = [rs stringForColumn:@"city"];
            _areaStr = [rs stringForColumn:@"area"];
        }
        [db close];
        [rs close];
        
    }
    
    
    else{
        NSLog(@"無法開啓");
    }
    
    
 
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)scanQRCode:(id)sender
{
    [self setupCamera];
}

- (IBAction)change_photo:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    //設定MediaType類型(不做此設定會自動忽略圖庫中的所有影片)
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
    imagePicker.mediaTypes = mediaTypes;
    
    //設定開啓圖庫的類型(預設圖庫/全部/新拍攝)
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    //以動畫方式顯示圖庫
    [self presentModalViewController:imagePicker animated:YES];

}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //取得使用的檔案格式
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]) {
        
        //取得圖片
        image  = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // Create path.
        NSData *imageData = UIImagePNGRepresentation(image); //convert image into .png format.
        
        NSFileManager *fileManager = [NSFileManager defaultManager];//create instance of NSFileManager
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //create an array and store result of our search for the documents directory in it
        
        NSString *documentsDirectory = [paths objectAtIndex:0]; //create NSString object, that holds our exact path to the documents directory
        
        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"imageName.png"]]; //add our image to the path
        
        [fileManager createFileAtPath:fullPath contents:imageData attributes:nil]; //finally save the path (image)
        [picker dismissModalViewControllerAnimated:YES];
    }else
    {
        [timer invalidate];
        _line.frame = CGRectMake(30, 10, 220, 2);
        num = 0;
        upOrdown = NO;
        [picker dismissViewControllerAnimated:YES completion:^{
            [picker removeFromParentViewController];
            UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
            //初始化
            ZBarReaderController * read = [ZBarReaderController new];
            //设置代理
            read.readerDelegate = self;
            CGImageRef cgImageRef = image.CGImage;
            ZBarSymbol * symbol = nil;
            id <NSFastEnumeration> results = [read scanImage:cgImageRef];
            for (symbol in results)
            {
                break;
            }
            NSString * result;
            if ([symbol.data canBeConvertedToEncoding:NSShiftJISStringEncoding])
                
            {
                result = [NSString stringWithCString:[symbol.data cStringUsingEncoding: NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
            }
            else
            {
                result = symbol.data;
            }
            
            [self QRCodeService:result];
            
            NSLog(@"%@",result);
            
        }];

    }

    //    if ([mediaType isEqualToString:@"public.movie"]) {
    //
    //        //取得影片位置
    //        videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
    //    }
    //
    
    //已動畫方式返回先前畫面

}
-(void)setupCamera
{
    if(IOS7)
    {
        [self scanBtnAction];
    }
}
-(void)scanBtnAction
{
    num = 0;
    upOrdown = NO;
    //初始话ZBar
    ZBarReaderViewController * reader = [ZBarReaderViewController new];
    //设置代理
    reader.readerDelegate = self;
    //支持界面旋转
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    reader.showsHelpOnFail = NO;
    reader.scanCrop = CGRectMake(0.1, 0.2, 0.8, 0.8);//扫描的感应框
    ZBarImageScanner * scanner = reader.scanner;
    [scanner setSymbology:ZBAR_I25
                   config:ZBAR_CFG_ENABLE
                       to:0];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
    view.backgroundColor = [UIColor clearColor];
    reader.cameraOverlayView = view;
    
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 40)];
    label.text = @"请将扫描的二维码至于下面的框内\n谢谢！";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.lineBreakMode = 0;
    label.numberOfLines = 2;
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    
    UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pick_bg.png"]];
    image.frame = CGRectMake(20, 80, 280, 280);
    [view addSubview:image];
    
    
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 220, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [image addSubview:_line];
    //定时器，设定时间过1.5秒，
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
    [self presentViewController:reader animated:YES completion:^{
        
    }];
}
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(30, 10+2*num, 220, 2);
        if (2*num == 260) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(30, 10+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [timer invalidate];
    _line.frame = CGRectMake(30, 10, 220, 2);
    num = 0;
    upOrdown = NO;
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
    }];
}
-(void)QRCodeService:(NSString*)result
{
    postService = [[Post_Service alloc]init] ;
    postService.listener=self;
    
    NSMutableString *post = [NSMutableString stringWithFormat:@"id=%@&username=%@",result,_userStr];
    
    NSLog(@"post = %@",post);
    __weak typeof(self) weakSelf = self;
    
    postService.finishCallback = ^( Post_Service *aService )
    {
        
        NSString *dataString=aService.dataString;
        
        NSLog(@"dataString:%@",dataString);
        
        NSData *data=[dataString dataUsingEncoding:NSUTF8StringEncoding];
        
        
        NSDictionary *jsonObjects = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"jsonObjects:%@",jsonObjects);
        

        NSString * _message = [jsonObjects objectForKey:@"Message"];
        NSString * _result = [jsonObjects objectForKey:@"result"];
        NSString * _name = [jsonObjects objectForKey:@"name"];
        NSString * _username = [jsonObjects objectForKey:@"username"];
        NSString * _data_id = [jsonObjects objectForKey:@"data_id"];
        NSString * _title = [jsonObjects objectForKey:@"title"];
        NSString * _detail = [jsonObjects objectForKey:@"detail"];
        NSString * _date = [jsonObjects objectForKey:@"date"];
        NSString * _time = [jsonObjects objectForKey:@"time"];
        NSString * _city = [jsonObjects objectForKey:@"city"];
        NSString * _area = [jsonObjects objectForKey:@"area"];
        NSString * _liner = [jsonObjects objectForKey:@"liner"];
        NSString * _address = [jsonObjects objectForKey:@"address"];
        NSString * _image = [jsonObjects objectForKey:@"image"];
        
        NSRange range = NSMakeRange(0, 7);
        
        NSString *_month = [_date substringWithRange:range];
       
       
        [weakSelf insertQRDB:_name Username:_username Data_id:_data_id Title:_title Detail:_detail Date:_date Time:_time City:_city Aera:_area Liner:_liner Address:_address Image:_image Month:_month] ;
        
        NSLog(@"message = %@",_message);
        NSLog(@"result = %@",_result);
        
    };
    
    
    [postService SetNSDictionary:post SetURL:@"http://172.20.10.2/ClubCloud/userServer/UserCategory/pushRollCall.php"];
    
}
- (IBAction)checkEvents:(id)sender
{
//    CGRect screenBound = [[UIScreen mainScreen] bounds];
//    CGSize screenSize = screenBound.size;
//    
//    CGFloat screenWidth = screenSize.width;
//    CGFloat screenHeight = screenSize.height;
//    
//    UIView * background  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
//    
//    background.backgroundColor = [UIColor grayColor];
//    background.alpha = 0.0;
//    [self.view addSubview:background];
//    
//    UIView * mianView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 300)];
//    
//
    
    
    
    RBCustomDatePickerView *pickerView = [[RBCustomDatePickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    

    [self.scrollView addSubview:pickerView];

}

-(void)insertQRDB:(NSString*)name Username:(NSString*)usernaem Data_id:(NSString*)data_id Title:(NSString*)title Detail:(NSString*)detail Date:(NSString*)date Time:(NSString*)time City:(NSString*)city Aera:(NSString*)area Liner:(NSString*)liner Address:(NSString*)adderss Image:(NSString*)_image Month:(NSString*)month
{
    NSFileManager *fmdb = [NSFileManager defaultManager];
    
    NSString *documentspath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSString *db_path =[documentspath stringByAppendingPathComponent:@"QR.db"];
    
    if ( ! [fmdb fileExistsAtPath:db_path] )
    {
        NSString *source_path = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"QR.db"];
        
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
        NSString *de=[[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"QR.db"];
        success=[fm copyItemAtPath:de toPath:writableDBPath error:nil];
    }
    FMDatabase *db=[FMDatabase databaseWithPath:writableDBPath];
    
    if ([db open])
    {
        
        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",@"QRdb",@"name",@"username",@"data_id",@"title",@"detail",@"date",@"time",@"city",@"area",@"liner",@"address",@"image",@"month",name,usernaem,data_id,title,detail,date,time,city,area,liner,adderss,_image,month];
        
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

@end
