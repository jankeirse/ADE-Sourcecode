/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/

/* Procedure _mss_inc.p
   Donna L. McMann
   
   Created 12/03/02 Initial procedure for the MSS Incremental Df Utility
   
*/   

{ prodict/user/uservar.i NEW }
{ prodict/mss/mssvar.i NEW }
{ prodict/misc/filesbtn.i }

DEFINE VARIABLE create_df     AS LOGICAL INITIAL TRUE   NO-UNDO.
DEFINE VARIABLE batch_mode    AS LOGICAL INITIAL FALSE  NO-UNDO. 
DEFINE VARIABLE output_file   AS CHARACTER              NO-UNDO.
DEFINE VARIABLE df-file       AS CHARACTER              NO-UNDO.
DEFINE VARIABLE i             AS INTEGER                NO-UNDO.
DEFINE VARIABLE schdbcon      AS LOGICAL INITIAL FALSE  NO-UNDO.
DEFINE VARIABLE conparms      AS CHARACTER              NO-UNDO.
DEFINE VARIABLE l_curr-db     AS INTEGER INITIAL 1      NO-UNDO.
DEFINE VARIABLE l_dbnr        AS INTEGER                NO-UNDO.



FORM
  " "   SKIP 
    df-file {&STDPH_FILL} FORMAT "x({&PATH_WIDG})"  VIEW-AS FILL-IN SIZE 40 BY 1
         LABEL "Delta DF File" colon  15
  btn_File SKIP SKIP({&VM_WIDG})
  osh_dbname   FORMAT "x(256)"  view-as fill-in size 32 by 1 
    LABEL "Schema Holder Database" colon 35 SKIP({&VM_WID}) 
  mss_conparms FORMAT "x(256)" view-as fill-in size 32 by 1 
    LABEL "Connect parameters for Schema" colon 35 SKIP({&VM_WID})
  mss_dbname   FORMAT "x(32)"  view-as fill-in size 32 by 1 
    LABEL "Logical name for MSS Database" colon 35 SKIP({&VM_WID})   
  mss_username    FORMAT "x(32)"  VIEW-AS FILL-IN SIZE 32 BY 1
    LABEL "MSS Object Owner Name" COLON 35 SKIP({&VM_WID})    
  long-length LABEL " Maximum Varchar Length"  COLON 35 SKIP({&VM_WIDG})
  SPACE(3) pcompatible view-as toggle-box LABEL "Create Progress RECID Field"  
  shadowcol VIEW-AS TOGGLE-BOX LABEL "Create Shadow Columns" SKIP({&VM_WID})
  SPACE (3) dflt VIEW-AS TOGGLE-BOX LABEL "Include Default" &IF "{&WINDOW-SYSTEM}" = "TTY"
  &THEN SPACE(13) &ELSE SPACE (14) &ENDIF
  sqlwidth VIEW-AS TOGGLE-BOX LABEL "Use Sql Width" SKIP({&VM_WID}) 
  SPACE (13) create_df view-as toggle-box LABEL "Create schema holder delta df"
   SKIP({&VM_WIDG})
             {prodict/user/userbtns.i}
  WITH FRAME read-df ROW 2 CENTERED SIDE-labels 
    DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
    &IF "{&WINDOW-SYSTEM}" <> "TTY"
  &THEN VIEW-AS DIALOG-BOX &ENDIF
  TITLE "Delta df to MS SQL Server Conversion".

/*=============================Triggers===============================*/

/*----- ON GO or OK -----*/
ON GO OF FRAME read-df
DO:
  IF (df-file:SCREEN-VALUE IN FRAME read-df = ? OR
      df-file:SCREEN-VALUE IN FRAME read-df = "") THEN DO:
    MESSAGE "Delta DF File is required. " VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    APPLY "ENTRY" TO df-file IN FRAME read-df.
    RETURN NO-APPLY.
  END.

  IF SEARCH(df-file:SCREEN-VALUE IN FRAME read-df) = ? THEN DO:
    MESSAGE "Can not find a file of this name.  Try again." 
       VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    APPLY "ENTRY" TO df-file IN FRAME read-df.
    RETURN NO-APPLY.
  END.
  ELSE
    ASSIGN df-file = df-file:SCREEN-VALUE IN FRAME read-df.

  IF osh_dbname:SCREEN-VALUE IN FRAME read-df = "" OR 
              osh_dbname:SCREEN-VALUE IN FRAME read-df = ? THEN DO:
    MESSAGE "Schema Holder Name is required."  VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY" TO osh_dbname IN FRAME read-df.
    RETURN NO-APPLY. 
  END.
  
  IF mss_username:SCREEN-VALUE IN FRAME read-df = "" OR 
              mss_username:SCREEN-VALUE IN FRAME read-df = ? THEN DO:
    MESSAGE "MSS Object Owner Name is required."  VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY" TO mss_username IN FRAME read-df.
    RETURN NO-APPLY. 
  END.

  REPEAT l_dbnr = 1 to NUM-DBS:
    IF LDBNAME("DICTDB") = LDBNAME(l_dbnr)
     THEN ASSIGN l_curr-db = l_dbnr.
  END.
  
  DO i = 1 TO NUM-DBS:
    IF PDBNAME(i) = osh_dbname:SCREEN-VALUE IN FRAME read-df OR 
       LDBNAME(i) = osh_dbname:SCREEN-VALUE IN FRAME read-df THEN DO:
      ASSIGN schdbcon = TRUE.
      CREATE ALIAS DICTDB FOR DATABASE 
         VALUE(LDBNAME(osh_dbname:SCREEN-VALUE IN FRAME read-df)).
    END.
  END.
  IF NOT schdbcon THEN DO:
    ASSIGN conparms = mss_conparms:SCREEN-VALUE IN FRAME read-df +  
                            " -ld schdb".
    CONNECT VALUE(osh_dbname:SCREEN-VALUE IN FRAME read-df) 
            VALUE(conparms) NO-ERROR.
    IF NOT CONNECTED(LDBNAME(osh_dbname:SCREEN-VALUE IN FRAME read-df)) THEN DO:
      MESSAGE osh_dbname:SCREEN-VALUE IN FRAME read-df
         " can not be connected using entered connect parameters."
        VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" to osh_dbname IN FRAME read-df.
      RETURN NO-APPLY.
     END.
  END.
