//
//  Chinese_entry+CoreDataProperties.h
//  
//
//  Created by Niklas Berglund on 12/19/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Chinese_entry.h"

NS_ASSUME_NONNULL_BEGIN

@interface Chinese_entry (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *pinyin;
@property (nullable, nonatomic, retain) NSString *simplified;
@property (nullable, nonatomic, retain) NSString *traditional;
@property (nullable, nonatomic, retain) NSManagedObject *inEntry;

@end

NS_ASSUME_NONNULL_END
