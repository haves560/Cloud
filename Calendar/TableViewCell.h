//
//  TableViewCell.h
//  Calendar
//
//  Created by YingHong on 2014/7/15.
//
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
{
    UILabel *titleLb;
    UILabel *timeLb;
    UILabel *dateLb;
    UIImageView *colorIcon;
}
@property (weak, nonatomic) IBOutlet UILabel *dateLb;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UIImageView *colorIcon;

@end
