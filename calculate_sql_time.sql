--------------------------------------------------------
--  Date  : 2020/03/21
--  Owner : SQLcl
--  ver   : 1.00
--------------------------------------------------------

select percent
  ||' %' percent,
  elapsed_seconds,
  remaining_second,
  sid,
  qcsid,
  target_desc,
  username,
  opname,
  target,
  units,
  message
from
  (select *
  from
    (select round((sofar*100)/totalwork,2) percent ,
      sid ,
      qcsid,
      target_desc,
      username ,
      round(elapsed_seconds*(totalwork-sofar) / sofar) remaining_second ,
      opname,
      target,
      sofar,
      totalwork,
      units,
      elapsed_seconds,
      message
    from v$session_longops
    where time_remaining > 0
    )
  )