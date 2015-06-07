//
//  RegisterViewController.m
//  Calendar
//
//  Created by YingHong on 2014/7/26.
//
//

#import "RegisterViewController.h"
#import "NSString_Post.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "Post_Service.h"
#import "DatabaseMethod.h"
#import "PostCheckMessageViewController.h"
#import "InformationViewController.h"

@interface RegisterViewController ()
{
    Post_Service *postService;
    UIImage  * image;
    
    NSString * _time;
}

@end

@implementation RegisterViewController

@synthesize ID;
@synthesize cityName;
@synthesize cityId;
@synthesize cityAreaName;
@synthesize cityAreaId;
@synthesize AlbumImage;
@synthesize nameTextField;
@synthesize userNameTextField;
@synthesize passWordTextField;
@synthesize userCellPhoneTextField;
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
    
    NSLog(@"%@dd",[NSString_Post getInstance].device_token);
    
    NSLog(@"2=%@",ID);
    NSLog(@"%@",cityName);
    NSLog(@"%@",cityId);
    NSLog(@"%@",cityAreaId);
    NSLog(@"%@",cityAreaName);
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
    _time= [dateFormatter stringFromDate:now];

    NSLog(@"_time %@",_time);
    
    // NSLog(@"%@",[city objectForKey:@"cityName"]);

    // Do any additional setup after loading the view from its nib.
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![nameTextField isExclusiveTouch]&![passWordTextField isExclusiveTouch]&!
        [userNameTextField isExclusiveTouch])
    {
        [nameTextField resignFirstResponder];
        [passWordTextField resignFirstResponder];
        [userNameTextField resignFirstResponder];
    }
}


- (IBAction)openPicker:(id)sender
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
        
        [AlbumImage setImage:image];
        
        // Create path.
        NSData *imageData = UIImagePNGRepresentation(image); //convert image into .png format.
        
        NSFileManager *fileManager = [NSFileManager defaultManager];//create instance of NSFileManager
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //create an array and store result of our search for the documents directory in it
        
        NSString *documentsDirectory = [paths objectAtIndex:0]; //create NSString object, that holds our exact path to the documents directory
        
        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"imageName.png"]]; //add our image to the path
        
        [fileManager createFileAtPath:fullPath contents:imageData attributes:nil]; //finally save the path (image)

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

-(void)uploadPhotos
{
    //UIImage *image = [UIImage imageNamed:@"first_normal.png"];
    NSDictionary *dic =@{@"file":@"test",@"name":@"test"};
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObject:@"text/html"];
    [manager POST:@"http://172.20.10.2/ClubCloud/userServer/Register/User_upload.php"
       parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImagePNGRepresentation(image)name:@"file"fileName:@"first_normal.png" mimeType:@"image/png"];
        
    }success:^(AFHTTPRequestOperation *operation,id responseObject) {
        NSLog(@"success");
        
    }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        NSLog(@"error");
        
    }];
}

-(void)NextPage:(NSString*)aStr
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
        if (!success) {
            NSLog(@"error");
        }
    }
    FMDatabase *db=[FMDatabase databaseWithPath:writableDBPath];
    
    if([db open]){
        [db setShouldCacheStatements:YES];
        NSString * updateSql = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@','%@','%@','%@','%@','%@','%@','%@')VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@')" ,@"check",@"check_register",@"user",@"name",@"cellPhone",@"city",@"area",@"areaID",@"cityID",@"ID",aStr,userNameTextField.text,nameTextField.text,userCellPhoneTextField.text,cityName,cityAreaName,cityAreaId,cityId,ID];
        
        BOOL res = [db executeUpdate:updateSql];
        
        if (!res)
        {
            NSLog(@"error when updateSql db table");
        } else
        {
            NSLog(@"success to updateSql db table");
            
        }
        [db close];
        
        [self pushView];
    }
    
    else{
        NSLog(@"無法開啓");
    }

}

- (void)pushView
{
    NSMutableArray * view_controllers =
    [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
    InformationViewController * dateView = [[InformationViewController alloc] initWithNibName:@"InformationViewController" bundle:nil];
    [view_controllers removeLastObject];
    [view_controllers addObject:dateView];
  
    [self.navigationController setViewControllers:[NSArray arrayWithArray:view_controllers]animated:YES];
    
}
- (IBAction)postRegister2:(id)sender
{
    postService = [[Post_Service alloc]init] ;
    postService.listener=self;
    
    NSMutableString *post = [NSMutableString stringWithFormat:@"name=%@&username=%@&password=%@&user_id=%@&device_token=%@&device_os=%@&user_city=%@&user_city_detail=%@&city_id=%@&city_detail_id=%@&cellphone=%@&send_time=%@",nameTextField.text,userNameTextField.text,passWordTextField.text,ID,[NSString_Post getInstance].device_token,@"ios",cityName,cityAreaName,cityId,cityAreaId,userCellPhoneTextField.text,_time];
    
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
        
        if([_Message isEqualToString:@"新增會員成功！"])
        {
            [weakSelf NextPage:@"1"];
        }
    };
    
    
    [postService SetNSDictionary:post SetURL:@"http://172.20.10.2/ClubCloud/userServer/Register/Register2.php"];
    
    [self uploadPhotos];
    
    
}
@end