END.

/*----- HELP in MSS Incremental Utility FRAME read-df -----*/
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
on HELP of frame read-df or CHOOSE of btn_Help in frame read-df
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                             INPUT {&Incremental_Schema_Migration_Dlg_Box},
                             INPUT ?).
&ENDIF

on WINDOW-CLOSE of frame read-df
   apply "END-ERROR" to frame read-df.

ON LEAVE OF df-file in frame read-df
   df-file:screen-value in frame read-df = 
        TRIM(df-file:screen-value in frame read-df).

ON CHOOSE OF btn_File in frame read-df DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT df-file:handle in frame read-df /*Fillin*/,
        INPUT "Find Input File"  /*Title*/,
        INPUT "*.df"                 /*Filter*/,
        INPUT yes                /*Must exist*/).
END.
/*==========================Mainline code=============================*/        

{adecomm/okrun.i  
    &FRAME  = "FRAME read-df" 
    &BOX    = "rect_Btns"
    &OK     = "btn_OK" 
    {&CAN_BTN}
}
 
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
   btn_Help:visible IN FRAME read-df = yes.
&ENDIF

IF LDBNAME("DICTDB") <> ? THEN DO:
  FOR EACH DICTDB._DB NO-LOCK:
    IF DICTDB._Db._Db-type = "PROGRESS" THEN
      ASSIGN osh_dbname = LDBNAME ("DICTDB")
             mss_conparms = "<current working database>".
    ELSE IF DICTDB._Db._Db-type = "MSS" THEN
      ASSIGN mss_dbname = DICTDB._Db._Db-name
             shadowcol = (IF _Db-misc1[1] = 0 THEN TRUE ELSE FALSE).             
  END.
END.

ASSIGN pcompatible = TRUE
       long-length = 8000.       

UPDATE df-file 
       btn_file
       osh_dbname
       mss_conparms
       mss_dbname
       mss_username
       long-length
       pcompatible
       shadowcol WHEN shadowcol = TRUE
       dflt
       sqlwidth  
       create_df
       btn_OK btn_Cancel
       &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
            btn_Help
       &ENDIF
  WITH FRAME read-df.
       
ASSIGN user_env[1]  = df-file
       user_env[3]  = ""
       user_env[4]  = "n"
       user_env[5]  = "go"
       user_env[6]  = "y"
       user_env[7]  = (IF dflt THEN "y" ELSE "n")
       user_env[8]  = "y"
       user_env[9]  = "ALL"
       user_env[10] = string(long-length)
       user_env[11] = "varchar" 
       user_env[12] = "datetime"
       user_env[13] = "tinyint"
       user_env[14] = "integer"
       user_env[15] = "decimal(18,5)"
       user_env[16] = "decimal"
       user_env[17] = "integer"
       user_env[18] = "text"
       user_env[19] = "tinyint"
       user_env[20] = "##"  
       user_env[21] = (IF shadowcol THEN "y" ELSE "n")
       user_env[22] = "MSS"
       user_env[23] = "30"
       user_env[24] = "15"
       user_env[25] = "y" 
       user_env[28] = "128"
       user_env[29] = "128"            
       user_env[30] = "y"
       user_env[31] = "-- ** "
       user_env[32] = "MSSQLSRV7".
    

/* create df for schema holder */
IF create_df THEN
  ASSIGN user_env[2] = "yes".
ELSE
  ASSIGN user_env[2] = "no".

RUN prodict/mss/_gendsql.p.
 
IF NOT schdbcon THEN 
   DISCONNECT DICTDB. 
ELSE DO:
  IF LDBNAME(l_curr-db) = ? THEN
    DELETE ALIAS DICTDB.
  ELSE
    RUN adecomm/_setalia.p
        ( INPUT l_curr-db
        ).
END.

    


