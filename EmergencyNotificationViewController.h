//
//  EmergencyNotificationViewController.h
//  Calendar
//
//  Created by YingHong on 2014/10/24.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface EmergencyNotificationViewController : UIViewController<CLLocationManagerDelegate>
{
    BOOL success;
    NSError *error;
    NSFileManager * fm;
    NSArray * paths;
    NSString *documentsDirectory;
    NSString *writableDBPath;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *dateLb;
- (IBAction)backMethod:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *detailLb;

@property (copy, nonatomic)NSString * _data_id;
@property (copy, nonatomic)NSString * _Title;
@property (copy, nonatomic)NSString * _detail;
@property (copy, nonatomic)NSString * _time;
@property (copy, nonatomic)NSString * _type;
@property (copy, nonatomic)NSString * _time_detail;
@property (copy, nonatomic)NSString * _username;
- (IBAction)Return:(id)sender;
- (IBAction)Help:(id)sender;
@end
