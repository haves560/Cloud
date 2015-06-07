//
//  RBCustomDatePickerView.h
//  RBCustomDateTimePicker
//  e-mail:rbyyy924805@163.com
//  Created by renbing on 3/17/14.
//  Copyright (c) 2014 renbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXSCycleScrollView.h"

@interface RBCustomDatePickerView : UIView <MXSCycleScrollViewDatasource,MXSCycleScrollViewDelegate,UITableViewDataSource, UITableViewDelegate
>
{
    UITableView *tableview;
    
    BOOL success;
    NSError *error;
    NSFileManager * fm;
    NSArray * paths;
    NSString *documentsDirectory;
    NSString *writableDBPath;

    NSMutableArray * title_list;
    NSMutableArray * name_list;
    NSMutableArray * username_list;
    NSMutableArray * detail_list;
    NSMutableArray * date_list;
    NSMutableArray * time_list;
    NSMutableArray * city_list;
    NSMutableArray * area_list;
    NSMutableArray * adderss_list;
    NSMutableArray * image_list;
    NSMutableArray * data_id_list;
}

@end
