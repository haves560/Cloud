//
//  AddSchedulingViewController.m
//  Calendar
//
//  Created by YingHong on 2014/7/8.
//
//

#import "AddSchedulingViewController.h"
#import "UpdateCalendarViewController.h"
#import "DateDetailsViewController.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabase.h"

@interface AddSchedulingViewController ()

@end

@implementation AddSchedulingViewController
@synthesize dateLabel;
//@synthesize dateStr;
@synthesize ScrollView;
@synthesize titleStr;
@synthesize titleLabel;
@synthesize timeLabel;
@synthesize detailLabel;
@synthesize addressLabel;
@synthesize photoImageView;
@synthesize _image;
@synthesize _time;
@synthesize _date;
@synthesize propagandaImgUrl;
@synthesize propagandaStr;
@synthesize addressStr;

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
    
  //  [self createDatabaseAndTablesIfNeeded];
    
    dateLabel.text = _date;
    timeLabel.text = _time;
    titleLabel.text = titleStr;
    addressLabel.text = addressStr;
    detailLabel.text = propagandaStr;
    
    NSURL *imageURL = [NSURL URLWithString:propagandaImgUrl];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    
    photoImageView.image = image;

    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];

    [self UpdateSQL];
    
    
      // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
    
    ScrollView.contentSize = CGSizeMake(320, 600);
    ScrollView.bounces = YES;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    if (![titleEditor isExclusiveTouch]&![textEditor isExclusiveTouch])
//    {
//        [titleEditor resignFirstResponder];
////        [textEditor resignFirstResponder];
//    }
}
-(void)UpdateSQL
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
        NSString *de=[[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"newCK.db"];
        success=[fm copyItemAtPath:de toPath:writableDBPath error:nil];
        if (!success) {
            NSLog(@"error");
        }
    }
    FMDatabase *db=[FMDatabase databaseWithPath:writableDBPath];
    
    
    if ([db open])
    {
        
       // NSString *updateSql = [NSString stringWithFormat:@"UPDATE Scheduling set (title = '%@',message = '%@',check_img ='%@') WHERE ('%@','%@','%@')",titleEditor.text,textEditor.text,@"1",titleEditor.text,textEditor.text,@"1"];
        
        NSString *updateSql = [NSString stringWithFormat:@"UPDATE Scheduling set check_img ='%@' WHERE title='%@' ",@"1",titleStr];
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

- (IBAction)sqlDelete:(id)sender
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
        NSString *de=[[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"newCK.db"];
        success=[fm copyItemAtPath:de toPath:writableDBPath error:nil];
        if (!success) {
            NSLog(@"error");
        }
    }
    FMDatabase *db=[FMDatabase databaseWithPath:writableDBPath];    if ([db open])
    {
        
        NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM '%@' where title = '%@'",@"Scheduling",titleStr];
        NSLog(@"%@",deleteSql);
        BOOL res = [db executeUpdate:deleteSql];
        
        if (!res)
        {
            NSLog(@"error when delete db table");
        } else
        {
            NSLog(@"success to delete db table");
        }
        [db close];
    }
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)updateCk:(id)sender
{
    
    
    NSMutableArray * view_controllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
    UpdateCalendarViewController * dateView = [[UpdateCalendarViewController alloc] initWithNibName:@"UpdateCalendarViewController" bundle:nil];
    
    [view_controllers removeLastObject];
    [view_controllers addObject:dateView];
    
    dateView._Title = titleLabel.text;
    dateView._detail = detailLabel.text;
    dateView._address = addressLabel.text;
    dateView._time = _time;
    dateView._date = _date;
    
    NSLog(@"%@",view_controllers);
    
    [self.navigationController setViewControllers:[NSArray arrayWithArray:view_controllers]animated:YES];
    
}
@end
