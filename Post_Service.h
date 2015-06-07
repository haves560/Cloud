//
//  Post_Service.h
//  audi_app
//
//  Created by YoGa Chen on 13/11/25.
//  Copyright (c) 2013年 YoGa Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "PostServiceListener.h"

@class Post_Service;

@interface Post_Service : UIView{
    
    NSURLConnection *theConnection;
    
    NSDictionary *post_dic;
    
    //id listener;
    
    void(^finishCallback)(Post_Service *aService);
    
    BOOL _finished;
}

@property(nonatomic,retain) NSMutableData *receivedData;
@property(nonatomic,retain) NSURLConnection *theConnection;
- (void)cancel;

@property(nonatomic,retain) NSString *app_name_id; 
@property(nonatomic,retain) NSString *app_package_id;
@property(nonatomic,retain) NSString *dataString;
@property(nonatomic,retain) NSNumber *errorCode;
@property(nonatomic , assign) id listener;
@property(nonatomic , assign) NSURL *url;
@property(nonatomic, retain) NSString *URL;
@property(nonatomic , retain) NSDictionary *post_dic;
@property(nonatomic , copy) void(^finishCallback)(Post_Service *aService);

-(void)SetNSDictionary:(NSMutableString *)dictionary SetURL:(NSString*)url;

@end
