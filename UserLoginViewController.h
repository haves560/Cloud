//
//  UserLoginViewController.h
//  Calendar
//
//  Created by YingHong on 2014/7/25.
//
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"

@interface UserLoginViewController : UIViewController<NIDropDownDelegate>
{
    NIDropDown *dropDown;
    
    
    BOOL success;
    NSError *error;
    NSFileManager * fm;
    NSArray * paths;
    NSString *documentsDirectory;
    NSString *writableDBPath;
    
}
@property (weak, nonatomic) IBOutlet UIButton *idBtn;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UIButton *cityAreaBtn;
@property (nonatomic, retain) NSArray *viewControllers;
@property (weak, nonatomic) IBOutlet UITextField *idPostTextField;
- (IBAction)callService:(id)sender;
- (IBAction)idClicked:(id)sender;
- (IBAction)cityAreaBtn:(NSString*)territory_name;
- (IBAction)cityClicked:(id)sender;

-(void)rel;
@end
