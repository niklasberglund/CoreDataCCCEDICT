//
//  Entry+CoreDataProperties.h
//  
//
//  Created by Niklas Berglund on 12/19/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Entry.h"

NS_ASSUME_NONNULL_BEGIN

@interface Entry (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *added;
@property (nullable, nonatomic, retain) NSDate *modified;
@property (nullable, nonatomic, retain) Chinese_entry *inChinese;
@property (nullable, nonatomic, retain) English_entry *inEnglish;

@end

NS_ASSUME_NONNULL_END
