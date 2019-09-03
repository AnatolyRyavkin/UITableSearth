//
//  AVTableViewController.h
//  UITableSearth
//
//  Created by Anatoly Ryavkin on 12/06/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVStudent.h"
#import "AVSearchControllerViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum{
    modeAppearIntrinsic = 0,
    modeAppearSortFirstName,
    modeAppearSortLastName,
    modeAppearSortDateBirth,
    modeAppearTableSearth
}ModeAppear;

extern NSString*const didLoadArrayDateSortNotification;
extern NSString*const keyInfoLoadDateSortNotification;

@interface AVTableViewController : UITableViewController<UISearchBarDelegate>

@property (weak) UIBarButtonItem *buttonSortDate;

@property NSInteger countStudents;

@property NSInteger numberStudent;

@property ModeAppear modeAppear;

@property ModeAppear modePrevious;

@property NSArray*arrayStudentsIntrinsic;
@property NSArray*arrayStudentsSortAtFirstName;
@property NSArray*arrayStudentsSortAtLastName;
@property NSArray*arrayStudentsSortAtDateBirth;

@property NSArray*arrayStudentsSearch;

@property NSArray*arrayForAppear;

@property NSArray*arrayForIndexBar;

@property NSArray*arrayForIndexBarFirstName;
@property NSArray*arrayForIndexBarLastName;
@property NSArray*arrayForIndexBarDate;

@property NSMutableDictionary*dictionaryNumberForIndexPathFirstName;
@property NSMutableDictionary*dictionaryNumberForIndexPathLastName;
@property NSMutableDictionary*dictionaryNumberForIndexPathDate;

@property NSInteger countSectionForFirstName;
@property NSInteger countSectionForLastName;
@property NSInteger countSectionForDate;

@property UIBarButtonItem*buttonSearch;

@property UISearchBar*searchBar;

@property NSOperation*currentOperation;

@property NSBlockOperation*enableButtonOperation;

-(NSArray*)sortAtFirstName:(NSArray*)array;
-(NSArray*)sortAtLastName:(NSArray*)array;
-(NSArray*)sortAtDateBirth:(NSArray*)array;


@end

NS_ASSUME_NONNULL_END
