//
//  AVTableViewController.m
//  UITableSearth
//
//  Created by Anatoly Ryavkin on 12/06/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//

#import "AVTableViewController.h"

static NSString*identifierIntrestic = @"identifierIntrestic";
NSString*const didLoadArrayDateSortNotification = @"didLoadArrayDateSortNotification";
NSString*const keyInfoLoadDateSortNotification = @"keyInfoLoadDateSortNotification";

@interface AVTableViewController ()

@end

@implementation AVTableViewController

#pragma mark - init

-(id)init{
    self = [super init];
    if(self){
        NSMutableArray*array = [[NSMutableArray alloc]init];
        int countStudents = 100000; //((arc4random())%100000+100000);
        self.countStudents = countStudents;
        for(int i=0;i<countStudents;i++){
            [array addObject:[[AVStudent alloc]init]];
        }
        self.arrayStudentsIntrinsic = [NSArray arrayWithArray:array];
        self.modeAppear = modeAppearIntrinsic;
        self.tableView.backgroundColor = [[UIColor yellowColor]colorWithAlphaComponent:0.2];

    }
    return self;
}

#pragma mark - DidLoad

-(void)dealloc{
    NSNotificationCenter*nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSNotificationCenter*nc = [NSNotificationCenter defaultCenter];

    [nc addObserver:self selector:@selector(enableButtons:) name:didLoadArrayDateSortNotification object:nil];

    self.modeAppear = modeAppearIntrinsic;
    self.tableView.backgroundColor = [[UIColor yellowColor]colorWithAlphaComponent:0.2];

    self.navigationItem.title = @"Students at intrinsic list";
    UIBarButtonItem*buttonIntristic = [[UIBarButtonItem alloc]initWithTitle:@"Initial list" style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(actionForEnableIntristic:)];

    UIBarButtonItem*buttonSortFirstName = [[UIBarButtonItem alloc]initWithTitle:@"Sort firstName" style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(actionForEnableSortFirstName:)];

    UIBarButtonItem*buttonSortLastName = [[UIBarButtonItem alloc]initWithTitle:@"Sort lastName" style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(actionForEnableSortLastName:)];
    UIBarButtonItem*buttonSortDate = [[UIBarButtonItem alloc]initWithTitle:@"Sort Date" style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(actionForEnableSortDate:)];
    self.buttonSortDate = buttonSortDate;

    UIBarButtonItem*buttonSearth = [[UIBarButtonItem alloc]initWithTitle:@"SearchShow" style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(actionSearth:)];
    //buttonSearth.tintColor = [[UIColor purpleColor]colorWithAlphaComponent:0.8];

    NSArray*arrayRightBarButtons = [NSArray arrayWithObjects:buttonSearth,buttonIntristic, nil];
    NSArray*arrayLeftBarButtons = [NSArray arrayWithObjects:buttonSortFirstName,buttonSortLastName,buttonSortDate, nil];

    [self.navigationItem setLeftBarButtonItems:arrayLeftBarButtons];
    [self.navigationItem setRightBarButtonItems:arrayRightBarButtons];
    buttonSortDate.enabled = NO;

    self.buttonSearch = buttonSearth;

    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.searchBar = [[UISearchBar alloc]initWithFrame:self.tableView.tableHeaderView.bounds];
    self.searchBar.delegate = self;

    self.dictionaryNumberForIndexPathFirstName = [[NSMutableDictionary alloc]init];
    self.dictionaryNumberForIndexPathLastName = [[NSMutableDictionary alloc]init];
    self.dictionaryNumberForIndexPathDate = [[NSMutableDictionary alloc]init];

#pragma mark - queue and NSOperation

    NSBlockOperation*operation = [NSBlockOperation blockOperationWithBlock:^{
        dispatch_queue_t dispatch1 = dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0);
        dispatch_async(dispatch1, ^{
            self.arrayStudentsSortAtFirstName = [self sortAtFirstName:self.arrayStudentsIntrinsic];
            self.countSectionForFirstName = [self numberOfSectionsInForTypeArray:modeAppearSortFirstName];
        });
        dispatch_queue_t dispatch2 = dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0);
        dispatch_async(dispatch2, ^{
            self.arrayStudentsSortAtLastName = [self sortAtLastName:self.arrayStudentsIntrinsic];
            self.countSectionForLastName = [self numberOfSectionsInForTypeArray:modeAppearSortLastName];
        });
        dispatch_queue_t dispatch3 = dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0);
        dispatch_async(dispatch3, ^{
            self.arrayStudentsSortAtDateBirth = [self sortAtDateBirth:self.arrayStudentsIntrinsic];
            //buttonSortDate.enabled = YES; //- works, but dont reload the button view (metod invokes from backgraund)
            self.countSectionForDate = [self numberOfSectionsInForTypeArray:modeAppearSortDateBirth];
        });
    }];
    NSOperationQueue*nsOpQ=[[NSOperationQueue alloc]init];
    [nsOpQ addOperations:@[operation] waitUntilFinished:YES];
}

