//
//  NSString_Post.h
//  audi_app
//
//  Created by 726 on 13/12/23.
//  Copyright (c) 2013年 YoGa Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString_Post : NSObject
{
    NSString *notifications;
    NSString *device_token;
    NSString *device_user_session;
    NSString *productInfoImagePath;
    NSString *carVIN;
    
}

@property (nonatomic,retain) NSString *notifications;
@property (nonatomic,retain) NSString *device_token;
@property (nonatomic,retain) NSString *device_user_session;
@property (nonatomic, retain) NSString *productInfoImagePath;
@property (nonatomic, retain) NSString *carVIN;
@property (nonatomic, retain) NSString *checkOk;
@property (nonatomic, retain) NSString *qrcode_post;

+ (NSString_Post *)getInstance;

@end
