#!/usr/bin/bash

# -m creates it at the default /home/deploy
useradd -m -s /bin/bash deploy

# useradd defaults the shadow password field to "!" (administratively locked),
# and PAM's account check rejects even pubkey SSH logins for a locked account -
# same issue as cloud-init's lock_passwd for root. "*" means "no valid password"
# without being locked, so key-only login still works.
usermod -p '*' deploy
