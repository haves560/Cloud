//
//  NewCKViewController.h
//  Calendar
//
//  Created by YingHong on 2014/10/4.
//
//

#import <UIKit/UIKit.h>

@interface NewCKViewController : UIViewController
{
    BOOL success;
    NSError *error;
    NSFileManager * fm;
    NSArray * paths;
    NSString *documentsDirectory;
    NSString *writableDBPath;
}
@property(nonatomic,strong)NSMutableArray *date_list;
@end
