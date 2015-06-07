//
//  InformationViewController.h
//  Calendar
//
//  Created by YingHong on 2014/10/15.
//
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"


@interface InformationViewController :UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZBarReaderDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    
    BOOL success;
    NSError *error;
    NSFileManager * fm;
    NSArray * paths;
    NSString *documentsDirectory;
    NSString *writableDBPath;
    
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *user_lb;
- (IBAction)checkEvents:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *name_lb;
@property (weak, nonatomic) IBOutlet UILabel *phoneNnmbe_lb;
@property (weak, nonatomic) IBOutlet UILabel *city_lb;
@property (weak, nonatomic) IBOutlet UILabel *aera_lb;
@property (weak, nonatomic) IBOutlet UIImageView *photo_img;

@property (copy, nonatomic) NSString *_userStr;
@property (copy, nonatomic) NSString *_nameStr;
@property (copy, nonatomic) NSString *_PhoneNumberStr;
@property (copy, nonatomic) NSString *_cityStr;
@property (copy, nonatomic) NSString *_areaStr;

@property (nonatomic, strong) UIImageView * line;
- (IBAction)scanQRCode:(id)sender;
- (IBAction)change_photo:(id)sender;



@end
