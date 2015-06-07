//
//  ReceiveMessageViewController.h
//  Calendar
//
//  Created by YingHong on 2014/10/4.
//
//

#import <UIKit/UIKit.h>

@interface ReceiveMessageViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *tableview;
    
    BOOL success;
    NSError *error;
    NSFileManager * fm;
    NSArray * paths;
    NSString *documentsDirectory;
    NSString *writableDBPath;
    
    NSMutableArray *title_list;
    NSMutableArray *detail_list;
    NSMutableArray *date_list;
    NSMutableArray *img_list;
    NSMutableArray *time_detail;
    NSMutableArray *data_id_list;
    NSMutableArray *type_list;
    NSMutableArray *check_img_list;
    NSMutableArray *city_list;
    NSMutableArray *area_list;
    NSMutableArray *address_list;
}

@end
