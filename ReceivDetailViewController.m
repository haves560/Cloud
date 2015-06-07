//
//  ReceivDetailViewController.m
//  Calendar
//
//  Created by YingHong on 2014/10/13.
//
//

#import "ReceivDetailViewController.h"
#import "DatabaseMethod.h"
#import <FacebookSDK/FacebookSDK.h>

@interface ReceivDetailViewController ()

@end

@implementation ReceivDetailViewController
@synthesize timeStr;
@synthesize titleStr;
@synthesize addressStr;
@synthesize propagandaStr;
@synthesize time_lb;
@synthesize title_lb;
@synthesize address_lb;
@synthesize propaganda_img;
@synthesize detailLb;
@synthesize propagandaImgUrl;
@synthesize _type;
@synthesize _time;
@synthesize _created_date;
@synthesize _check_img;
@synthesize _image;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    title_lb.text = titleStr;
    time_lb.text = timeStr;
    address_lb.text = addressStr;
    
    [self UpdateSQL];
    
//    NSFileManager *fileManager = [NSFileManager defaultManager];//create instance of NSFileManager
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //create an array and store result of our search for the documents directory in it
//    
//    NSString *documentsDirectory = [paths objectAtIndex:0]; //create NSString object, that holds our exact path to the documents directory
//    
//    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"imageName.png"]]; //add our image to the path
//    propaganda_img.image = [UIImage imageWithContentsOfFile:fullPath];
    
       detailLb.text = propagandaStr;
//    
    NSURL *imageURL = [NSURL URLWithString:propagandaImgUrl];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    
    propaganda_img.image = image;
    

    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addToCalendar:(id)sender
{
    NSFileManager *fmdb = [NSFileManager defaultManager];
    
    NSString *documentspath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSString *db_path =[documentspath stringByAppendingPathComponent:@"newCK.db"];
    
    if ( ! [fmdb fileExistsAtPath:db_path] )
    {
        NSString *source_path = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"newCK.db"];
        
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
        NSString *de=[[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"newCK.db"];
        success=[fm copyItemAtPath:de toPath:writableDBPath error:nil];
    }
    FMDatabase *db=[FMDatabase databaseWithPath:writableDBPath];
    
    if ([db open])
    {
        
        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@','%@','%@','%@','%@','%@','%@','%@')VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@')",@"Scheduling",@"title",@"message",@"check_img",@"created_date",@"time",@"image",@"URL",@"address",@"type",titleStr,propagandaStr,_check_img,_created_date,_time,_image,propagandaImgUrl,addressStr,_type];
        
        NSLog(@"%@",insertSql);
        BOOL res = [db executeUpdate:insertSql];
        
        if (!res)
        {
            NSLog(@"error when insert db table");
        } else
        {
            NSLog(@"success to insert db table");
            
            UIAlertView * al = [[UIAlertView alloc]initWithTitle:@"訊息" message:@"已新增至行事曆" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [al show];
        }
        [db close];
    }

}

- (IBAction)FbShare:(id)sender
{
    
    FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
    params.link = [NSURL URLWithString:@"https://developers.facebook.com/docs/ios/share/"];
    params.name = @"Sharing Tutorial";
    params.caption = @"Build great social apps and get more installs.";
    params.picture = [NSURL URLWithString:@"http://i.imgur.com/g3Qc1HN.png"];

    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        // Present the share dialog
        [FBDialogs presentShareDialogWithLink:params.link
                                         name:params.name
                                      caption:params.caption
                                  description:params.description
                                      picture:params.picture
                                  clientState:nil
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              // An error occurred, we need to handle the error
                                              // See:https://developers.facebook.com/docs/ios/errors
                                              NSLog([NSString stringWithFormat:@"Error publishing story: %@", error.description]);
                                          } else {
                                              // Success
                                              NSLog(@"result %@", results);
                                          }
                                      }];
    } else {
        // Present the feed dialog
        
    }
    
    
    UIAlertView * al = [[UIAlertView alloc]initWithTitle:@"訊息" message:@"已成功分享" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [al show];
    

    
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL urlWasHandled = [FBAppCall handleOpenURL:url
                                sourceApplication:sourceApplication
                                  fallbackHandler:^(FBAppCall *call) {
                                      NSLog(@"Unhandled deep link: %@", url);
                                      // Here goes the code to handle the links
                                      // Use the links to show a relevant view of your app to the user
                                  }];
    
    return urlWasHandled;
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
        NSString *de=[[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"newRevicePost.db"];
        success=[fm copyItemAtPath:de toPath:writableDBPath error:nil];
        if (!success) {
            NSLog(@"error");
        }
    }
    FMDatabase *db=[FMDatabase databaseWithPath:writableDBPath];
    
    
    if ([db open])
    {
        
        // NSString *updateSql = [NSString stringWithFormat:@"UPDATE Scheduling set (title = '%@',message = '%@',check_img ='%@') WHERE ('%@','%@','%@')",titleEditor.text,textEditor.text,@"1",titleEditor.text,textEditor.text,@"1"];
        
        NSString *updateSql = [NSString stringWithFormat:@"UPDATE NewRDTable set check_img ='%@' WHERE title='%@' ",@"1",titleStr];
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



- (IBAction)back:(id)sender
{
        [self.navigationController popViewControllerAnimated:YES];
}
@end
