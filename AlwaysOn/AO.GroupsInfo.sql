SELECT
	(SELECT hc.cluster_name FROM sys.dm_hadr_cluster hc) [cluster_name],
	@@SERVICENAME [instance_name],
	ag.[name] [ag_name],
	ag.[failure_condition_level] [failure_level],
	ag.[health_check_timeout] [timeout],
	ag.automated_backup_preference_desc [backup_on],
	ag.[version], --sql 2016+
	ag.[dtc_support], --sql 2016+
	ag.[db_failover], --sql 2016+
	ag.is_distributed, --sql 2016+
	agl.dns_name [Listener Name],
	agl.[port],
	(SELECT ip_address FROM sys.availability_group_listener_ip_addresses aglia WHERE aglia.listener_id = agl.listener_id AND state_desc = 'ONLINE') [online_ip],
	(SELECT ip_address FROM sys.availability_group_listener_ip_addresses aglia WHERE aglia.listener_id = agl.listener_id AND state_desc = 'OFFLINE') [offline_ip]
FROM
	sys.availability_groups ag
		INNER JOIN sys.availability_group_listeners agl
			ON ag.group_id = agl.group_id
ORDER BY
	ag.[name];