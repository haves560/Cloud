//
//  NewCKViewController.m
//  Calendar
//
//  Created by YingHong on 2014/10/4.
//
//

#import "NewCKViewController.h"
#import <CoreGraphics/CoreGraphics.h>
#import "DateDetailsViewController.h"
#import "CKCalendarView.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabase.h"
#import "toolBarControllerView.h"
#import "PostCheckMessageViewController.h"
#import "ReceiveMessageViewController.h"
#import "InformationViewController.h"
#import "EmergencyTableViewController.h"

@interface NewCKViewController ()<CKCalendarDelegate>
{
    NSString *_date;
    
    toolBarControllerView *toolDelegate;
    

    
}
@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSArray *disabledDates;

@end


@implementation NewCKViewController

@synthesize date_list;

- (void)viewDidAppear:(BOOL)animated
{
    [self openFMDB];
    
   // [self setUI];
    
    [super viewDidAppear:YES];
}



-(void)setUI
{
    date_list = [[NSMutableArray alloc] init];
    [self openFMDB];
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    self.calendar = calendar;
    calendar.delegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy/MM/dd"];
    
    self.minimumDate = [self.dateFormatter dateFromString:@"2013/07/05"];
    NSMutableArray *toNSArray = [[NSMutableArray alloc] init];
    for (int i =0 ; i<date_list.count; i++)
    {
        [toNSArray addObject:[self.dateFormatter dateFromString:[date_list objectAtIndex:i]]];
        NSLog(@"date_list = %@",date_list);
        
        self.disabledDates  = [toNSArray copy];
    }
    
    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    
    calendar.frame = CGRectMake(10, 40, 300, 320);
    [self.view addSubview:calendar];
    
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(calendar.frame) + 4, self.view.bounds.size.width, 24)];
    [self.view addSubview:self.dateLabel];
    
    self.dateLabel = nil;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];
}

//- (id)init {
//    self = [super init];
//    if (self) {
//        date_list = [[NSMutableArray alloc] init];
//        [self openFMDB];
//        CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
//        self.calendar = calendar;
//        calendar.delegate = self;
//
//        self.dateFormatter = [[NSDateFormatter alloc] init];
//        [self.dateFormatter setDateFormat:@"yyyy/MM/dd"];
//
//        self.minimumDate = [self.dateFormatter dateFromString:@"2013/07/05"];
//        NSMutableArray *toNSArray = [[NSMutableArray alloc] init];
//        for (int i =0 ; i<date_list.count; i++)
//        {
//            [toNSArray addObject:[self.dateFormatter dateFromString:[date_list objectAtIndex:i]]];
//            self.disabledDates  = [toNSArray copy];
//
//        }
//
//        calendar.onlyShowCurrentMonth = NO;
//        calendar.adaptHeightToNumberOfWeeksInMonth = YES;
//
//        calendar.frame = CGRectMake(10, 10, 300, 320);
//        [self.view addSubview:calendar];
//
//        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(calendar.frame) + 4, self.view.bounds.size.width, 24)];
//        [self.view addSubview:self.dateLabel];
//
//        self.view.backgroundColor = [UIColor whiteColor];
//
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];
//    }
//    return self;
//}

-(void)openFMDB
{
    [date_list removeAllObjects];
    
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

    if([db open])
    {
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT created_date FROM %@",@"Scheduling"];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            _date = [rs stringForColumn:@"created_date"];
            NSLog(@"adate = %@",_date);
            [date_list addObject:_date];
        }
        [db close];
        
    }
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%@",self.navigationController.viewControllers);
    
    [self setUI];
    
    toolDelegate = [[toolBarControllerView alloc] initWithFrame:CGRectMake(0, 500, 320, 60)];
    
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background_2"]];
    toolDelegate.backgroundColor =background;
    
    __weak __typeof(self)weakSelf = self;
    toolDelegate.returmNumber = ^(int x)
    {
        NSLog(@"%d",x);
        if(x == 1)
        {
            [weakSelf goToPostCheckMessage];
        }else if(x == 3)
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
    
      
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setUI];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)localeDidChange {
    [self.calendar setLocale:[NSLocale currentLocale]];
}

- (BOOL)dateIsDisabled:(NSDate *)date {
    for (NSDate *disabledDate in self.disabledDates) {
        if ([disabledDate isEqualToDate:date]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark -
#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    
    // TODO: play with the coloring if we want to...
    if ([self dateIsDisabled:date]) {
        dateItem.backgroundColor =[UIColor colorWithRed:273.0/255.0 green:166.0/255.0 blue:96.0/255.0 alpha:1];
        dateItem.textColor = [UIColor whiteColor];
    }
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    //紅色區域
    return YES;
    
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    //白色區域
    
      DateDetailsViewController * dateView = [[DateDetailsViewController alloc] initWithNibName:@"DateDetailsViewController" bundle:nil];
    
    dateView.dateStr = [self.dateFormatter stringFromDate:date];
    
    [self.navigationController pushViewController:dateView animated:YES];
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    if ([date laterDate:self.minimumDate] == date) {
        self.calendar.backgroundColor = [UIColor blueColor];
        return YES;
        
    } else {
        self.calendar.backgroundColor = [UIColor redColor];
        return NO;
    }
}

- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame {
    // NSLog(@"calendar layout: %@", NSStringFromCGRect(frame));
}

- (void)goToPostCheckMessage
{
    NSMutableArray * view_controllers =
    [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
    PostCheckMessageViewController * post = [[PostCheckMessageViewController alloc] initWithNibName:@"PostCheckMessageViewController" bundle:nil];
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
-(void)EmergencyNotificationViewControllerMethod
{
    NSMutableArray * view_controllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
    EmergencyTableViewController * emergency = [[EmergencyTableViewController alloc] initWithNibName:@"EmergencyTableViewController" bundle:nil];
    
    [view_controllers removeLastObject];
    [view_controllers addObject:emergency];
    
    NSLog(@"%@",view_controllers);
    
    [self.navigationController setViewControllers:[NSArray arrayWithArray:view_controllers]animated:YES];
    
}

@end