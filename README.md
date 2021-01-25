# sshfsnas
OSX utility script to mount SMB and NAS (SSH Fuse Client) file shares

### Usage: mount_nas

```$ mount_nas.sh```

This script parses the elements in nas.json and mounts the remote volumes as the local $USER account.

--

Features: Add as many mount points as you need to nas.json. The only limit is yourself.

`nas.json`

```
[nas]
"host" : FQDN or IP
"local" : "mount Point on client host"
"remote" : "remote path"
```

```
[smb]
"host" : FQDN or IP
"remote" : "remote shared folder"
```

### Usage: unmount_sshfs

```$ unmount_sshfs```

Uses mount table to check for an unmount any assets listed in nas.json