-(void)enableButtons:(NSNotification*)notification{
    // !!! dont work (dont main theard) from assign theard !!!!!!!!!!!!!!!!!!!!!!
    //self.buttonSortDate.enabled = YES; -error!!! This application is modifying the autolayout engine from a background thread after the engine was accessed from the main thread.

        //works with translation to the main theard following :
    NSLog(@"enable buttons sortDate and search");

    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        self.buttonSortDate.enabled = YES;
        self.buttonSearch.tintColor = [[UIColor purpleColor]colorWithAlphaComponent:0.8];
    });
    NSString*string =  [notification.userInfo objectForKey:keyInfoLoadDateSortNotification];
    NSLog(@"%@",string);
}

- (void)viewDidAppear:(BOOL)animated{

}

#pragma mark - Action

-(void)actionForEnableIntristic:(UIBarButtonItem*)sender{

}

-(void)actionForEnableSortFirstName:(UIBarButtonItem*)sender{
    [self searchBarCancelButtonClicked:self.searchBar];
    self.numberStudent = 0;
    self.modeAppear = modeAppearSortFirstName;
    [self.tableView reloadData];

}

-(void)actionForEnableSortLastName:(UIBarButtonItem*)sender{
    [self searchBarCancelButtonClicked:self.searchBar];
    self.numberStudent = 0;
    self.modeAppear = modeAppearSortLastName;
    [self.tableView reloadData];


}

-(void)actionForEnableSortDate:(UIBarButtonItem*)sender{
    [self searchBarCancelButtonClicked:self.searchBar];
    self.numberStudent = 0;
    self.modeAppear = modeAppearSortDateBirth;
    [self.tableView reloadData];


}

-(void)actionSearth:(UIBarButtonItem*)sender{

    if([sender.title isEqual: @"SearchShow"]){
        sender.title = @"SearchDown";
        sender.tintColor = [[UIColor purpleColor]colorWithAlphaComponent:0.8];
        self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 50)];
        self.searchBar = [[UISearchBar alloc]initWithFrame:self.tableView.tableHeaderView.bounds];
        self.searchBar.delegate = self;
        [self.tableView.tableHeaderView addSubview:self.searchBar];
        [self.searchBar becomeFirstResponder];
    }else{
        sender.title = @"SearchShow";
        sender.tintColor = [[UIColor blueColor]colorWithAlphaComponent:0.8];
        self.tableView.tableHeaderView = nil;
    }

}

#pragma mark - Sorts

