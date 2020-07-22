########################################################################################################

SHELL = bash

SHA512 = sha512sum

.PHONY: clean all

########################################################################################################

all: zimbra-zurt-pkg

########################################################################################################

ZURT_VERSION = 1.0.0
NG_URL="https://files.zimbra.com/downloads/tmp/zurt/zimbra-URT-1.0.0-BETA-20200716123829.tgz"

stage-zurt-pkg: downloads
	install -T -D  downloads/zimbra-URT/conf/log4j2.xml	build/stage/zimbra-zurt/opt/zurt/conf/log4j2.xml
	install -T -D  downloads/zimbra-URT/conf/zurt.properties	build/stage/zimbra-zurt/opt/zurt/conf/zurt.properties
	install -T -D  downloads/zimbra-URT/conf/zurt_ldap_config.xml	build/stage/zimbra-zurt/opt/zurt/conf/zurt_ldap_config.xml
	install -T -D  downloads/zimbra-URT/docs/README.txt	build/stage/zimbra-zurt/opt/zurt/docs/README.txt
	install -T -D  downloads/zimbra-URT/docs/license.txt	build/stage/zimbra-zurt/opt/zurt/docs/license.txt
	install -T -D  downloads/zimbra-URT/lib/usage-collector*.jar	build/stage/zimbra-zurt/opt/zurt/lib/usage-collector.jar
	install -D  downloads/zimbra-URT/lib/zrt-cli*.jar	build/stage/zimbra-zurt/opt/zurt/lib/zrt-cli.jar
	install -T -D  downloads/zimbra-URT/bin/zurt	build/stage/zimbra-zurt/opt/zurt/bin/zurt
	install -T -D  downloads/zimbra-URT/log/error.log	build/stage/zimbra-zurt/opt/zurt/log/error.log
	install -D  downloads/zimbra-URT/service/zurt	build/stage/zimbra-zurt/opt/zurt/service/zurt
	install -D  downloads/zimbra-URT/service/zurt	build/stage/zimbra-zurt/etc/init.d/zurt
	chmod +x build/stage/zimbra-zurt/opt/zurt/bin/zurt

zimbra-zurt-pkg: stage-zurt-pkg
	../zm-pkg-tool/pkg-build.pl \
           --pkg-version=$(ZURT_VERSION).$(shell git log --format=%at -1 scripts) \
           --pkg-release=1 \
           --pkg-name=zimbra-zurt \
           --pkg-summary="Zimbra Reporting Tool" \
           --pkg-pre-install-script='scripts/preinst.sh'\
           --pkg-post-install-script='scripts/postinst.sh'\
		   --pkg-installs='/opt/zurt/conf/*' \
		   --pkg-installs='/opt/zurt/docs/*' \
		   --pkg-installs='/opt/zurt/lib/*'  \
		   --pkg-installs='/opt/zurt/bin/*' \
		   --pkg-installs='/opt/zurt/log/*' \
		   --pkg-installs='/opt/zurt/service/*' \
		   --pkg-installs='/etc/init.d/zurt'

########################################################################################################
downloads:
	mkdir -p downloads
	wget -O downloads/zurt.tar.gz $(NG_URL)
	cd downloads/; mkdir zimbra-URT ;tar -xvzf zurt.tar.gz -C zimbra-URT --strip-components 1

########################################################################################################
clean:
	rm -rf build
	rm -rf downloads

########################################################################################################

