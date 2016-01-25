//
//  CDTranslationEntry.m
//  CC-CEDICT-downloader
//
//  Created by Niklas Berglund on 1/25/16.
//
//

#import "CDTranslationEntry.h"

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

@end