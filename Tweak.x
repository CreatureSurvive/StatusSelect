#define kIdentifier @"com.creaturecoding.statusselect"
#define kSettingsPath @"/var/mobile/Library/Preferences/com.creaturecoding.statusselect.plist"
#define kSettingsChangedNotification (CFStringRef)@"com.creaturecoding.statusselect.prefs-changed"

BOOL enabled = NO;
NSInteger style = -1;

static void LoadSettings() {
	@autoreleasepool {
		NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:kSettingsPath];
		enabled = preferences[@"kEnabled"] ? [preferences[@"kEnabled"] boolValue] : NO;
		style = preferences[@"kStyle"] ? [preferences[@"kStyle"] integerValue] : -1;
	}
}

static void SettingsDidChangeNotification(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo){
    if ([(__bridge NSString *)name isEqualToString:(__bridge NSString *)kSettingsChangedNotification]) {
        LoadSettings();
    }
}

%hook _UIStatusBarVisualProvider_iOS

+ (Class)visualProviderSubclassForScreen:(id)arg1 {
	
	if (enabled) {
		switch (style) {
			case 1:  return NSClassFromString(@"_UIStatusBarVisualProvider_Split58");
			case 2:  return NSClassFromString(@"_UIStatusBarVisualProvider_Split61");
			case 3:  return NSClassFromString(@"_UIStatusBarVisualProvider_Split65");
			case 4:  return NSClassFromString(@"_UIStatusBarVisualProvider_CarPlay");
			default: return %orig;
		}
	}

	return %orig;
}

%end

%ctor {
	@autoreleasepool {
		LoadSettings();
		CFNotificationCenterAddObserver(
			CFNotificationCenterGetDarwinNotifyCenter(),
			NULL, 
			SettingsDidChangeNotification, 
			kSettingsChangedNotification, 
			NULL, 
			CFNotificationSuspensionBehaviorCoalesce
		);
	}
}