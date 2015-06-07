//
//  EmergencyTableViewController.m
//  Calendar
//
//  Created by YingHong on 2014/10/25.
//
//

#import "EmergencyTableViewController.h"
#import "EmergencyNotificationViewController.h"
#import "DatabaseMethod.h"
#import "toolBarControllerView.h"
#import "TableViewCell.h"
#import "InformationViewController.h"
#import "NewCKViewController.h"
#import "PostCheckMessageViewController.h"
#import "ReceiveMessageViewController.h"

@interface EmergencyTableViewController ()
{
    NSMutableArray *title_list;
    NSMutableArray *detail_list;
    NSMutableArray *date_list;
    NSMutableArray *type_list;
    NSMutableArray *check_img;
    NSMutableArray *time_detail;
    NSMutableArray *data_id_list;
    
    NSString * _data_id;
    NSString * _title;
    NSString * _detail;
    NSString * _time;
    NSString * _type;
    NSString * _time_detail;
    NSString * _username;
    NSString * _check_img;
    
    int _selected_index;
    toolBarControllerView *toolDelegate;

}

@end

@implementation EmergencyTableViewController


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
    
    [self setUI];
    
    title_list = [[NSMutableArray alloc] init];
    detail_list = [[NSMutableArray alloc] init];
    date_list = [[NSMutableArray alloc] init];
    type_list = [[NSMutableArray alloc]init];
    time_detail = [[NSMutableArray alloc] init];
    check_img = [[NSMutableArray alloc] init];
    data_id_list = [[NSMutableArray alloc]init];

    [self GetReceiveMessageDB];
    [self GetRegisteDB];
    
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
        else if (x == 1)
        {
            [weakSelf goToPostCheckMessageMethod];
        }else if (x ==5)
        {
            [weakSelf goToReceiveMessageViewcontrollerMehod];
        }else if (x ==4)
        {
            [weakSelf InformationViewControllerMethod];
        }
    };
    
    [self.view addSubview:toolDelegate];
    
    


    // Do any additional setup after loading the view from its nib.
}

-(void)GetReceiveMessageDB
{
    [title_list removeAllObjects];
    [detail_list removeAllObjects];
    [date_list removeAllObjects];
    [type_list removeAllObjects];
    [time_detail removeAllObjects];
    [check_img removeAllObjects];
    [data_id_list removeAllObjects];
    
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

    
    if([db open])
    {
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM %@ where %@ = '%@' ",@"NewRDTable",@"type",@"2"];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            _title = [rs stringForColumn:@"title"];
            [title_list addObject:_title];
            _detail = [rs stringForColumn:@"detail"];
            [detail_list addObject:_detail];
            _time = [rs stringForColumn:@"time"];
            [date_list addObject:_time];
            //[date_list addObject:_date];
            _time_detail = [rs stringForColumn:@"time_detail"];
            [time_detail addObject:_time_detail];
            _type = [rs stringForColumn:@"type"];
             [type_list addObject:_type];
            _data_id = [rs stringForColumn:@"data_id"];
            [data_id_list addObject:_data_id];
            _check_img = [rs stringForColumn:@"check_img"];
            [check_img addObject:_check_img];
        }
        [db close];
        
    }
    
}


-(void)GetRegisteDB
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
            _username = [rs stringForColumn:@"user"];
        }
        [db close];
        [rs close];
        
    }
    
    
    else{
        NSLog(@"無法開啓");
    }
    
    
    
}

-(void)setUI
{
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 135, 320, 300)];
    tableview.backgroundColor=[UIColor clearColor];
    [tableview setDelegate:self];
    [tableview setDataSource:self];
    [self.view addSubview: tableview];
    
    [tableview registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [title_list count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:@"cell"];
    //NSLog(@"date = %@ , checkdate = %@",date_list,_checkDate);
    
    if([[check_img objectAtIndex:indexPath.row] isEqualToString:@"1"])
        
    {
        cell.colorIcon.image =[UIImage imageNamed:@"star_read"];
    }else
    {
        cell.colorIcon.image =[UIImage imageNamed:@"star_unread"];
    }
    cell.titleLb.text = [title_list objectAtIndex:indexPath.row];
    cell.timeLb.text = [time_detail objectAtIndex:indexPath.row];
    cell.dateLb.text = [date_list objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selected_index = indexPath.row;
    
    NSLog(@"_selected_index= %d",_selected_index);
    
    
    
    [self NextPage:_selected_index];
}

-(void)NextPage:(NSInteger*)index
{
    EmergencyNotificationViewController * dateView = [[EmergencyNotificationViewController alloc] initWithNibName:@"EmergencyNotificationViewController" bundle:nil];
    
    dateView._Title = [title_list objectAtIndex:index];
    dateView._detail = [detail_list objectAtIndex:index];
    dateView._time = [date_list objectAtIndex:index];
    dateView._time_detail = [time_detail objectAtIndex:index];
    dateView._data_id = _data_id;
    dateView._username = _username;
    [self.navigationController pushViewController:dateView animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self GetReceiveMessageDB];
    
    [tableview reloadData];
    
    [super viewDidAppear:YES];
}

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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
