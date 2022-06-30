#!/bin/sh

## Copyright (C) 2022 - 2022 ENCRYPTED SUPPORT LP <adrelanos@whonix.org>
## See the file COPYING for copying conditions.

ram_wipe_check_needshutdown() {
   local OLD_DRACUT_QUIET
   OLD_DRACUT_QUIET="$DRACUT_QUIET"
   DRACUT_QUIET='no'

   local kernel_wiperam_setting
   kernel_wiperam_setting=$(getarg wiperam)

   if [ "$kernel_wiperam_setting" = "skip" ]; then
      info "wipe-ram-needshutdown.sh: Skip, because wiperam=skip kernel parameter detected, OK."
      DRACUT_QUIET="$OLD_DRACUT_QUIET"
      return 0
   fi

   if [ "$kernel_wiperam_setting" = "force" ]; then
      info "wipe-ram-needshutdown.sh: wiperam=force detected, OK."
   else
      if systemd-detect-virt &>/dev/null ; then
         info "wipe-ram-needshutdown.sh: Skip, because VM detected and not using wiperam=force kernel parameter, OK."
         DRACUT_QUIET="$OLD_DRACUT_QUIET"
         return 0
      fi
   fi

   info "wipe-ram-needshutdown.sh: Calling dracut function need_shutdown to drop back into initramfs at shutdown, OK."
   need_shutdown

   DRACUT_QUIET="$OLD_DRACUT_QUIET"
   return 0
}

ram_wipe_check_needshutdown
