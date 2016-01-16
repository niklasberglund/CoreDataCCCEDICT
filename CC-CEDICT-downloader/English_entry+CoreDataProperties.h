//
//  English_entry+CoreDataProperties.h
//  
//
//  Created by Niklas Berglund on 12/19/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "English_entry.h"

NS_ASSUME_NONNULL_BEGIN

@interface English_entry (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *english;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *inEntry;

@end

@interface English_entry (CoreDataGeneratedAccessors)

- (void)addInEntryObject:(NSManagedObject *)value;
- (void)removeInEntryObject:(NSManagedObject *)value;
- (void)addInEntry:(NSSet<NSManagedObject *> *)values;
- (void)removeInEntry:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
