//
//  EmergencyTableViewController.h
//  Calendar
//
//  Created by YingHong on 2014/10/25.
//
//

#import <UIKit/UIKit.h>

@interface EmergencyTableViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *tableview;
    
    BOOL success;
    NSError *error;
    NSFileManager * fm;
    NSArray * paths;
    NSString *documentsDirectory;
    NSString *writableDBPath;
}

@end
