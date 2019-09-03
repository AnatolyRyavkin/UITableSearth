//
//  AVStudent.m
//  UITableSearth
//
//  Created by Anatoly Ryavkin on 12/06/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//

#import "AVStudent.h"

@implementation AVStudent

-(NSString*)dataBirthChangeFromDateInString:(NSDate*)date{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"dd/MMM/yyyy";
    return [formatter stringFromDate:date];
}

-(NSDate*)randomDateBirth{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"dd/MMM/yyyy";
    NSDate*dateBirthBegin =[formatter dateFromString:@"01.Jan.1970"];
    NSDate*dateBirthEnd =[formatter dateFromString:@"01.Jan.2003"];
    NSTimeInterval intervalDateBirth = [dateBirthEnd timeIntervalSinceDate:dateBirthBegin];
    NSTimeInterval randomCountSecAtDatsBirthBegin = (NSTimeInterval)((arc4random()*10000) % (NSUInteger)intervalDateBirth);
    NSDate*dateBirth = [[NSDate alloc]initWithTimeInterval:randomCountSecAtDatsBirthBegin sinceDate:dateBirthBegin];
    return dateBirth;
}

-(id)init{
    self = [super init];
    if(self){

        self.dateBirth = [self randomDateBirth];
        self.dateBirthString = [self dataBirthChangeFromDateInString:self.dateBirth];

        NSArray*arrayGlasChar = [[NSArray alloc]initWithObjects:@"y",@"u",@"a",@"o",@"i",@"a",@"u",@"o",@"i",@"j",nil];

        NSArray*arraySoglasChar = [[NSArray alloc]initWithObjects:     @"q",@"w",@"r",@"t",@"p",@"s",@"d",@"f",@"g",@"h",@"k",@"l",@"z",@"x",@"c",@"v",@"b",@"n",@"m",@"q",@"w",
                                   @"r",@"t",@"p",@"s",@"d",@"f",@"g",@"h",@"k",@"l",@"x",@"c",@"v",@"b",@"n",@"m",@"q",@"r",@"t",@"p",@"s",@"d",@"f",@"g",@"h",@"k",@"l",
                                   @"z",@"x",@"c",@"v",@"b",@"n",@"m",@"r",@"t",@"p",@"s",@"d",@"f",@"g",@"h",@"k",@"l",@"z",@"x",@"c",@"v",@"b",@"n",@"m",@"r",@"t",
                                   @"p",@"s",@"d",@"f",@"g",@"h",@"k",@"l",@"c",@"v",@"b",@"n",@"m",nil];

        NSMutableString*firstName = [[NSMutableString alloc]init];
        int lit = arc4random();
        for(int i=0;i<(arc4random()%6+4);i++){
            NSString*strChar = (lit%2==0) ? [arrayGlasChar objectAtIndex:arc4random()% (arrayGlasChar.count-1)] :
                                                                                                [arraySoglasChar objectAtIndex:(arc4random()%
                                                                                                (arraySoglasChar.count-1))];
            lit++;
            if(i==0)
                [firstName appendString:[strChar uppercaseString]];
            else
                [firstName appendString:strChar];
        }

        NSMutableString*lastName = [[NSMutableString alloc]init];
        for(int i=0;i<(arc4random()%6+4);i++){
            NSString*strChar = (arc4random()%2==0) ? [arrayGlasChar objectAtIndex:(arc4random()%(arrayGlasChar.count-1))] :  [arraySoglasChar objectAtIndex:(arc4random()%(arraySoglasChar.count-1))];
            if(i==0)
                [lastName appendString:[strChar uppercaseString]];
            else
                [lastName appendString:strChar];
        }
        if(arc4random()%2==0)
            [lastName appendString:@"in"];
        else
            [lastName appendString:@"of"];
        self.lastName = lastName;
        self.firstName = firstName;

    }
    return self;
}

@end
