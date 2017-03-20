//
//  UIColor+UIColor.m
//  DashBoard
//
//  Created by totyu3 on 17/2/17.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import "UIColor+UIColor.h"

@implementation UIColor (UIColor)
+ (UIColor*) colorWithHex:(NSString*)hexValue alpha:(CGFloat)alphaValue{
    
    if (![hexValue isEqualToString:@""]) {

        NSString *hexstr = [[hexValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
        if ([hexstr hasPrefix:@"#"])
        {
            hexstr = [hexValue substringFromIndex:1];
        }

        NSRange range;
        range.location = 0;
        range.length = 2;
        //r
        NSString *rString = [hexstr substringWithRange:range];
        //g
        range.location = 2;
        NSString *gString = [hexstr substringWithRange:range];
        //b
        range.location = 4;
        NSString *bString = [hexstr substringWithRange:range];
        
        // Scan values
        unsigned int r, g, b;
        [[NSScanner scannerWithString:rString] scanHexInt:&r];
        [[NSScanner scannerWithString:gString] scanHexInt:&g];
        [[NSScanner scannerWithString:bString] scanHexInt:&b];
        return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alphaValue];
    } else {
        return [UIColor whiteColor];
    }
}

+ (UIColor*) colorWithHex:(NSString*)hexValue{
    
    return [UIColor colorWithHex:hexValue alpha:1.0];
}

+ (NSString *) hexFromUIColor:(UIColor *)color{
    
    
    const CGFloat *cs=CGColorGetComponents(color.CGColor);
    NSString *r = [NSString stringWithFormat:@"%@",[UIColor ToHex:cs[0]*255]];
    NSString *g = [NSString stringWithFormat:@"%@",[UIColor ToHex:cs[1]*255]];
    NSString *b = [NSString stringWithFormat:@"%@",[UIColor ToHex:cs[2]*255]];
    return [NSString stringWithFormat:@"#%@%@%@",r,g,b];
    
    
}


//十进制转十六进制
+(NSString *)ToHex:(int)tmpid
{
    NSString *endtmp=@"";
    NSString *nLetterValue;
    NSString *nStrat;
    int ttmpig=tmpid%16;
    int tmp=tmpid/16;
    switch (ttmpig)
    {
        case 10:
            nLetterValue =@"A";break;
        case 11:
            nLetterValue =@"B";break;
        case 12:
            nLetterValue =@"C";break;
        case 13:
            nLetterValue =@"D";break;
        case 14:
            nLetterValue =@"E";break;
        case 15:
            nLetterValue =@"F";break;
        default:nLetterValue=[[NSString alloc]initWithFormat:@"%i",ttmpig];
            
    }
    switch (tmp)
    {
        case 10:
            nStrat =@"A";break;
        case 11:
            nStrat =@"B";break;
        case 12:
            nStrat =@"C";break;
        case 13:
            nStrat =@"D";break;
        case 14:
            nStrat =@"E";break;
        case 15:
            nStrat =@"F";break;
        default:nStrat=[[NSString alloc]initWithFormat:@"%i",tmp];
            
    }
    endtmp=[[NSString alloc]initWithFormat:@"%@%@",nStrat,nLetterValue];
    return endtmp;
}

@end
