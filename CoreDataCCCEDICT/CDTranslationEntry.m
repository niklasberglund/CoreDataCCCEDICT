//
//  CDTranslationEntry.m
//  CC-CEDICT-downloader
//
//  Created by Niklas Berglund on 1/25/16.
//
//

#import "CDTranslationEntry.h"
#import "NSObject+description.h"

@implementation CDTranslationEntry

- (id)initWithTraditionalChinese:(NSString *)traditionalChinese simplifiedChinese:(NSString *)simplifiedChinese pinyin:(NSString *)pinyin englishTranslations:(NSArray<NSString *> *)englishTranslations
{
    self = [super init];
    
    if (self) {
        self.traditionalChinese = traditionalChinese;
        self.simplifiedChinese = simplifiedChinese;
        self.pinyin = pinyin;
        self.englishTranslations = englishTranslations;
    }
    
    return self;
}

+ (CDTranslationEntry *)translationEntryWithTraditionalChinese:(NSString *)traditionalChinese simplifiedChinese:(NSString *)simplifiedChinese pinyin:(NSString *)pinyin englishTranslations:(NSArray<NSString *> *)englishTranslations
{
    return [[CDTranslationEntry alloc] initWithTraditionalChinese:traditionalChinese simplifiedChinese:simplifiedChinese pinyin:pinyin englishTranslations:englishTranslations];
}

- (NSString *)description
{
    return [self descriptionWithMembers:@{
                                          @"traditionalChinese:": self.traditionalChinese,
                                          @"simplifiedChinese": self.simplifiedChinese,
                                          @"pinyin": self.pinyin,
                                          @"englishTranslations": self.englishTranslations
                                          }];
}

#pragma mark - NSManagedObject creation
- (NSManagedObject *)chineseManagedObjecInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSManagedObject *chineseManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Chinese_entry" inManagedObjectContext:managedObjectContext];
    [chineseManagedObject setValue:self.simplifiedChinese forKey:@"simplified"];
    [chineseManagedObject setValue:self.traditionalChinese forKey:@"traditional"];
    [chineseManagedObject setValue:self.pinyin forKey:@"pinyin"];
    
    return chineseManagedObject;
}

- (NSArray <NSManagedObject *>*)englishManagedObjectsInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSMutableArray <NSManagedObject *>*englishTranslations = [NSMutableArray new];
    
    for (NSString *english in self.englishTranslations) {
        NSManagedObject *englishManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"English_entry" inManagedObjectContext:managedObjectContext];
        [englishManagedObject setValue:english forKey:@"english"];
        
        [englishTranslations addObject:englishManagedObject];
    }
    
    return englishTranslations;
}

- (NSManagedObject *)entryManagedObjectWithChinese:(NSManagedObject *)chineseManagedObject english:(NSArray<NSManagedObject *> *)englishManagedObjects date:(NSDate *)databaseDate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSManagedObject *entryManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Entry" inManagedObjectContext:managedObjectContext];
    //[entryManagedObject setValue:[NSDate date] forKey:@"added"];
    [entryManagedObject setValue:databaseDate forKey:@"modified"];
    
    [entryManagedObject setValue:[NSSet setWithArray:englishManagedObjects] forKey:@"inEnglish"];
    [entryManagedObject setValue:chineseManagedObject forKey:@"inChinese"];
    
    return entryManagedObject;
}

@end
