/* Generated by ICF ERwin Template */
/* %Parent %VerbPhrase %Child ON PARENT DELETE CASCADE */
%If(%!=(%Child, %Parent)) {
&IF DEFINED(lbe_%Substr(%Child,5)) = 0 &THEN
  DEFINE BUFFER lbe_%Substr(%Child,5) FOR %Child.
  &GLOBAL-DEFINE lbe_%Substr(%Child,5) yes
&ENDIF
FOR EACH %Child NO-LOCK
   WHERE %JoinFKPK(%Child,%Parent," = "," and")
   ON STOP UNDO, RETURN ERROR "AF^104^%TriggerName.p^delete %Child":U:
    FIND FIRST lbe_%Substr(%Child,5) EXCLUSIVE-LOCK
         WHERE ROWID(lbe_%Substr(%Child,5)) = ROWID(%Child)
         NO-ERROR.
    IF AVAILABLE lbe_%Substr(%Child,5) THEN
      DO:
        {af/sup/afvalidtrg.i &action = "DELETE" &table = "lbe_%Substr(%Child,5)"}
      END.
END.
}
%If(%==(%Child, %Parent)) {
FOR EACH lb_table NO-LOCK
   WHERE %JoinFKPK(lb_table,%Parent," = "," and")
   ON STOP UNDO, RETURN ERROR "AF^104^%TriggerName.p^delete %Child":U:
    FIND FIRST lb1_table EXCLUSIVE-LOCK
         WHERE ROWID(lb1_table) = ROWID(lb_table)
         NO-ERROR.
    IF AVAILABLE lb1_table THEN
      DO:
        {af/sup/afvalidtrg.i &action = "DELETE" &table = "lb1_table"}
      END.
END.
}

