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

TRIGGER PROCEDURE FOR DELETE OF ryc_relationship .

/* Created automatically using ERwin ICF Trigger template db/af/erw/afercustrg.i
   Do not change manually. Customisations to triggers should be placed in separate
   include files pulled into the trigger. ICF auto generates write trigger custom
   include files. Delete or create customisation include files need to be created
   manually. Be sure to put the hook in ERwin directly so as not to have you changes
   overwritten.
   User defined Macro (UDP) Summary (case sensitive)
   ryc_relationship           Expands to full table name, e.g. gsm_user
   %TableFLA            Expands to table unique code, e.g. gsmus
   %TableObj            If blank or not defined expands to table_obj with no prefix (framework standard)
                        If defined, uses this field as the object field
                        If set to "none" then indicates table does not have an object field
   XYZ                  Do not define so we can compare against an empty string

   See docs for explanation of replication macros 
*/   

&SCOPED-DEFINE TRIGGER_TABLE ryc_relationship
&SCOPED-DEFINE TRIGGER_FLA rycre
&SCOPED-DEFINE TRIGGER_OBJ relationship_obj


DEFINE BUFFER lb_table FOR ryc_relationship.      /* Used for recursive relationships */
DEFINE BUFFER lb1_table FOR ryc_relationship.     /* Used for lock upgrades */

DEFINE BUFFER o_ryc_relationship FOR ryc_relationship.

/* Standard top of DELETE trigger code */
{af/sup/aftrigtopd.i}

  




/* Generated by ICF ERwin Template */
/* ryc_relationship is the join for gsc_dataset_entity ON PARENT DELETE SET NULL */

&IF DEFINED(lbe_dataset_entity) = 0 &THEN
  DEFINE BUFFER lbe_dataset_entity FOR gsc_dataset_entity.
  &GLOBAL-DEFINE lbe_dataset_entity yes
&ENDIF
FOR EACH gsc_dataset_entity NO-LOCK
   WHERE gsc_dataset_entity.relationship_obj = ryc_relationship.relationship_obj
   ON STOP UNDO, RETURN ERROR "AF^104^rycretrigd.p^update gsc_dataset_entity":U:
    FIND FIRST lbe_dataset_entity EXCLUSIVE-LOCK
         WHERE ROWID(lbe_dataset_entity) = ROWID(gsc_dataset_entity)
         NO-ERROR.
    IF AVAILABLE lbe_dataset_entity THEN
      DO:
        
        ASSIGN lbe_dataset_entity.relationship_obj = 0 .
      END.
END.



/* Generated by ICF ERwin Template */
/* ryc_relationship is joined using ryc_relationship_field ON PARENT DELETE RESTRICT */
IF CAN-FIND(FIRST ryc_relationship_field WHERE
    ryc_relationship_field.relationship_obj = ryc_relationship.relationship_obj) THEN
    DO:
      /* Cannot delete parent because child exists! */
      ASSIGN lv-error = YES lv-errgrp = "AF ":U lv-errnum = 101 lv-include = "ryc_relationship|ryc_relationship_field":U.
      RUN error-message (lv-errgrp, lv-errnum, lv-include).
    END.












/* Update Audit Log */
IF CAN-FIND(FIRST gsc_entity_mnemonic
            WHERE gsc_entity_mnemonic.entity_mnemonic = 'rycre':U
              AND gsc_entity_mnemonic.auditing_enabled = YES) THEN
  RUN af/app/afauditlgp.p (INPUT "DELETE":U, INPUT "rycre":U, INPUT BUFFER ryc_relationship:HANDLE, INPUT BUFFER o_ryc_relationship:HANDLE).

/* Standard bottom of DELETE trigger code */
{af/sup/aftrigendd.i}


/* Place any specific DELETE trigger customisations here */