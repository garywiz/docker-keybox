<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE log4j:configuration SYSTEM "log4j.dtd">
<log4j:configuration xmlns:log4j="http://jakarta.apache.org/log4j/">

    <appender name="console" class="org.apache.log4j.ConsoleAppender">
        <param name="encoding" value="UTF-8"/>
        <param name="Target" value="System.out"/>
        <layout class="org.apache.log4j.PatternLayout">
            <param name="ConversionPattern" value="%-5p %c{1} - %m%n"/>
        </layout>
    </appender>

    <!-- System audit example using logstash
    <appender name="logstash-socket-appender" class="org.apache.log4j.net.SocketAppender">
        <param name="RemoteHost" value="127.0.0.1"/>
        <param name="Port" value="5300"/>
        <param name="ReconnectionDelay" value="50000"/>
        <param name="Threshold" value="INFO"/>
    </appender>

    <logger name="com.keybox.manage.util.SystemAudit" additivity="false">
        <level value="info"/>
        <appender-ref ref="logstash-socket-appender"/>
    </logger>
    -->

    <!-- Alternative login audit appender example
    <appender name="login-appender" class="org.apache.log4j.FileAppender">
        <param name="encoding" value="UTF-8"/>
        <param name="File" value="/apps/var/log/keybox-login-audit.log" />
        <param name="Append" value="true" />
        <layout class="org.apache.log4j.PatternLayout">
            <param name="ConversionPattern" value="%-5p %c{1} - %m%n"/>
        </layout>
    </appender>
    -->

    <appender name="login-appender" class="org.apache.log4j.ConsoleAppender">
        <param name="encoding" value="UTF-8"/>
        <param name="Target" value="System.out"/>
        <layout class="org.apache.log4j.PatternLayout">
            <param name="ConversionPattern" value="%-5p %c{1} - %m%n"/>
        </layout>
    </appender>

    <logger name="com.keybox.manage.action.LoginAudit" additivity="false">
        <level value="info"/>
        <appender-ref ref="login-appender"/>
    </logger>

    <root>
        <level value="warn"/>
        <appender-ref ref="console"/>
    </root>

</log4j:configuration>