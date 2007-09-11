INFOPLIST_FILE=Info.plist
SOURCES=\
	main.m \
	MobileTwitterrificApp.m \
	IFTwitterConnection.m \
	IFTwitterTimelineConnection.m \
	IFPreferencesController.m \
	IFTweetController.m \
	IFTweetModel.m \
	IFSoundController.m \
	IFInputController.m \
	IFTweetTableCell.m \
	IFTweetTable.m \
	IFTwitterrificToolbar.m \
	IFURLImageView.m \
	IFTweetView.m \
	IFTweetKeyboard.m \
	IFTweetEditTextView.m \
	UIView-Color.m \
	NSDate-Relative.m \
	IFTweetPostView.m \
	IFTransparentBox.m \
	IFTwitterUpdateConnection.m \
	IFRuntimeAdditions.m
RESOURCES=Resources
ENGLISH_LOCALIZATION=English.lproj

#CC=/opt/local/arm-apple-darwin/bin/arm-apple-darwin-cc
#CFLAGS=-g -Wall
# CFLAGS=-g -Wall -Werror
# CFLAGS=-g -O2 -Wall -- no optimization yet
#LD=$(CC)
#LD=/Developer/SDKs/iPhone/bin/arm-apple-darwin-ld
#	-F/Developer/SDKs/heavenly/System/Library/Frameworks
# LDFLAGS=-ObjC -L/Developer/SDKs/iPhone/lib \
#CC=arm-apple-darwin-gcc
#CXX=arm-apple-darwin-g++
#LDFLAGS=-Wl,-syslibroot,$(HEAVENLY)
#	-ObjC \
#CFLAGS=-fsigned-char

LDFLAGS=-Wl,-syslibroot,/opt/local/arm-apple-darwin/heavenly -lobjc \
	-framework CoreFoundation \
	-framework Foundation \
	-framework UIKit \
	-framework LayerKit \
	\
	-framework AddressBook \
	-framework AddressBookUI \
	-framework AppSupport \
	-framework AudioToolbox \
	-framework BluetoothManager \
	-framework Calendar \
	-framework Camera \
	-framework Celestial \
	-framework CoreAudio \
	-framework CoreGraphics \
	-framework CoreSurface \
	-framework CoreTelephony \
	-framework CoreVideo \
	-framework DeviceLink \
	-framework GMM \
	-framework GraphicsServices \
	-framework IAP \
	-framework IOKit \
	-framework IOMobileFramebuffer \
	-framework ITSync \
	-framework JavaScriptCore \
	-framework MBX2D \
	-framework MBXConnect \
	-framework MeCCA \
	-framework Message \
	-framework MessageUI \
	-framework MobileBluetooth \
	-framework MobileMusicPlayer \
	-framework MoviePlayerUI \
	-framework MultitouchSupport \
	-framework MusicLibrary \
	-framework OfficeImport \
	-framework OpenGLES \
	-framework PhotoLibrary \
	-framework Preferences \
	-framework Security \
	-framework System \
	-framework SystemConfiguration \
	-framework TelephonyUI \
	-framework URLify \
	-framework WebCore \
	-framework WebKit \

WRAPPER_NAME=$(PRODUCT_NAME).app
EXECUTABLE_NAME=$(PRODUCT_NAME)
SOURCES_ABS=$(addprefix $(SRCROOT)/,$(SOURCES))
INFOPLIST_ABS=$(addprefix $(SRCROOT)/,$(INFOPLIST_FILE))
OBJECTS=\
	$(patsubst %.c,%.o,$(filter %.c,$(SOURCES))) \
	$(patsubst %.cc,%.o,$(filter %.cc,$(SOURCES))) \
	$(patsubst %.cpp,%.o,$(filter %.cpp,$(SOURCES))) \
	$(patsubst %.m,%.o,$(filter %.m,$(SOURCES))) \
	$(patsubst %.mm,%.o,$(filter %.mm,$(SOURCES)))
OBJECTS_ABS=$(addprefix $(CONFIGURATION_TEMP_DIR)/,$(OBJECTS))
APP_ABS=$(BUILT_PRODUCTS_DIR)/$(WRAPPER_NAME)
PRODUCT_ABS=$(APP_ABS)/$(EXECUTABLE_NAME)

all: $(PRODUCT_ABS)
	scp -rp $(APP_ABS) root@192.168.0.109:/Applications
	
$(PRODUCT_ABS): $(APP_ABS) $(OBJECTS_ABS)
	$(LD) $(LDFLAGS) -o $(PRODUCT_ABS) $(OBJECTS_ABS)

$(APP_ABS): $(INFOPLIST_ABS) $(SRCROOT)/$(ENGLISH_LOCALIZATION)/* $(SRCROOT)/$(RESOURCES)/*.png $(SRCROOT)/$(RESOURCES)/*.wav
	mkdir -p $(APP_ABS)
	cp $(INFOPLIST_ABS) $(APP_ABS)/
	cp $(SRCROOT)/$(RESOURCES)/*.png $(APP_ABS)/
	cp $(SRCROOT)/$(RESOURCES)/*.wav $(APP_ABS)/
	mkdir -p $(APP_ABS)/$(ENGLISH_LOCALIZATION)
	cp -v $(ENGLISH_LOCALIZATION)/* $(APP_ABS)/$(ENGLISH_LOCALIZATION)/

$(CONFIGURATION_TEMP_DIR)/%.o: $(SRCROOT)/%.m
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

clean:
	rm -f $(OBJECTS_ABS)
	rm -rf $(APP_ABS)

