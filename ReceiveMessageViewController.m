//
//  ReceiveMessageViewController.m
//  Calendar
//
//  Created by YingHong on 2014/10/4.
//
//



/*NSString * _data_id = [ReceiveRN objectForKey:@"data_id"];
NSString * _detail = [ReceiveRN objectForKey:@"detail"];
NSString * _image = [ReceiveRN objectForKey:@"image"];
NSString * _time = [ReceiveRN objectForKey:@"time"];
NSString * _time_detail = [ReceiveRN objectForKey:@"time_detail"];
NSString * _title = [ReceiveRN objectForKey:@"title"];
NSString * _type = [ReceiveRN objectForKey:@"type"];
*/
#import "ReceiveMessageViewController.h"
#import "ReceivDetailViewController.h"
#import "TableViewCell.h"
#import "toolBarControllerView.h"
#import "DatabaseMethod.h"
#import "NewCKViewController.h"
#import "InformationViewController.h"
#import "EmergencyTableViewController.h"
#import "PostCheckMessageViewController.h"

@interface ReceiveMessageViewController ()
{
    NSString * _title;
    NSString * _detail;
    NSString * _image;
    NSString * _time;
    NSString * _time_detail;
    NSString * _type;
    NSString * _check_img;
    NSString * _checkDate;
    NSString * _data_id;
    NSString * _date;
    NSString * _city;
    NSString * _area;
    NSString * _address;
    
    int _selected_index;
    
    toolBarControllerView *toolDelegate;
}

@end

@implementation ReceiveMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)openFMDB
{
    [title_list removeAllObjects];
    [detail_list removeAllObjects];
    [date_list removeAllObjects];
    [img_list removeAllObjects];
    [type_list removeAllObjects];
    [time_detail removeAllObjects];
    [data_id_list removeAllObjects];
    [check_img_list removeAllObjects];
    [city_list removeAllObjects];
    [area_list removeAllObjects];
    [address_list removeAllObjects];
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
                          @"SELECT * FROM %@ where %@ = '%@' ",@"NewRDTable",@"type",@"1"];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            _title = [rs stringForColumn:@"title"];
            [title_list addObject:_title];
            _detail = [rs stringForColumn:@"detail"];
            [detail_list addObject:_detail];
            _time = [rs stringForColumn:@"time"];
            [date_list addObject:_time];
            //[date_list addObject:_date];
            _image = [rs stringForColumn:@"image"];
            [img_list addObject:_image];
            _data_id = [rs stringForColumn:@"data_id"];
            [data_id_list addObject:_data_id];
            _time_detail = [rs stringForColumn:@"time_detail"];
            [time_detail addObject:_time_detail];
            _type = [rs stringForColumn:@"type"];
            [type_list addObject:_type];
            _check_img = [rs stringForColumn:@"check_img"];
            [check_img_list addObject:_check_img];
            _city = [rs stringForColumn:@"city"];
            [city_list addObject:_city];
            _area = [rs stringForColumn:@"area"];
            [area_list addObject:_area];
            _address = [rs stringForColumn:@"address"];
            [address_list addObject:_address];
            
        }
        [db close];
        
    }
    
}



-(void)setUI
{
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, 320, 300)];
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

    if([_check_img isEqualToString:@"1"])
        
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
    
    ReceivDetailViewController * dateView = [[ReceivDetailViewController alloc] initWithNibName:@"ReceivDetailViewController" bundle:nil];
    
    NSString *allTime = [NSString stringWithFormat:@"%@/%@",[date_list objectAtIndex:index],[time_detail objectAtIndex:index]];
    
     NSString * Address = [[city_list objectAtIndex:index] stringByAppendingString:[area_list objectAtIndex:index]];
    NSString *allAddress = [Address stringByAppendingString:[address_list objectAtIndex:index]];
    
    NSString *propaganda_url = [NSString stringWithFormat:@"http://172.20.10.2/ClubCloud/userServer/Request/request_img/%@.png",[data_id_list objectAtIndex:index]];
    
    NSLog(@"%@",propaganda_url);
    
    dateView.titleStr = [title_list objectAtIndex:index];
    dateView.timeStr = allTime;
    dateView.addressStr = allAddress;
    dateView.propagandaStr = [detail_list objectAtIndex:index];
    dateView.propagandaImgUrl = propaganda_url;
    dateView._image = [img_list objectAtIndex:index];
    dateView._check_img = [check_img_list objectAtIndex:index];
    dateView._created_date = [date_list objectAtIndex:index];
    dateView._time = [time_detail objectAtIndex:index];
    dateView._type = [type_list objectAtIndex:index];
    
    [self.navigationController pushViewController:dateView animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self openFMDB];
    
    [tableview reloadData];
    
    [super viewDidAppear:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUI];
    

    title_list = [[NSMutableArray alloc] init];
    detail_list = [[NSMutableArray alloc] init];
    date_list = [[NSMutableArray alloc] init];
    img_list = [[NSMutableArray alloc] init];
    time_detail = [[NSMutableArray alloc] init];
    data_id_list = [[NSMutableArray alloc] init];
    type_list =[[NSMutableArray alloc] init];
    check_img_list = [[NSMutableArray alloc]init];
    city_list = [[NSMutableArray alloc]init];
    area_list = [[NSMutableArray alloc]init];
    address_list = [[NSMutableArray alloc]init];
    
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
            [weakSelf EmergencyNotificationViewControllerMethod];
        }else if (x ==4)
        {
            [weakSelf InformationViewControllerMethod];
        }
    };
    
    [self.view addSubview:toolDelegate];
    

    
    // Do any additional setup after loading the view from its nib.
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
-(void)goToPostCheckMessageMethod
{
    NSMutableArray * view_controllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
    PostCheckMessageViewController * postChek = [[PostCheckMessageViewController alloc] initWithNibName:@"PostCheckMessageViewController" bundle:nil];
    
    [view_controllers removeLastObject];
    [view_controllers addObject:postChek];
      NSLog(@"%@",view_controllers);
    [self.navigationController setViewControllers:[NSArray arrayWithArray:view_controllers]animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
