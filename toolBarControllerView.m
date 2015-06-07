//
//  toolBarControllerView.m
//  Calendar
//
//  Created by YingHong on 2014/9/22.
//
//

#import "toolBarControllerView.h"
#import "PostCheckMessageViewController.h"
#import "NewCKViewController.h"

@implementation toolBarControllerView
@synthesize goToCkViewController;
@synthesize goToPostCheckMessageViewController;
@synthesize goToReceiveMessageViewController;
@synthesize goToEmergncyViewController;
@synthesize goToInformationViewController;
@synthesize returmNumber;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUI];
        
    }
    return self;
}

-(void)setUI
{
    
    goToInformationViewController = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];

    [goToInformationViewController setBackgroundImage:[UIImage imageNamed:@"button_information.png"]forState:UIControlStateNormal];
    [goToInformationViewController setFont:[UIFont systemFontOfSize:14]];
    
    [goToInformationViewController setBackgroundColor:[UIColor whiteColor]];
    [goToInformationViewController setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [goToInformationViewController addTarget:self action:@selector(goToInformationViewControllMethod) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:goToInformationViewController];
    
    goToCkViewController =
    [[UIButton alloc] initWithFrame: CGRectMake( 66, 5, 60, 60 )];
    [goToCkViewController setBackgroundImage:[UIImage imageNamed:@"button_calendar.png"]forState:UIControlStateNormal];
    [goToCkViewController setBackgroundColor:[UIColor whiteColor]];
    [goToCkViewController setFont:[UIFont systemFontOfSize:14]];
    [goToCkViewController setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [goToCkViewController addTarget:self action:@selector(goToCkViewControllerMehod) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:goToCkViewController];
    
    goToReceiveMessageViewController =
    [[UIButton alloc] initWithFrame: CGRectMake( 127, 5, 60, 60 )];
    [goToReceiveMessageViewController setBackgroundImage:[UIImage imageNamed:@"button_news.png"]forState:UIControlStateNormal];    [goToReceiveMessageViewController setFont:[UIFont systemFontOfSize:14]];
    [goToReceiveMessageViewController setBackgroundColor:[UIColor whiteColor]];
    [goToReceiveMessageViewController setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [goToReceiveMessageViewController addTarget:self action:@selector(goToReceiveMessageViewcontrollerMehod) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:goToReceiveMessageViewController];

    
    goToPostCheckMessageViewController =
    [[UIButton alloc] initWithFrame: CGRectMake( 188, 5, 60, 60 )];
    [goToPostCheckMessageViewController setBackgroundImage:[UIImage imageNamed:@"button_message.png"]forState:UIControlStateNormal];
    [goToPostCheckMessageViewController setFont:[UIFont systemFontOfSize:14]];
    [goToPostCheckMessageViewController setBackgroundColor:[UIColor whiteColor]];
    [goToPostCheckMessageViewController setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [goToPostCheckMessageViewController addTarget:self action:@selector(goToPostCheckMessageViewMethod) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:goToPostCheckMessageViewController];
    
    
    goToEmergncyViewController = [[UIButton alloc] initWithFrame:CGRectMake(249, 5, 60, 60)];
    
   [goToEmergncyViewController setBackgroundImage:[UIImage imageNamed:@"button_warning.png"]forState:UIControlStateNormal];    [goToEmergncyViewController setFont:[UIFont systemFontOfSize:14]];
    
    [goToEmergncyViewController setBackgroundColor:[UIColor whiteColor]];
    [goToEmergncyViewController setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [goToEmergncyViewController addTarget:self action:@selector(goToEmergncyViewControllerMethod) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:goToEmergncyViewController];
 
}

-(void)goToPostCheckMessageViewMethod
{
    if(returmNumber)
    {
        returmNumber(1);
    }

}
-(void)goToCkViewControllerMehod
{
    if(returmNumber)
    {
        returmNumber(2);
    }

}
-(void)goToReceiveMessageViewcontrollerMehod
{
    if(returmNumber)
    {
        returmNumber(3);
    }
    
}
-(void)goToInformationViewControllMethod
{
    if(returmNumber)
    {
        returmNumber(4);
    }
}
-(void)goToEmergncyViewControllerMethod
{
    if(returmNumber)
    {
        returmNumber(5);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
