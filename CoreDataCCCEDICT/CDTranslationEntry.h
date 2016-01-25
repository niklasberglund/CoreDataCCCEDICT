//
//  CDTranslationEntry.h
//  CC-CEDICT-downloader
//
//  Created by Niklas Berglund on 1/25/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "English_entry.h"

@interface CDTranslationEntry : NSObject

@property (nonatomic, strong) NSString *traditionalChinese;
@property (nonatomic, strong) NSString *simplifiedChinese;
@property (nonatomic, strong) NSString *pinyin;
@property (nonatomic, strong) NSArray<NSString *> *englishTranslations;

- (id)initWithTraditionalChinese:(NSString *)traditionalChinese simplifiedChinese:(NSString *)simplifiedChinese pinyin:(NSString *)pinyin englishTranslations:(NSArray<NSString *> *)englishTranslations;
+ (CDTranslationEntry *)translationEntryWithTraditionalChinese:(NSString *)traditionalChinese simplifiedChinese:(NSString *)simplifiedChinese pinyin:(NSString *)pinyin englishTranslations:(NSArray<NSString *> *)englishTranslations;


#pragma mark - creation of NSManagedObjects for this translation
- (NSManagedObject *)chineseManagedObject;
- (NSArray<English_entry *> *)englishManagedObjects;
- (NSManagedObject *)entryManagedObjectWithChinese:(NSManagedObject *)chineseManagedObject english:(NSArray<English_entry *> *)englishManagedObjects;

@end
