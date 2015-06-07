//
//  AddSchedulingViewController.h
//  Calendar
//
//  Created by YingHong on 2014/7/8.
//
//

#import <UIKit/UIKit.h>

@interface AddSchedulingViewController : UIViewController
{
    BOOL success;
    NSError *error;
    NSFileManager * fm;
    NSArray * paths;
    NSString *documentsDirectory;
    NSString *writableDBPath;
    
}
@property (weak, nonatomic) NSString *titleStr;
@property (weak, nonatomic)NSString * _date;
@property (weak, nonatomic)NSString * addressStr;
@property (weak, nonatomic)NSString * propagandaStr;
@property (weak, nonatomic)NSString * propagandaImgUrl;
@property (weak, nonatomic)NSString * _time;
@property (weak, nonatomic)NSString * _image;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
- (IBAction)back:(id)sender;
- (IBAction)sqlDelete:(id)sender;
- (IBAction)updateCk:(id)sender;

@end
