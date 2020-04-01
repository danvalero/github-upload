SELECT TOP 100
		(SELECT db_name(dbid) FROM sys.dm_exec_sql_text(qs.plan_handle)) DBName, 
		(SELECT object_name(objectid, dbid) FROM sys.dm_exec_sql_text(qs.plan_handle)) SPName, 
		(SELECT SUBSTRING(text, statement_start_offset/2 + 1, (CASE WHEN statement_end_offset = -1 THEN LEN(CONVERT(nvarchar(max), text)) * 2 ELSE statement_end_offset END - statement_start_offset)/2) FROM sys.dm_exec_sql_text(sql_handle)) AS query_text,
		creation_time,
		last_execution_time,
		execution_count,
		total_worker_time / 1000 AS CPU_ms,
		total_worker_time / execution_count / 1000 AS Avg_CPU_ms,
		total_logical_reads AS page_reads,
		total_logical_reads / execution_count AS Avg_page_reads,
		total_elapsed_time / 1000 AS Elapsed_ms,
		total_elapsed_time / execution_count / 1000 AS avg_Elapsed_ms,
		total_physical_reads AS physical_reads,
		total_physical_reads / execution_count AS Avg_physical_reads,
		(SELECT query_plan FROM sys.dm_exec_query_plan(qs.plan_handle)) QueryPlan
FROM sys.dm_exec_query_stats qs
ORDER BY total_worker_time DESC
--ORDER BY total_worker_time / 1000 DESC
GO
