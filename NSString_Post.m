//
//  NSString_Post.m
//  audi_app
//
//  Created by 726 on 13/12/23.
//  Copyright (c) 2013年 YoGa Chen. All rights reserved.
//

#import "NSString_Post.h"

static NSString_Post *_instance = nil;

@implementation NSString_Post
@synthesize notifications;
@synthesize device_token;
@synthesize device_user_session;
@synthesize productInfoImagePath;
@synthesize carVIN;
@synthesize checkOk;
@synthesize qrcode_post;

//- (void)dealloc
//{
//    //[productInfoImagePath release];
//    productInfoImagePath = nil;
//    
//    //[notifications release];
//    [super dealloc];
//}

+ (NSString_Post *)getInstance
{
    if ( _instance == nil )
    {
        _instance = [NSString_Post new];
    }
    
    return _instance;
}

- (void)setNotifications:(NSString *)aNotifications
{
    
    notifications = aNotifications;
   // device_token = aNotifications;
    NSLog(@"hello?");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationUpdated" object:nil];
}

@end
