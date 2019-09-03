//
//  AVStudent.h
//  UITableSearth
//
//  Created by Anatoly Ryavkin on 12/06/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AVStudent : NSObject

@property NSString*firstName;
@property NSString*lastName;
@property NSDate*dateBirth;
@property NSString*dateBirthString;

@property NSIndexPath*indexPath;

-(NSString*)dataBirthChangeFromDateInString:(NSDate*)date;


@end

NS_ASSUME_NONNULL_END
