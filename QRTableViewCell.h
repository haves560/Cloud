//
//  QRTableViewCell.h
//  Calendar
//
//  Created by YingHong on 2014/10/20.
//
//

#import <UIKit/UIKit.h>

@interface QRTableViewCell : UITableViewCell
{
    UILabel *titleLb;
    UILabel *timeLb;
    UILabel *address;
    UITextView * detail;
    UIImageView *colorIcon;

}
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UITextView *detail;
@property (weak, nonatomic) IBOutlet UIImageView *colorIcon;


@end
