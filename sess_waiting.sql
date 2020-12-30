
SET TERMOUT OFF;
COLUMN current_instance NEW_VALUE current_instance NOPRINT;
SELECT rpad(instance_name, 17) current_instance FROM v$instance;
SET TERMOUT ON;

PROMPT 
PROMPT +------------------------------------------------------------------------+
PROMPT | Report   : Session Waits                                               |
PROMPT | Instance : &current_instance                                           |
PROMPT +------------------------------------------------------------------------+

SET ECHO        OFF
SET FEEDBACK    6
SET HEADING     ON
SET LINESIZE    180
SET PAGESIZE    50000
SET TERMOUT     ON
SET TIMING      OFF
SET TRIMOUT     ON
SET TRIMSPOOL   ON
SET VERIFY      OFF

CLEAR COLUMNS
CLEAR BREAKS
CLEAR COMPUTES

COLUMN instance_name     FORMAT a9            HEADING 'Instance'
COLUMN sid               FORMAT 999999        HEADING 'SID'
COLUMN serial_id         FORMAT 99999999      HEADING 'Serial ID'
COLUMN session_status    FORMAT a9            HEADING 'Status'
COLUMN oracle_username   FORMAT a20           HEADING 'Oracle User'
COLUMN state             FORMAT a8            HEADING 'State'
COLUMN event             FORMAT a25           HEADING 'Event'
COLUMN wait_time_sec     FORMAT 999,999,999   HEADING 'Wait Time (sec)'
COLUMN last_sql          FORMAT a45           HEADING 'Last SQL'

SELECT
    i.instance_name                 instance_name
  , s.sid                           sid
  , s.serial#                       serial_id
  , s.username                      oracle_username
  , sw.state                        state
  , sw.event                        event
  , sw.seconds_in_wait              wait_time_sec
  , sa.sql_text                     last_sql
FROM
             gv$session_wait sw
  INNER JOIN gv$session s   ON  ( sw.inst_id = s.inst_id
                                  AND
                                  sw.sid     = s.sid
                                )
  INNER JOIN gv$sqlarea sa  ON  ( s.inst_id     = sa.inst_id
                                  AND
                                  s.sql_address = sa.address
                                )
  INNER JOIN gv$instance i  ON  ( s.inst_id = i.inst_id)
WHERE
      sw.event NOT IN (   'rdbms ipc message'
                        , 'smon timer'
                        , 'pmon timer'
                        , 'SQL*Net message from client'
                        , 'lock manager wait for remote message'
                        , 'ges remote message'
                        , 'gcs remote message'
                        , 'gcs for action'
                        , 'client message'
                        , 'pipe get'
                        , 'null event'
                        , 'PX Idle Wait'
                        , 'single-task message'
                        , 'PX Deq: Execution Msg'
                        , 'KXFQ: kxfqdeq - normal deqeue'
                        , 'listen endpoint status'
                        , 'slave wait'
                        , 'wakeup time manager'
                      )
  AND sw.seconds_in_wait > 0 
ORDER BY
    wait_time_sec DESC
  , i.instance_name;

