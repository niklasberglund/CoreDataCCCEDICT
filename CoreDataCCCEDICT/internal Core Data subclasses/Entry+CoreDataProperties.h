//
//  Entry+CoreDataProperties.h
//  
//
//  Created by Niklas Berglund on 1/24/16.
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
@property (nullable, nonatomic, retain) NSSet<English_entry *> *inEnglish;

@end

@interface Entry (CoreDataGeneratedAccessors)

- (void)addInEnglishObject:(English_entry *)value;
- (void)removeInEnglishObject:(English_entry *)value;
- (void)addInEnglish:(NSSet<English_entry *> *)values;
- (void)removeInEnglish:(NSSet<English_entry *> *)values;

@end

NS_ASSUME_NONNULL_END
