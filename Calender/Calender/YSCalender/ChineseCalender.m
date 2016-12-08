//
//  ChineseCalender.m
//  Calender
//
//  Created by 杨森 on 16/6/22.
//  Copyright © 2016年 com.sitemap. All rights reserved.
//

#import "ChineseCalender.h"

@interface ChineseCalender()

@property(nonatomic)NSArray *chineseDayName; //农历日期名
@property(nonatomic)NSArray *chineseMonName; //农历月份名

@end
@implementation ChineseCalender
static ChineseCalender *chineseCalender = nil;

//农历数据
static const int nongliData[100] = {2635,333387,1701,1748,267701,694,2391,133423,1175,396438
    ,3402,3749,331177,1453,694,201326,2350,465197,3221,3402
    ,400202,2901,1386,267611,605,2349,137515,2709,464533,1738
    ,2901,330421,1242,2651,199255,1323,529706,3733,1706,398762
    ,2741,1206,267438,2647,1318,204070,3477,461653,1386,2413
    ,330077,1197,2637,268877,3365,531109,2900,2922,398042,2395
    ,1179,267415,2635,661067,1701,1748,398772,2742,2391,330031
    ,1175,1611,200010,3749,527717,1452,2742,332397,2350,3222
    ,268949,3402,3493,133973,1386,464219,605,2349,334123,2709
    ,2890,267946,2773,592565,1210,2651,395863,1323,2707,265877};

//公历每月前面的天数
static const int monthAdd[12] = {0,31,59,90,120,151,181,212,243,273,304,334};

+ (id)shareChineseCalender{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        chineseCalender = [[ChineseCalender alloc]init];
    });
    return chineseCalender;
}

- (instancetype)init{
    if (self = [super init]) {
        self.chineseDayName =  @[@"*",@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",@"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十"];
        self.chineseMonName =  @[@"*",@"正",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"腊",@"*"];
    }
    return self;
}
- (NSDictionary *)getChineseCalenderWithDateComponents:(NSDateComponents *)dateComplents{

    NSString *interDayStr    = [self internationHolidayWithDateComponents:dateComplents];
    NSDictionary *holidayDic = [self chineseHolidayWithDateComponents:dateComplents whileNilReturnChineseDay:YES];
    NSString *chineseDayStr  = [holidayDic objectForKey:ChineseCalenderHolidayKeyHoliday];
    NSNumber *isHoliday      = [holidayDic objectForKey:ChineseCalenderHolidayKeyISHoliday];
    if (isHoliday.integerValue == 0) {
        if (interDayStr) {
            return @{ChineseCalenderHolidayKeyHoliday:interDayStr,ChineseCalenderHolidayKeyISHoliday:@(1)};
        }
        else{
            return @{ChineseCalenderHolidayKeyHoliday:chineseDayStr,ChineseCalenderHolidayKeyISHoliday:@(0)};
        }
    }
    else{
        return @{ChineseCalenderHolidayKeyHoliday:chineseDayStr,ChineseCalenderHolidayKeyISHoliday:@(1)};
    }
    
}

// 获取国际节假日
- (NSString *)internationHolidayWithDateComponents:(NSDateComponents *)dateComponents{

    NSString *chineseDay = [NSString stringWithFormat:@"%lu-%lu",dateComponents.month,dateComponents.day];
    NSDictionary *chineseHolidayDic = [NSArray arrayWithContentsOfFile:[self chineseHolidayPlistPath]].firstObject;
    return [chineseHolidayDic objectForKey:chineseDay];
}

// 获取中国传统节假日
- (NSString *)chineseHolidayWithDateComponents:(NSDateComponents *)dateComponents{
    NSDictionary *dic = [self chineseHolidayWithDateComponents:dateComponents whileNilReturnChineseDay:NO];
    if ([dic isKindOfClass:[NSDictionary class]]) {
       return [dic objectForKey:ChineseCalenderHolidayKeyHoliday];
    }
    return nil;
}
- (NSDictionary *)chineseHolidayWithDateComponents:(NSDateComponents *)dateComponents whileNilReturnChineseDay:(BOOL)isReturn{
    // 农历月份
    NSString *chineseMonthDay       = [self chineseCalenderWithDateComponents:dateComponents];
    NSString *chineseDay            = [chineseMonthDay componentsSeparatedByString:@"-"].lastObject;
    NSDictionary *chineseHolidayDic = [NSArray arrayWithContentsOfFile:[self chineseHolidayPlistPath]].lastObject;
    NSString *chineseHoliday        = [chineseHolidayDic objectForKey:chineseMonthDay];
    NSNumber *isHoliday;
    if (chineseHoliday) {
        isHoliday = @(1);
        chineseDay = chineseHoliday;
    }
    else{
        isHoliday = @(0);
    }
    if (isReturn) {
        return @{ChineseCalenderHolidayKeyHoliday:chineseDay,ChineseCalenderHolidayKeyISHoliday:isHoliday};
    }
    else{
        if (chineseHoliday) {
            return @{ChineseCalenderHolidayKeyHoliday:chineseHoliday,ChineseCalenderHolidayKeyISHoliday:isHoliday};
        }
        else{
            return nil;
        }
    }
}

- (NSString *)chineseHolidayPlistPath{
    return [[NSBundle mainBundle]pathForResource:@"ChineseHolidayList" ofType:@"plist"];
}

- (NSString *)chineseCalenderWithDateComponents:(NSDateComponents *)dateComponents{
    
    NSInteger year  = dateComponents.year;
    NSInteger month = dateComponents.month;
    NSInteger day   = dateComponents.day;
    
    static NSInteger nTheDate,nIsEnd,m,k,n,i,nBit;
    
    //计算到初始时间1921年2月8日的天数：1921-2-8(正月初一)
    nTheDate = (year - 1921) * 365 + (year - 1921) / 4 + day + monthAdd[month - 1] - 38;
    
    if((!(year % 4)) && (month > 2))
        nTheDate = nTheDate + 1;
    
    //计算农历天干、地支、月、日
    nIsEnd = 0;
    m = 0;
    while(nIsEnd != 1)
    {
        if(nongliData[m] < 4095)
            k = 11;
        else
            k = 12;
        n = k;
        while(n>=0)
        {
            //获取nongliData(m)的第n个二进制位的值
            nBit = nongliData[m];
            for(i=1;i<n+1;i++)
                nBit = nBit/2;
            
            nBit = nBit % 2;
            
            if (nTheDate <= (29 + nBit))
            {
                nIsEnd = 1;
                break;
            }
            
            nTheDate = nTheDate - 29 - nBit;
            n = n - 1;
        }
        if(nIsEnd)
            break;
        m = m + 1;
    }
    year = 1921 + m;
    month = k - n + 1;
    day = nTheDate;
    if (k == 12)
    {
        if (month == nongliData[m] / 65536 + 1)
            month = 1 - month;
        else if (month > nongliData[m] / 65536 + 1)
            month = month - 1;
    }
    
    //生成农历月
    NSString *sNongliMonth;
    if (month < 1){
        sNongliMonth = [NSString stringWithFormat:@"闰%@",(NSString *)[_chineseMonName objectAtIndex:-1 * month]];
    }else{
        sNongliMonth = (NSString *)[_chineseMonName objectAtIndex:month];
    }
    
    //生成农历日
    NSString *sNongliDay = [_chineseDayName objectAtIndex:day];
    
    //合并
    NSString *lunarDate = [NSString stringWithFormat:@"%@-%@",sNongliMonth,sNongliDay];
    
    return lunarDate;
}

@end
