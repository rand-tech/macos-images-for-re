#!/bin/bash -e -o pipefail
################################################################################
##  File:  configure-tccdb-macos.sh
##  Desc:  Configure permissions to the TCC.db
################################################################################

source ~/utils/utils.sh

# /Library/Application\ Support/com.apple.TCC/TCC.db
systemValuesArray=(
    "'kTCCServiceAccessibility','com.apple.dt.Xcode-Helper',0,2,0,1,NULL,NULL,NULL,'UNUSED',NULL,NULL,1551941368"
    "'kTCCServiceSystemPolicyAllFiles','/bin/bash',1,2,0,1,NULL,NULL,NULL,'UNUSED',NULL,0,1583997993"
    "'kTCCServiceSystemPolicyAllFiles','/usr/libexec/sshd-keygen-wrapper',1,0,4,1,X'fade0c000000003c0000000100000006000000020000001d636f6d2e6170706c652e737368642d6b657967656e2d7772617070657200000000000003',NULL,0,'UNUSED',NULL,0,1639660695"
    "'kTCCServiceSystemPolicyAllFiles','com.apple.Terminal',0,2,4,1,X'fade0c000000003000000001000000060000000200000012636f6d2e6170706c652e5465726d696e616c000000000003',NULL,0,'UNUSED',NULL,0,1678990068"
    "'kTCCServiceAccessibility','/usr/libexec/sshd-keygen-wrapper',1,2,4,1,X'fade0c000000003c0000000100000006000000020000001d636f6d2e6170706c652e737368642d6b657967656e2d7772617070657200000000000003',NULL,0,'UNUSED',NULL,0,1644564233"
    "'kTCCServiceAccessibility','com.apple.Terminal',0,2,0,1,X'fade0c000000003000000001000000060000000200000012636f6d2e6170706c652e5465726d696e616c000000000003',NULL,NULL,'UNUSED',NULL,0,1591180502"
    "'kTCCServiceAccessibility','/bin/bash',1,2,0,1,NULL,NULL,NULL,'UNUSED',NULL,0,1583997993"
    "'kTCCServiceMicrophone','/usr/local/opt/runner/runprovisioner.sh',1,2,0,1,NULL,NULL,NULL,'UNUSED',NULL,NULL,1576661342"
    "'kTCCServiceScreenCapture','/bin/bash',1,2,0,1,NULL,NULL,NULL,'UNUSED',NULL,0,1599831148"
    "'kTCCServiceSystemPolicyNetworkVolumes','com.apple.Terminal',0,2,4,1,X'fade0c000000003000000001000000060000000200000012636f6d2e6170706c652e5465726d696e616c000000000003',NULL,0,'UNUSED',NULL,0,1678990068"
)
for values in "${systemValuesArray[@]}"; do
    if is_Sonoma; then
        # TCC access table in Sonoma has extra 4 columns: pid, pid_version, boot_uuid, last_reminded
        configure_system_tccdb "$values,NULL,NULL,'UNUSED',${values##*,}"
    else
        configure_system_tccdb "$values"
    fi
done

# $HOME/Library/Application\ Support/com.apple.TCC/TCC.db
userValuesArray=(
    "'kTCCServiceAppleEvents','com.apple.Terminal',0,2,0,1,X'fade0c000000003000000001000000060000000200000012636f6d2e6170706c652e5465726d696e616c000000000003',NULL,0,'com.apple.systemevents',X'fade0c000000003400000001000000060000000200000016636f6d2e6170706c652e73797374656d6576656e7473000000000003',NULL,1591180478"
    "'kTCCServiceAppleEvents','/bin/bash',1,2,0,1,NULL,NULL,0,'com.apple.systemevents',NULL,NULL,1591532620"
    "'kTCCServiceAppleEvents','/bin/bash',1,2,0,1,NULL,NULL,0,'com.apple.finder',NULL,NULL,1592919552"
    "'kTCCServiceMicrophone','com.apple.CoreSimulator.SimulatorTrampoline',0,2,0,1,NULL,NULL,NULL,'UNUSED',NULL,NULL,1576347152"
    "'kTCCServiceUbiquity','/System/Library/PrivateFrameworks/PhotoLibraryServices.framework/Versions/A/Support/photolibraryd',1,2,5,1,NULL,NULL,NULL,'UNUSED',NULL,0,1619461750"
    "'kTCCServiceUbiquity','com.apple.PassKitCore',0,2,5,1,NULL,NULL,NULL,'UNUSED',NULL,0,1619516250"
    "'kTCCServicePostEvent','/bin/bash',1,2,0,1,NULL,NULL,NULL,'UNUSED',NULL,0,1583997993"
)
for values in "${userValuesArray[@]}"; do
    if is_Sonoma; then
        # TCC access table in Sonoma has extra 4 columns: pid, pid_version, boot_uuid, last_reminded
        configure_user_tccdb "$values,NULL,NULL,'UNUSED',${values##*,}"
    else
        configure_user_tccdb "$values"
    fi
done
