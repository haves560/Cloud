//
//  DateDetailsViewController.m
//  Calendar
//
//  Created by YingHong on 2014/7/4.
//
//

#import "DateDetailsViewController.h"
#import "NewCKViewController.h"
#import "AddSchedulingViewController.h"
#import "UpdateCalendarViewController.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "TableViewCell.h"

@interface DateDetailsViewController ()
{

    NSString * _checkDate;
    NSString * _date;
    NSString * titleStr;
    NSString * addressStr;
    NSString * propagandaStr;
    NSString * propagandaImgUrl;
    NSString * _check_img;
    NSString * _time;
    NSString * _type;
    NSString * _image;
    
    int _selected_index;
    
    NSMutableArray *title_list;
    NSMutableArray *message_list;
    NSMutableArray *date_list;
    NSMutableArray *check_img_list;
    NSMutableArray *time_list;
    NSMutableArray *image_list;
    NSMutableArray *address_list;
    NSMutableArray *type_list;
    NSMutableArray *url_list;
    
}

@end

@implementation DateDetailsViewController
@synthesize showDateLB;
@synthesize dateStr;

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
    
    showDateLB.text = dateStr;
    _checkDate = dateStr;
    title_list = [[NSMutableArray alloc]init ];
    message_list = [[NSMutableArray alloc]init];
    date_list = [[NSMutableArray alloc]init];
    check_img_list = [[NSMutableArray alloc]init];
    time_list = [[NSMutableArray alloc] init];
    image_list = [[NSMutableArray alloc] init];
    address_list = [[NSMutableArray alloc] init];
    type_list = [[NSMutableArray alloc] init];
    url_list = [[NSMutableArray alloc] init];
    
    
    [self setUI];
    [self openFMDB];
    

    // Do any additional setup after loading the view from its nib.
}

-(void)openFMDB
{
    [title_list removeAllObjects];
    [message_list removeAllObjects];
    [date_list removeAllObjects];
    [check_img_list removeAllObjects];
    [time_list removeAllObjects];
    [image_list removeAllObjects];
    [address_list removeAllObjects];
    [type_list removeAllObjects];
    [url_list removeAllObjects];
    
    
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
                          @"SELECT * FROM %@ where %@ = '%@' ",@"Scheduling",@"created_date",dateStr];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            titleStr = [rs stringForColumn:@"title"];
            [title_list addObject:titleStr];
            propagandaStr = [rs stringForColumn:@"message"];
            [message_list addObject:propagandaStr];
            _date = [rs stringForColumn:@"created_date"];
                NSLog(@"adate = %@",_date);
            //[date_list addObject:_date];
            _check_img = [rs stringForColumn:@"check_img"];
            [check_img_list addObject:_check_img];
            _time = [rs stringForColumn:@"time"];
            [time_list addObject:_time];
            propagandaImgUrl = [rs stringForColumn:@"URL"];
            [url_list addObject:propagandaImgUrl];
            _image = [rs stringForColumn:@"image"];
            [image_list addObject:_image];
            addressStr = [rs stringForColumn:@"address"];
            [address_list addObject:addressStr];
            _type = [rs stringForColumn:@"type"];
            [type_list addObject:_type];
            
            NSLog(@"titleStr = %@ , propagandaStr = %@ , _date =%@ , _check_img = %@ , _time = %@ , propagandaImgUrl = %@ , _image =%@ , addressStr = %@ , _type = %@ ", titleStr,propagandaStr,_date,_check_img,_time,propagandaImgUrl,_image,addressStr,_type);
            
        }
        [db close];

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
    
    if([_checkDate isEqualToString:_date])
    {
        if([[check_img_list objectAtIndex:indexPath.row] isEqualToString:@"1"])
        {
            cell.colorIcon.image =[UIImage imageNamed:@"star_read"];
        }else
        {
            cell.colorIcon.image =[UIImage imageNamed:@"star_unread"];
        }
        cell.titleLb.text = [title_list objectAtIndex:indexPath.row];
        cell.timeLb.text = [time_list objectAtIndex:indexPath.row];
        cell.dateLb.text = _date;
    
       // [tableView setSeparatorColor:[UIColor clearColor]];
    }else
    {
        //[tableView setSeparatorColor:[UIColor clearColor]];
    }
    
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
    AddSchedulingViewController * dateView = [[AddSchedulingViewController alloc] initWithNibName:@"AddSchedulingViewController" bundle:nil];
    
    dateView._date = showDateLB.text;
    dateView.titleStr = [title_list objectAtIndex:index];
    dateView.propagandaStr = [message_list objectAtIndex:index];
    dateView._time = [time_list objectAtIndex:index];
    dateView._image = [image_list objectAtIndex:index];
    dateView.addressStr = [address_list objectAtIndex:index];
    dateView.propagandaImgUrl = [url_list objectAtIndex:index];
    
    [self.navigationController pushViewController:dateView animated:YES];
}

-(CGFloat) tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int hight=50.0f;
    return  hight;
}

- (IBAction)back:(id)sender
{
    //NSLog(@"BACK");
    NSMutableArray * view_controllers =
    [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
    
    NSLog(@"%@",view_controllers);
    
   [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addScheduling:(id)sender
{

    NSMutableArray * view_controllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
    UpdateCalendarViewController * dateView = [[UpdateCalendarViewController alloc] initWithNibName:@"UpdateCalendarViewController" bundle:nil];
    
    dateView._checkType = @"0";
    
    //dateView.dateStr = showDateLB.text;

      [view_controllers removeLastObject];
    [view_controllers addObject:dateView];
    
    NSLog(@"%@",view_controllers);
    
    [self.navigationController setViewControllers:[NSArray arrayWithArray:view_controllers]animated:YES];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self openFMDB];
    
    [tableview reloadData];
    
    [super viewDidAppear:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
