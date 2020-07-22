# All ask functions take 2 args:
# Prompt
# Default (optional)

ask() {
    PROMPT=$1
    DEFAULT=$2

    echo ""
    echo -n "$PROMPT [$DEFAULT] "
    read response

    if [ -z $response ]; then
        response=$DEFAULT
    fi
}

askYN() {
    PROMPT=$1
    DEFAULT=$2

    if [ "x$DEFAULT" = "xyes" -o "x$DEFAULT" = "xYes" -o "x$DEFAULT" = "xy" -o "x$DEFAULT" = "xY" ]; then
        DEFAULT="Y"
    else
        DEFAULT="N"
    fi

    while [ 1 ]; do
        ask "$PROMPT" "$DEFAULT"
        response=$(perl -e "print lc(\"$response\");")
        if [ -z $response ]; then
        :
        else
            if [ $response = "yes" -o $response = "y" ]; then
                response="yes"
                break
            else
                if [ $response = "no" -o $response = "n" ]; then
                    response="no"
                    break
                fi
            fi
        fi
        echo "A Yes/No answer is required"
    done
}

displayLicense() {
    echo ""
    echo ""
    cat /opt/zurt/docs/license.txt
	
    echo ""
    echo ""
    if [ x$DEFAULTFILE = "x" ]; then
        askYN "Do you agree with the terms of the software license agreement?" "N"
        if [ $response != "yes" ]; then
            exit
        fi
    fi
    echo ""
}

checkInputValue () {
	INPUTVALUE=$1
	if [ ! -z "$INPUTVALUE" -a "$INPUTVALUE" != " " ]; then
	    echo You entered: $INPUTVALUE
	else
	    echo "You have entered empty value, so installation will terminate...."
	    exit
	fi
}
configure_LDAP_Variables() {
	echo ""
	echo ""
    if [ x$DEFAULTFILE = "x" ]; then
        askYN "Do you want to configure LDAP Variables?" "Y"
        if [ $response != "yes" ]; then
			echo ""
            echo "LDAP configurations will load from localconfig.xml"
			echo ""
		else
			read -p "Please provide the value of ldap_host : " LDAP_HOST
			checkInputValue $LDAP_HOST
			read -p "Please provide the value of ldap_port : " LDAP_PORT
			checkInputValue $LDAP_PORT
			read -p "Please provide the value of zimbra_ldap_userdn : " LDAP_USERDN
			checkInputValue $LDAP_USERDN
			read -p "Please provide the value of zimbra_ldap_password : " LDAP_PASSWORD
			checkInputValue $LDAP_PASSWORD
			LDAP_CONFIG_FILE_PATH="/opt/zurt/conf/zurt_ldap_config.xml"
			sed -i '/<key name="ldap_host">/!b;n;c\\t<value>'"$LDAP_HOST"'</value>' $LDAP_CONFIG_FILE_PATH
			sed -i '/<key name="ldap_port">/!b;n;c\\t<value>'"$LDAP_PORT"'</value>' $LDAP_CONFIG_FILE_PATH
			sed -i '/<key name="zimbra_ldap_userdn">/!b;n;c\\t<value>'"$LDAP_USERDN"'</value>' $LDAP_CONFIG_FILE_PATH
			sed -i '/<key name="zimbra_ldap_password">/!b;n;c\\t<value>'"$LDAP_PASSWORD"'</value>' $LDAP_CONFIG_FILE_PATH
        fi
    fi
}
echo ""
# EULA
displayLicense
configure_LDAP_Variables
/opt/zurt/bin/zurt

