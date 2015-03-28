//
//  PrettyClassInformationLogFormatter.m
//
//
//  Created by Vincil Bishop on 8/3/13.
//  Copyright (c) 2013 All rights reserved.
//

#import "PrettyClassInformationLogFormatter.h"

@implementation PrettyClassInformationLogFormatter

/*
 *   int logLevel;
 *   int logFlag;
 *   int logContext;
 *   NSString *logMsg;
 *   NSDate *timestamp;
 *   char *file;
 *   char *function;
 *   int lineNumber;
 *   mach_port_t machThreadID;
 *   char *queueLabel;
 *   NSString *threadName;
 */


- (NSString *) formatLogMessage:(DDLogMessage *) logMessage
{
    NSString *logLevel = [self logLevelForLogMessage:logMessage];

	NSString	*dateString		= [self dateStringFromTimestamp:logMessage.timestamp];
	NSString	*longFileName	= [NSString stringWithFormat:@"%@", logMessage.file];
	NSString	*fileName		= [[longFileName componentsSeparatedByString:@"/"] lastObject];

	return [NSString stringWithFormat:@"[%@]:[%@]:[%@]:[%@:%lu]:[%@]:%@\n",
		   dateString,
		   logLevel,
		   logMessage.threadID,
		   fileName,
		   (unsigned long)logMessage.line,
		   logMessage.function,
		   logMessage.message];
}



- (NSString *) logLevelForLogMessage:(DDLogMessage *)logMessage
{
   	NSString *logLevel;
    
    switch (logMessage.flag) {
        case DDLogFlagError:
            logLevel	= @"Error"; break;
            
        case DDLogFlagWarning:
            logLevel	= @"Warning"; break;
            
        case DDLogFlagInfo:
            logLevel	= @"Information"; break;
            
        default:
            logLevel	= @"Verbose"; break;
    }
    
    return logLevel;
}



- (NSString *) dateStringFromTimestamp:(NSDate *) timestamp
{
	NSDateFormatter *formatter	= [PrettyClassInformationLogFormatter dateFormatter];
	NSString		*dateString = [formatter stringFromDate:timestamp];

	return dateString;
}


+ (NSDateFormatter *) dateFormatter
{
	static dispatch_once_t	onceMark;
	static NSDateFormatter	*formatter = nil;

	dispatch_once(&onceMark, ^{
			formatter = [[NSDateFormatter alloc] init];
            [formatter setLocale:[NSLocale currentLocale]];
            [formatter setDateFormat:@"yyyy.MM.dd HH:mm:ss+zzz"];
		});

	return formatter;
}


@end