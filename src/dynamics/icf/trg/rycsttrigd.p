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
* Contributors: MIP Holdings (Pty) Ltd ("MIP")                       *
*               PSC                                                  *
*                                                                    *
*********************************************************************/

TRIGGER PROCEDURE FOR DELETE OF ryc_smartlink_type .

/* Created automatically using ERwin ICF Trigger template db/af/erw/afercustrg.i
   Do not change manually. Customisations to triggers should be placed in separate
   include files pulled into the trigger. ICF auto generates write trigger custom
   include files. Delete or create customisation include files need to be created
   manually. Be sure to put the hook in ERwin directly so as not to have you changes
   overwritten.
   User defined Macro (UDP) Summary (case sensitive)
   ryc_smartlink_type           Expands to full table name, e.g. gsm_user
   %TableFLA            Expands to table unique code, e.g. gsmus
   %TableObj            If blank or not defined expands to table_obj with no prefix (framework standard)
                        If defined, uses this field as the object field
                        If set to "none" then indicates table does not have an object field
   XYZ                  Do not define so we can compare against an empty string

   See docs for explanation of replication macros 
*/   

&SCOPED-DEFINE TRIGGER_TABLE ryc_smartlink_type
&SCOPED-DEFINE TRIGGER_FLA rycst
&SCOPED-DEFINE TRIGGER_OBJ smartlink_type_obj


DEFINE BUFFER lb_table FOR ryc_smartlink_type.      /* Used for recursive relationships */
DEFINE BUFFER lb1_table FOR ryc_smartlink_type.     /* Used for lock upgrades */

DEFINE BUFFER o_ryc_smartlink_type FOR ryc_smartlink_type.

/* Standard top of DELETE trigger code */
{af/sup/aftrigtopd.i}

  




/* Generated by ICF ERwin Template */
/* ryc_smartlink_type is supported by ryc_supported_link ON PARENT DELETE CASCADE */
&IF DEFINED(lbe_supported_link) = 0 &THEN
  DEFINE BUFFER lbe_supported_link FOR ryc_supported_link.
  &GLOBAL-DEFINE lbe_supported_link yes
&ENDIF
FOR EACH ryc_supported_link NO-LOCK
   WHERE ryc_supported_link.smartlink_type_obj = ryc_smartlink_type.smartlink_type_obj
   ON STOP UNDO, RETURN ERROR "AF^104^rycsttrigd.p^delete ryc_supported_link":U:
    FIND FIRST lbe_supported_link EXCLUSIVE-LOCK
         WHERE ROWID(lbe_supported_link) = ROWID(ryc_supported_link)
         NO-ERROR.
    IF AVAILABLE lbe_supported_link THEN
      DO:
        {af/sup/afvalidtrg.i &action = "DELETE" &table = "lbe_supported_link"}
      END.
END.





/* Generated by ICF ERwin Template */
/* ryc_smartlink_type identifies ryc_smartlink ON PARENT DELETE RESTRICT */
IF CAN-FIND(FIRST ryc_smartlink WHERE
    ryc_smartlink.smartlink_type_obj = ryc_smartlink_type.smartlink_type_obj) THEN
    DO:
      /* Cannot delete parent because child exists! */
      ASSIGN lv-error = YES lv-errgrp = "AF ":U lv-errnum = 101 lv-include = "ryc_smartlink_type|ryc_smartlink":U.
      RUN error-message (lv-errgrp, lv-errnum, lv-include).
    END.












/* Update Audit Log */
IF CAN-FIND(FIRST gsc_entity_mnemonic
            WHERE gsc_entity_mnemonic.entity_mnemonic = 'rycst':U
              AND gsc_entity_mnemonic.auditing_enabled = YES) THEN
  RUN af/app/afauditlgp.p (INPUT "DELETE":U, INPUT "rycst":U, INPUT BUFFER ryc_smartlink_type:HANDLE, INPUT BUFFER o_ryc_smartlink_type:HANDLE).

/* Standard bottom of DELETE trigger code */
{af/sup/aftrigendd.i}


/* Place any specific DELETE trigger customisations here */