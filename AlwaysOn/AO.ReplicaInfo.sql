SELECT
	(SELECT hc.cluster_name FROM sys.dm_hadr_cluster hc) [cluster_name],
	@@SERVICENAME [instance_name],
	ag.[name] [ag_name],
	ar.replica_server_name [replica_name],
	--(CASE WHEN hars.role_desc = 'PRIMARY' THEN '1. PRIMARY' WHEN hars.role_desc = 'SECONDARY' AND ar.availability_mode_desc = 'ASYNCHRONOUS_COMMIT' THEN '3. DR' WHEN hars.role_desc = 'SECONDARY' THEN '2. SECONDARY' ELSE hars.role_desc END) [replica_role],
	hars.role_desc [replica_role],
	ar.availability_mode_desc [replica_mode],
	ar.failover_mode_desc [failover],
	hars.operational_state_desc [operational_state],
	hars.connected_state_desc [connected_state],
	hars.recovery_health_desc [recovery_health],
	hags.synchronization_health_desc [synchronization_health],
	ar.[session_timeout] [timeout],
	ar.[endpoint_url],
	(CASE ar.primary_role_allow_connections_desc WHEN 'ALL' THEN 'Allow all connections' WHEN 'READ_WRITE' THEN 'Allow read/write connections' ELSE ar.primary_role_allow_connections_desc END) connections_in_primary_role,
	(CASE ar.secondary_role_allow_connections_desc WHEN 'ALL' THEN 'Yes' WHEN 'READ_ONLY' THEN 'Read-intent only' WHEN 'NO' THEN 'No' ELSE ar.primary_role_allow_connections_desc END) readable_secondary
FROM 
	sys.availability_groups ag
		INNER JOIN sys.dm_hadr_availability_group_states hags
			ON ag.group_id = hags.group_id
		INNER JOIN sys.availability_replicas ar
			INNER JOIN sys.dm_hadr_availability_replica_states hars
				ON ar.group_id = hars.group_id AND ar.replica_id = hars.replica_id 
			ON ar.group_id = ag.group_id
		INNER JOIN sys.availability_group_listeners agl
				ON ag.group_id = agl.group_id
--WHERE
--	ag.group_id IN (SELECT group_id FROM sys.dm_hadr_availability_replica_states WHERE role_desc = 'PRIMARY')
ORDER BY
	ag.[name], [replica_role];