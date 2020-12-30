
SET ECHO        OFF
SET FEEDBACK    OFF
SET HEADING     OFF
SET LINESIZE    180
SET PAGESIZE    0
SET TERMOUT     ON
SET TIMING      OFF
SET TRIMOUT     ON
SET TRIMSPOOL   ON
SET VERIFY      OFF

CLEAR COLUMNS
CLEAR BREAKS
CLEAR COMPUTES

spool compile.sql

SELECT  'alter ' ||
       decode(object_type, 'PACKAGE BODY', 'package', object_type) ||
       ' ' ||
       object_name||
       ' compile' ||
       decode(object_type, 'PACKAGE BODY', ' body;', ';')
FROM   dba_objects
WHERE  status = 'INVALID'
/

spool off

SET ECHO        off
SET FEEDBACK    off
SET HEADING     off
SET LINESIZE    180
SET PAGESIZE    0
SET TERMOUT     on
SET TIMING      off
SET TRIMOUT     on
SET TRIMSPOOL   on
SET VERIFY      off

@compile

SET FEEDBACK    6
SET HEADING     ON
