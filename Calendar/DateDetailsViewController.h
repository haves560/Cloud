//
//  DateDetailsViewController.h
//  Calendar
//
//  Created by YingHong on 2014/7/4.
//
//

#import <UIKit/UIKit.h>

@interface DateDetailsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *tableview;
    
    BOOL success;
    NSError *error;
    NSFileManager * fm;
    NSArray * paths;
    NSString *documentsDirectory;
    NSString *writableDBPath;
    
  

}
@property (strong, nonatomic) IBOutlet UILabel *showDateLB;
@property (weak , nonatomic)NSString *dateStr;
- (IBAction)back:(id)sender;
- (IBAction)addScheduling:(id)sender;
@end
