#
# KeyBox - Version: 2.83.02
#
#
#set to true to regenerate and import SSH keys
resetApplicationSSHKey=false
#SSH Key Type 'dsa' or 'rsa' for generated keys
sshKeyType=rsa
#SSH Key Length for generated keys
sshKeyLength=2048
#private ssh key, leave blank to generate key pair
privateKey=
#public ssh key, leave blank to generate key pair
publicKey=
#default passphrase, leave blank for key without passphrase
defaultSSHPassphrase=${randomPassphrase}
#enable audit (original default = false)
enableAudit=%(CONFIG_ENABLE_AUDIT)
#keep audit logs for in days (original default = 90)
deleteAuditLogAfter=%(CONFIG_DELETE_AUDIT_AFTER)
#default timeout in minutes for websocket connection (no timeout for <=0)
websocketTimeout=0
#enable SSH agent forwarding
agentForwarding=false
#enable two-factor authentication
enableOTP=%(CONFIG_ENABLE_OTP)
#enable key management
keyManagementEnabled=%(CONFIG_ENABLE_KEY_MANAGEMENT)
#set to true to generate keys when added/managed by users and enforce strong passphrases set to false to allow users to set their own public key
forceUserKeyGeneration=%(CONFIG_FORCE_KEY_GENERATION)
#authorized_keys refresh interval in minutes (no refresh for <=0)
authKeysRefreshInterval=%(CONFIG_AUTHKEYS_REFRESH)
#Regular expression to enforce password policy
passwordComplexityRegEx=((?=.*\\d)(?=.*[A-Z])(?=.*[a-z])(?=.*[!@#$%^&*()+=]).{8\,20})
#Password complexity error message
passwordComplexityMsg=Passwords must be 8 to 20 characters\, contain one digit\, one lowercase\, one uppercase\, and one special character
#specify a external authentication module (ex: ldap-ol, ldap-ad).  Edit the jaas.conf to set connection details
jaasModule=