-(NSArray*)sortAtFirstName:(NSArray*)array{
    NSSortDescriptor*descriptorFirstName = [[NSSortDescriptor alloc]initWithKey:@"firstName" ascending:YES comparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
       return [obj1 compare:obj2];
    }];
    NSSortDescriptor*descriptorLastName = [[NSSortDescriptor alloc]initWithKey:@"lastName" ascending:YES comparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSSortDescriptor*descriptorDate = [[NSSortDescriptor alloc]initWithKey:@"dateBirth" ascending:YES comparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSArray*arrayDescriptros = @[descriptorFirstName,descriptorLastName,descriptorDate];
    NSLog(@"ending metod for sorting the base at firstName");
    return [self.arrayStudentsIntrinsic sortedArrayUsingDescriptors:arrayDescriptros];
}

-(NSArray*)sortAtLastName:(NSArray*)array{
    NSSortDescriptor*descriptorFirstName = [[NSSortDescriptor alloc]initWithKey:@"firstName" ascending:YES comparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSSortDescriptor*descriptorLastName = [[NSSortDescriptor alloc]initWithKey:@"lastName" ascending:YES comparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSSortDescriptor*descriptorDate = [[NSSortDescriptor alloc]initWithKey:@"dateBirth" ascending:YES comparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSArray*arrayDescriptros = @[descriptorLastName,descriptorDate,descriptorFirstName];
    NSLog(@"ending metod for sorting the base at lastName");
    return [self.arrayStudentsIntrinsic sortedArrayUsingDescriptors:arrayDescriptros];
}

-(NSArray*)sortAtDateBirth:(NSArray*)array{
    NSSortDescriptor*descriptorDate = [[NSSortDescriptor alloc]initWithKey:@"dateBirth" ascending:YES comparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2){
        NSCalendar*calendar = [NSCalendar currentCalendar];
        NSInteger mont1 = [calendar components:NSCalendarUnitMonth fromDate:obj1].month;
        NSInteger mont2 = [calendar components:NSCalendarUnitMonth fromDate:obj2].month;
        NSInteger year1 = [calendar components:NSCalendarUnitYear fromDate:obj1].year;
        NSInteger year2 = [calendar components:NSCalendarUnitYear fromDate:obj2].year;
        NSInteger day1 = [calendar components:NSCalendarUnitDay fromDate:obj1].day;
        NSInteger day2 = [calendar components:NSCalendarUnitDay fromDate:obj2].day;

        if(mont1 < mont2)
            return NSOrderedAscending;
        if(mont1 > mont2)
            return NSOrderedDescending;
        if(mont1 == mont2){
            if(year1 < year2)
                return NSOrderedAscending;
            if(year1 > year2)
                return NSOrderedDescending;
            if(year1 == year2){
                if(day1 < day2)
                    return NSOrderedAscending;
                if(day1>day2)
                    return NSOrderedDescending;
                else
                    return NSOrderedSame;
            }
        }
        return NSOrderedSame;
    }];


    NSArray*arrayDescriptros = @[descriptorDate];
    NSArray*arrResult = [NSArray arrayWithArray:[self.arrayStudentsIntrinsic sortedArrayUsingDescriptors:arrayDescriptros]];
    NSLog(@"ending metod for sorting the base at date");
    //self.buttonSortDate.enabled = YES; - works, but dont reload the button view (metod invokes from backgraund)

    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        //self.buttonSortDate.enabled = YES;
    });

    return arrResult;
}

#pragma mark - UISearhBarDelegate

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    //self.modePrevious = self.modeAppear;
    //self.modeAppear = modeAppearTableSearth;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    self.buttonSearch.title = @"SearchShow";
    self.buttonSearch.tintColor = [[UIColor blueColor]colorWithAlphaComponent:0.8];
    self.tableView.tableHeaderView = nil;
    self.modeAppear = self.modePrevious;
    [self.tableView reloadData];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    [self.currentOperation cancel];

    self.currentOperation = [NSBlockOperation blockOperationWithBlock:^{
        self.modeAppear = modeAppearTableSearth;
        NSMutableArray*arraySearch = [[NSMutableArray alloc]init];
        NSInteger length = searchText.length;
        for(AVStudent*student in self.arrayStudentsSortAtFirstName){
            if(student.firstName.length >= length && length>0){
                NSString*stringTemp = [student.firstName substringWithRange:NSMakeRange(0, length)];
                if([searchText isEqualToString:stringTemp]){
                    [arraySearch addObject:student];
                }
            }
        }
        for(AVStudent*student in self.arrayStudentsSortAtLastName){
            if(student.lastName.length >= length && length>0){
                NSString*stringTemp = [student.lastName substringWithRange:NSMakeRange(0, length)];
                if([searchText isEqualToString:stringTemp]){
                    [arraySearch addObject:student];
                }
            }
        }
        for(AVStudent*student in self.arrayStudentsSortAtDateBirth){
            if(student.dateBirthString.length >= length){
                NSString*stringTemp = [student.dateBirthString substringWithRange:NSMakeRange(0, length)];
                if([searchText isEqualToString:stringTemp] && length>0){
                    [arraySearch addObject:student];
                }
            }
        }
        self.arrayStudentsSearch = [NSArray arrayWithArray:arraySearch];
        NSLog(@"search=%@",searchText);
    }];

    [self.currentOperation start];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    switch (self.modeAppear) {
        case modeAppearSortFirstName:
            return self.arrayForIndexBarFirstName;
            break;
        case modeAppearSortLastName:
            return self.arrayForIndexBarLastName;
            break;
        case modeAppearSortDateBirth:
            return self.arrayForIndexBarDate;
            break;
        case modeAppearIntrinsic:
            return 0;
            break;
        case modeAppearTableSearth:
            return 0;
            break;
        default:  return 0;
            break;
    }
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}

