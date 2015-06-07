#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class UserLoginViewController;
@class CKViewController;
@class PostCheckMessageViewController;
@class InformationViewController;


@interface CKAppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>
{
    BOOL success;
    NSError *error;
    NSFileManager * fm;
    NSArray * paths;
    NSString *documentsDirectory;
    NSString *writableDBPath;
    

}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UserLoginViewController *viewController;
@property (strong, nonatomic) CKViewController * CKViewController;
@property (strong, nonatomic) InformationViewController * PCMView;

@end