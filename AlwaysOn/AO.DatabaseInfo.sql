SELECT 
	(SELECT hc.cluster_name FROM sys.dm_hadr_cluster hc) [cluster_name],
	@@SERVICENAME [instance_name],
	ag.[name] [ag_name],
	ar.replica_server_name [replica_name],
	d.[name] [db_name],
	--(CASE WHEN hars.role_desc = 'PRIMARY' THEN '1. PRIMARY' WHEN hars.role_desc = 'SECONDARY' AND ar.availability_mode_desc = 'ASYNCHRONOUS_COMMIT' THEN '3. DR' WHEN hars.role_desc = 'SECONDARY' THEN '2. SECONDARY' ELSE hars.role_desc END) [replica_role],
	hars.role_desc [replica_role],
	d.[state_desc] [db_state],
	hdrs.database_state_desc [db_ao_state],
	hdrs.synchronization_state_desc [synchronization_state],
	hdrs.synchronization_health_desc [synchronization_health],
	hdrs.suspend_reason_desc [suspend_reason],
	recovery_lsn,
	truncation_lsn,
	last_sent_lsn,
	last_sent_time,
	last_received_lsn,
	last_received_time,
	last_hardened_lsn,
	last_hardened_time,
	last_redone_lsn,
	last_redone_time,
	log_send_queue_size,
	log_send_rate,
	redo_queue_size,
	redo_rate,
	filestream_send_rate,
	end_of_log_lsn,
	last_commit_lsn,
	last_commit_time,
	low_water_mark_for_ghosts
FROM 
	sys.dm_hadr_database_replica_states hdrs
		INNER JOIN sys.availability_replicas ar
			INNER JOIN sys.dm_hadr_availability_replica_states hars
				ON ar.group_id = hars.group_id AND ar.replica_id = hars.replica_id 
			ON hdrs.replica_id = ar.replica_id
		INNER JOIN sys.databases d
			ON d.database_id = hdrs.database_id
		INNER JOIN sys.availability_groups ag
			ON ag.group_id = hdrs.group_id
ORDER BY
	[ag_name],[db_name],[replica_role];
