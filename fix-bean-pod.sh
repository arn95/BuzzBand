#!/bin/sh

echo "Fixing Bean-iOS-OSX-SDK Swift 3 problems..."

echo "- removing OCMock"
rm -rf "./Pods/Bean-iOS-OSX-SDK/Bean OSX Static Library/Frameworks/OCMock"
rm -rf "./Pods/Bean-iOS-OSX-SDK/Bean OSX Static Library/Frameworks/OCMock.framework"

echo "- patching AppMessageTypes.h"
mv "./Pods/Bean-iOS-OSX-SDK/App Message Definitions" "./Pods/Bean-iOS-OSX-SDK/App_Message_Definitions"
chmod 644 "./Pods/Bean-iOS-OSX-SDK/App_Message_Definitions/AppMessageTypes.h"
patch -p1 < "./fix-bean-pod.patch"
mv "./Pods/Bean-iOS-OSX-SDK/App_Message_Definitions" "./Pods/Bean-iOS-OSX-SDK/App Message Definitions"

echo "Done"