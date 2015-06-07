//
//  ReceivDetailViewController.h
//  Calendar
//
//  Created by YingHong on 2014/10/13.
//
//

#import <UIKit/UIKit.h>

@interface ReceivDetailViewController : UIViewController
{
    BOOL success;
    NSError *error;
    NSFileManager * fm;
    NSArray * paths;
    NSString *documentsDirectory;
    NSString *writableDBPath;
}

@property (strong, nonatomic)NSString * titleStr;
@property (strong, nonatomic)NSString * timeStr;
@property (strong, nonatomic)NSString * addressStr;
@property (strong, nonatomic)NSString * propagandaStr;
@property (strong, nonatomic)NSString * propagandaImgUrl;
@property (strong, nonatomic)NSString * _check_img;
@property (strong, nonatomic)NSString * _created_date;
@property (strong, nonatomic)NSString * _time;
@property (strong, nonatomic)NSString * _image;
@property (strong, nonatomic)NSString * _type;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *title_lb;
@property (weak, nonatomic) IBOutlet UILabel *time_lb;
@property (weak, nonatomic) IBOutlet UILabel *address_lb;
@property (weak, nonatomic) IBOutlet UIImageView *propaganda_img;
@property (weak, nonatomic) IBOutlet UILabel *detailLb;

- (IBAction)addToCalendar:(id)sender;

- (IBAction)FbShare:(id)sender;

@end
