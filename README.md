# DEPRECATED

# MEGASync in Docker optimized for Unraid
MEGAsync is an intuitive application that enables you to effortlessly synchronize folders on several computers. You simply need to upload data in the cloud and, within seconds, you can explore the same documents on your own PC.

MEGAsync can synchronize all of your devices with your MEGA account. Access and work with your data securely across different locations and devices.

## Env params
| Name | Value | Example |
| --- | --- | --- |
| DATA_DIR | Main storage folder | /megasync/.local/share/data/Mega Limited/MEGAsync |
| CUSTOM_RES_W | If needed enter your custom screen with in pixels | 800 |
| CUSTOM_RES_H | If needed enter your custom screen height in pixels | 600 |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| UMASK | User file permission mask for newly created files | 000 |
| DATA_PERM | Data permissions for main storage folder | 770 |

## Run example
```
docker run --name Deezloader-Remix -d \
	-p 8080:8080 \
	--env 'UMASK=000' \
	--env 'DATA_PERM=770' \
	--env 'UID=99' \
	--env 'GID=100' \
	--volume /mnt/user/appdata/megasync:/megasync/.local/share/data/Mega Limited/MEGAsync \
	--volume /mnt/user:/mnt/host \
	--restart=unless-stopped \
	ich777/megasync
```

### Webgui address: http://[SERVERIP]:[PORT]/vnc_auto.html

This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!

#### Support Thread: https://forums.unraid.net/topic/83786-support-ich777-application-dockers/