//
//  UpdateCalendarViewController.h
//  Calendar
//
//  Created by YingHong on 2014/10/29.
//
//

#import <UIKit/UIKit.h>

@interface UpdateCalendarViewController : UIViewController
{
    BOOL success;
    NSError *error;
    NSFileManager * fm;
    NSArray * paths;
    NSString *documentsDirectory;
    NSString *writableDBPath;
}


- (IBAction)selectDate:(id)sender;
- (IBAction)selectTiem:(id)sender;
- (IBAction)Complete:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *timeLB;

@property (weak, nonatomic) IBOutlet UILabel *dateLB;
@property (weak, nonatomic) IBOutlet UITextField *EditorAddress;
@property (weak, nonatomic) IBOutlet UITextField *EditorTitle;
@property (weak, nonatomic) IBOutlet UITextField *EditorDetail;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (copy,nonatomic) NSString *_address;
@property (copy,nonatomic) NSString *_Title;
@property (copy,nonatomic) NSString *_detail;
@property (copy,nonatomic) NSString *imgURL;
@property (copy,nonatomic) NSString *_checkType;
@property (copy,nonatomic) NSString *_time;
@property (copy,nonatomic) NSString *_date;

@end
