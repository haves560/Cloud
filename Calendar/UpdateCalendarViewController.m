//
//  UpdateCalendarViewController.m
//  Calendar
//
//  Created by YingHong on 2014/10/29.
//
//

#import "UpdateCalendarViewController.h"
#import "NewCKViewController.h"
#import "DatabaseMethod.h"

@interface UpdateCalendarViewController ()
{
    UIView * backgroundView;
    UIView * datePikerView;
    UILabel *dateLb;
    UILabel *timeLb;
    
    
}
@end

@implementation UpdateCalendarViewController
@synthesize EditorAddress;
@synthesize EditorDetail;
@synthesize EditorTitle;
@synthesize imageView;
@synthesize _address;
@synthesize _detail;
@synthesize _Title;
@synthesize dateLB;
@synthesize timeLB;
@synthesize _date;
@synthesize _time;
@synthesize _checkType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)InsertSQL
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
        
        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@','%@','%@','%@','%@','%@','%@','%@')VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@')",@"Scheduling",@"title",@"message",@"check_img",@"created_date",@"time",@"image",@"URL",@"address",@"type",EditorTitle.text,EditorDetail.text,@"0",_date,_time,@"0",@"",EditorAddress.text,@"1"];
        
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
        
        NSString *updateSql = [NSString stringWithFormat:@"UPDATE Scheduling set title ='%@',message='%@',created_date='%@',time='%@',address='%@' WHERE title='%@' ",EditorTitle.text,EditorDetail.text,dateLB.text,timeLB.text,EditorAddress.text, _Title];
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



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    timeLB.text = _time;
    dateLB.text = _date;
    EditorAddress.text = _address;
    EditorDetail.text = _detail;
    EditorTitle.text = _Title;
    //收鍵盤
    UIToolbar *doneToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    doneToolbar.barStyle = UIBarStyleBlackTranslucent;
    
    doneToolbar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(hideKeyboard)],
                         nil];
    
    [doneToolbar sizeToFit];
    
    EditorTitle.inputAccessoryView = doneToolbar;
    EditorDetail.inputAccessoryView = doneToolbar;
    EditorAddress.inputAccessoryView = doneToolbar;
    
   
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)selectDate:(id)sender
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
    
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    [datePicker addTarget:self action:@selector(getDate:) forControlEvents:UIControlEventValueChanged];
    
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
-(void)getDate:(UIDatePicker*)datePicker
{
    
    NSDate *date = datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString *dateString = [formatter stringFromDate:date];
    
    NSRange range = NSMakeRange(0, 10);
    
    _date = [dateString substringWithRange:range];
    
//    
//    NSRange range_time = NSMakeRange(11, 5);
//    
//    _time = [dateString substringWithRange:range_time];
//    
//    NSLog(@"%@",_time);
    
    dateLB.text = _date;
    dateLb.text = _date;
    
}

-(void)getTime:(UIDatePicker*)datePicker
{
    NSDate *date = datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *dateString = [formatter stringFromDate:date];
    
    _time = dateString;
    
    timeLB.text = dateString;
    timeLb.text = dateString;

}

-(void)closeView
{
    [backgroundView removeFromSuperview];
    [datePikerView removeFromSuperview];
}
- (IBAction)selectTiem:(id)sender
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
    
    datePicker.datePickerMode = UIDatePickerModeTime;
    
    [datePicker addTarget:self action:@selector(getTime:) forControlEvents:UIControlEventValueChanged];
    
    timeLb = [[UILabel alloc] init];
    timeLb.frame  = CGRectMake(20, 260, 300, 40);
    
    [datePikerView addSubview:timeLb];
    
    
    UIButton * closeBt = [[UIButton alloc] init];
    closeBt.frame = CGRectMake(100, 320, 100, 100);
    [closeBt setTitle:@"確定" forState:UIControlStateNormal];
    [closeBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    // closeBt.backgroundColor = [UIColor redColor];
    [closeBt addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [datePikerView addSubview:closeBt];
    
    [datePikerView addSubview:datePicker];
}

- (IBAction)Complete:(id)sender
{
    if([_checkType isEqualToString:@"0"])
    {
        [self InsertSQL];
    }else
    {
        [self UpdateSQL];
    }
    
    [self goToCKView];
    
}
- (void)hideKeyboard
{
    [EditorAddress resignFirstResponder];
    [EditorDetail resignFirstResponder];
    [EditorTitle resignFirstResponder];
}


-(void)goToCKView
{
    NSMutableArray * view_controllers =
    [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
    
    NewCKViewController * post = [[NewCKViewController alloc] initWithNibName:@"NewCKViewController" bundle:nil];
    
    [view_controllers removeAllObjects];
    [view_controllers addObject:post];
    
    NSLog(@"%@",view_controllers);
    
    [self.navigationController setViewControllers:[NSArray arrayWithArray:view_controllers]animated:YES];
}
@end