#pragma mark - count sections

- (NSInteger)numberOfSectionsInForTypeArray:(ModeAppear)mode{
    NSMutableArray*arrayFirstSimbol = [[NSMutableArray alloc]init];
    int sec = -1;
    int row = -1;
    NSNotificationCenter*nc = [NSNotificationCenter defaultCenter];
    NSDictionary*dictInfo;
    switch (mode) {
        case modeAppearSortFirstName:
            for(AVStudent*student in self.arrayStudentsSortAtFirstName){
                NSString*stringFirstSimbol = [student.firstName substringWithRange:NSMakeRange(0, 1)];
                if(![arrayFirstSimbol containsObject:stringFirstSimbol]){
                    [arrayFirstSimbol addObject:stringFirstSimbol];
                    sec++;row=-1;
                }
                row++;
                student.indexPath = [NSIndexPath indexPathForRow:row inSection:sec];
                [self.dictionaryNumberForIndexPathFirstName setObject:student forKey:[NSIndexPath indexPathForRow:row inSection:sec]];
            }
            self.arrayForIndexBarFirstName = [NSArray arrayWithArray:arrayFirstSimbol];
            return arrayFirstSimbol.count;
            break;

        case modeAppearSortLastName:
            for(AVStudent*student in self.arrayStudentsSortAtLastName){
                NSString*stringFirstSimbol = [student.lastName substringWithRange:NSMakeRange(0, 1)];
                if(![arrayFirstSimbol containsObject:stringFirstSimbol]){
                    [arrayFirstSimbol addObject:stringFirstSimbol];
                    sec++;row=-1;
                }
                row++;
                student.indexPath = [NSIndexPath indexPathForRow:row inSection:sec];
                [self.dictionaryNumberForIndexPathLastName setObject:student forKey:[NSIndexPath indexPathForRow:row inSection:sec]];
            }
            self.arrayForIndexBarLastName = [NSArray arrayWithArray:arrayFirstSimbol];
            return arrayFirstSimbol.count;
            break;

        case modeAppearSortDateBirth:
            for(AVStudent*student in self.arrayStudentsSortAtDateBirth){
                NSString*stringFourSimbol = [student.dateBirthString substringWithRange:NSMakeRange(3, 3)];
                if(![arrayFirstSimbol containsObject:stringFourSimbol]){
                    [arrayFirstSimbol addObject:stringFourSimbol];
                    sec++;row=-1;
                }
                row++;
                student.indexPath = [NSIndexPath indexPathForRow:row inSection:sec];
                [self.dictionaryNumberForIndexPathDate setObject:student forKey:[NSIndexPath indexPathForRow:row inSection:sec]];
            }
            self.arrayForIndexBarDate = [NSArray arrayWithArray:arrayFirstSimbol];

            dictInfo = [NSDictionary dictionaryWithObject:@"infoNotification: ending block for sorting the base at date" forKey:keyInfoLoadDateSortNotification];
            [nc postNotificationName:didLoadArrayDateSortNotification object:nil userInfo:dictInfo];

            return arrayFirstSimbol.count;
            break;
        case modeAppearIntrinsic:
            return 1;
            break;
        case modeAppearTableSearth:
            return 1;
            break;
        default:  return 1;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    switch (self.modeAppear) {
        case modeAppearSortFirstName:
            return self.countSectionForFirstName;
            break;
        case modeAppearSortLastName:
            return self.countSectionForLastName;
            break;
        case modeAppearSortDateBirth:
            return self.countSectionForDate;
            break;
        case modeAppearIntrinsic:
            return 1;
            break;
        case modeAppearTableSearth:
            return 1;
            break;
        default:  return 1;
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger countRow=0;
    if(self.modeAppear == modeAppearIntrinsic){
        countRow = self.arrayStudentsIntrinsic.count;
    }else if(self.modeAppear == modeAppearSortFirstName){
        NSString*simbolCurent = [self.arrayForIndexBarFirstName objectAtIndex:section];
        for(AVStudent*student in self.arrayStudentsSortAtFirstName){
            if ([[student.firstName substringWithRange:NSMakeRange(0, 1)] isEqualToString:simbolCurent])
                countRow++;
        }
    }else if(self.modeAppear == modeAppearSortLastName){
        NSString*simbolCurent = [self.arrayForIndexBarLastName objectAtIndex:section];
        for(AVStudent*student in self.arrayStudentsSortAtLastName){
            if ([[student.lastName substringWithRange:NSMakeRange(0, 1)] isEqualToString:simbolCurent])
                countRow++;
        }
    }else if(self.modeAppear == modeAppearSortDateBirth){
        NSString*simbolCurent = [self.arrayForIndexBarDate objectAtIndex:section];
        for(AVStudent*student in self.arrayStudentsSortAtDateBirth){
            if ([[student.dateBirthString substringWithRange:NSMakeRange(3, 3)] isEqualToString:simbolCurent])
                countRow++;
        }
    }else if(self.modeAppear == modeAppearTableSearth){
        countRow = self.arrayStudentsSearch.count;
    }
        return countRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

     if(self.modeAppear == modeAppearIntrinsic){
        UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:identifierIntrestic];
        if(!cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifierIntrestic];
        }
        AVStudent*student = [self.arrayStudentsIntrinsic objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName,student.lastName];
        cell.detailTextLabel.text = student.dateBirthString;
        cell.contentView.backgroundColor = [[UIColor greenColor]colorWithAlphaComponent:0.05];
        return cell;
    }else if(self.modeAppear == modeAppearSortFirstName){
         UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:identifierIntrestic];
         if(!cell){
             cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifierIntrestic];
         }
         AVStudent*student;
         student = [self.dictionaryNumberForIndexPathFirstName objectForKey:indexPath];
         self.numberStudent++;
         cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName,student.lastName];
         cell.detailTextLabel.text = student.dateBirthString;
         cell.contentView.backgroundColor = [[UIColor greenColor]colorWithAlphaComponent:0.05];
         return cell;
    }else if(self.modeAppear == modeAppearSortLastName){
        UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:identifierIntrestic];
        if(!cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifierIntrestic];
        }
        AVStudent*student;
        student = [self.dictionaryNumberForIndexPathLastName objectForKey:indexPath];
        self.numberStudent++;
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName,student.lastName];
        cell.detailTextLabel.text = student.dateBirthString;
        cell.contentView.backgroundColor = [[UIColor greenColor]colorWithAlphaComponent:0.05];
        return cell;
    }else if(self.modeAppear == modeAppearSortDateBirth){
        UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:identifierIntrestic];
        if(!cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifierIntrestic];
        }
        AVStudent*student;
        student = [self.dictionaryNumberForIndexPathDate objectForKey:indexPath];
        self.numberStudent++;
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName,student.lastName];
        cell.detailTextLabel.text = student.dateBirthString;
        cell.contentView.backgroundColor = [[UIColor greenColor]colorWithAlphaComponent:0.05];
        return cell;
    }else if(self.modeAppear == modeAppearTableSearth){
        UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:identifierIntrestic];
        if(!cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifierIntrestic];
        }
        AVStudent*student = [self.arrayStudentsSearch objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName,student.lastName];
        cell.detailTextLabel.text = student.dateBirthString;
        cell.contentView.backgroundColor = [[UIColor greenColor]colorWithAlphaComponent:0.05];
        return cell;
    }
    return nil;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (self.modeAppear) {
        case modeAppearSortFirstName:
            return [self.arrayForIndexBarFirstName objectAtIndex:section];
            break;
        case modeAppearSortLastName:
            return [self.arrayForIndexBarLastName objectAtIndex:section];
            break;
        case modeAppearSortDateBirth:
            return [self.arrayForIndexBarDate objectAtIndex:section];
            break;
        case modeAppearIntrinsic:
            return nil;
            break;
        case modeAppearTableSearth:
            return nil;
            break;
        default:  return nil;
            break;
    }
    return [self.arrayForIndexBarFirstName objectAtIndex:section];
}

@end
