//
//  DatabaseMethod.m
//  Calendar
//
//  Created by YingHong on 2014/8/27.
//
//

#import "DatabaseMethod.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@implementation DatabaseMethod

-(void)setDatabase:(NSString*)aDataBaseName
{
//    NSFileManager *fmdb = [NSFileManager defaultManager];
//    
//    NSString *documentspath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//    
//    NSString *db_path =[documentspath stringByAppendingPathComponent:aDataBaseName];
//    
//    if ( ! [fmdb fileExistsAtPath:db_path] )
//    {
//        NSString *source_path = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:aDataBaseName];
//        
//        if ( [fmdb copyItemAtPath:source_path toPath:db_path error:nil] )
//        {
//            NSLog(@"ok");
//        }
//    }
//    
//    //開啟fmdb
//    NSMutableArray *_items=[NSMutableArray arrayWithCapacity:0];
//    fm=[NSFileManager defaultManager];
//    //    paths=NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
//    //    documentsDirectory=[paths objectAtIndex:0];
//    NSString *documents_path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//    
//    writableDBPath=db_path;
//    
//    success=[fm fileExistsAtPath:writableDBPath];
//    
//    if (!success)
//    {
//        NSString *de=[[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:aDataBaseName];
//        success=[fm copyItemAtPath:de toPath:writableDBPath error:nil];
//        
//        if (!success)
//        {
//            NSLog(@"error");
//        }
//        
//        FMDatabase *db=[FMDatabase databaseWithPath:writableDBPath];
//        
//        if([db open])
//            
//        {
//            [db setShouldCacheStatements:YES];
//            NSString * sqlQuery = [NSString stringWithFormat:@"SELECT city_id FROM city_table where territory_name =ddd"];
//            FMResultSet *rs=[db executeQuery:sqlQuery];
//            
//            while ([rs next])
//                
//            {
//                
//                NSString *_cityId = [rs stringForColumn:@"city_id"];
//                NSLog(@"%@",_cityId);
//                
//            }
//            
//            [db close];
//            [rs close];
//            
//        }
//        
//        else
//            
//        {
//            NSLog(@"無法開啓");
//        }
//
//    }
}

@end
