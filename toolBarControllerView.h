//
//  toolBarControllerView.h
//  Calendar
//
//  Created by YingHong on 2014/9/22.
//
//

#import <UIKit/UIKit.h>
#import "PostCheckMessageViewController.h"
#import "NewCKViewController.h"


@interface toolBarControllerView : UIView

@property (nonatomic,strong)UIButton * goToPostCheckMessageViewController;
@property (nonatomic,strong)UIButton * goToCkViewController;
@property (nonatomic,strong)UIButton * goToReceiveMessageViewController;
@property (nonatomic,strong)UIButton * goToInformationViewController;
@property (nonatomic,strong)UIButton * goToEmergncyViewController;
@property(nonatomic,copy) void(^returmNumber)(int);

-(void)setUI;
@end
