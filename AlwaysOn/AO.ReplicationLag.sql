--Replication Lag
SELECT 
	DB_NAME(database_id) AS db_name,
    CONVERT(DECIMAL(10,2), (redo_queue_size / 1000000) ) AS in_gb,
    CONVERT(DECIMAL(10,2), (redo_queue_size / 1000) ) AS in_mb,
       redo_queue_size,
       redo_rate,
       log_send_queue_size,
       (redo_queue_size/1) AS lag_seconds,
       (redo_queue_size/1) / 60.0 AS lag_minutes
FROM 
	sys.dm_hadr_database_replica_states
