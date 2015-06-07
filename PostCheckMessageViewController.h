//
//  PostCheckMessageViewController.h
//  Calendar
//
//  Created by YingHong on 2014/8/13.
//
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
@interface PostCheckMessageViewController : UIViewController<NIDropDownDelegate>
{
    NIDropDown *dropDown;
    
    BOOL success;
    NSError *error;
    NSFileManager * fm;
    NSArray * paths;
    NSString *documentsDirectory;
    NSString *writableDBPath;

}
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UIButton *areaBtn;
- (IBAction)selectAlbum:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *photoView;

- (IBAction)selectCity:(id)sender;
- (IBAction)selectArea:(id)sender;
- (IBAction)DateAndTime:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *Eventdetail;
@property (weak, nonatomic) IBOutlet UITextField *EventTitle;

@property (weak, nonatomic) IBOutlet UITextField *EventAddress;
@property (weak, nonatomic) IBOutlet UILabel *dateAndTimeLb;

- (IBAction)OptPut:(id)sender;


@end
