//
//  DatabaseMethod.h
//  Calendar
//
//  Created by YingHong on 2014/8/27.
//
//
#import "FMDatabase.h"
#import <Foundation/Foundation.h>

@interface DatabaseMethod : NSObject
{
    
    BOOL success;
    NSError *error;
    NSFileManager * fm;
    NSArray * paths;
    NSString *documentsDirectory;
    NSString *writableDBPath;

}

-(void)setDatabase:(NSString*)aDataBaseName;
@end
