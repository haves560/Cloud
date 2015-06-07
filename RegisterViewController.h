//
//  RegisterViewController.h
//  Calendar
//
//  Created by YingHong on 2014/7/26.
//
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController
{
    BOOL success;
    NSError *error;
    NSFileManager * fm;
    NSArray * paths;
    NSString *documentsDirectory;
    NSString *writableDBPath;

}
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *userCellPhoneTextField;
@property (copy, nonatomic) NSString *cityName;
@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *cityId;
@property (copy, nonatomic) NSString *cityAreaName;
@property (copy, nonatomic) NSString *cityAreaId;
@property (weak, nonatomic) IBOutlet UIImageView *AlbumImage;

- (IBAction)openPicker:(id)sender;

- (IBAction)postRegister2:(id)sender;

@end
