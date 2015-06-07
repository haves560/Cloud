//
//  Post_Service.m
//  audi_app
//
//  Created by YoGa Chen on 13/11/25.
//  Copyright (c) 2013年 YoGa Chen. All rights reserved.
//

#import "Post_Service.h"

@implementation Post_Service
@synthesize receivedData;
@synthesize listener;
@synthesize post_dic;
@synthesize URL;

@synthesize theConnection;
@synthesize finishCallback;
@synthesize dataString;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)SetNSDictionary:(NSMutableString *)dictionary SetURL:(NSString*)url{

    
//    NSData *post_data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
   
//    NSString *encrypt_data = [CpsDataCoder encryptConnectData:post_data];
//    
//    NSString *post_body = [NSString stringWithFormat:@"content=%@" , encrypt_data];
//    
    //    NSMutableString *post = [NSString stringWithFormat:@"app_name_id=%@&app_package_id=%@",app_name_id,app_package_id];
    
    //    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSData *postData = [dictionary dataUsingEncoding:NSUTF8StringEncoding];
    
  //  NSString *raw_string = [[[NSString alloc] initWithData:post_data encoding:NSUTF8StringEncoding] autorelease];
    
    //NSLog(@"raw_string:%@",raw_string);
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSURL *Server_url = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:Server_url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:20.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];
    
    _finished = NO;
    self.theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    
    //[self.theConnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    [self.theConnection start];
    
    if (theConnection) {
        self.receivedData = [NSMutableData data];
        
    }
    else {
		UIAlertView *connectFailMessage = [[UIAlertView alloc] initWithTitle:@"錯  誤" message:@"網路連線不穩"  delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
		[connectFailMessage show];
		//[connectFailMessage release];
    }
//    while ( ! _finished )
//    {
//        //NSLog(@"loop");
//        //[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//    }
    

}

//- (void)dealloc
//{
//    [finishCallback release];
//    
//    [super dealloc];
//}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [receivedData setLength:0];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [receivedData appendData:data];
   
    
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
//    [connection release];
//    [receivedData release];
//    
    self.errorCode=[[NSNumber alloc]initWithInteger:error.code];
    
    // inform the user
    //NSLog(@"Error - %@", [error localizedDescription]);
    
    if ( finishCallback )
    {
        finishCallback( self );
    }
    _finished=YES;
    
}
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if(receivedData)
    {
        self.dataString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        
        //self.dataString= [self.dataString substringFromIndex:8];
        
        if ( finishCallback )
        {
            finishCallback( self );
        }
    }
    
    _finished=YES;
}

- (void)cancel
{
        [theConnection cancel];
        
        _finished = YES;
}
@end
