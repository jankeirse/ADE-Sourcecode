&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" vTableWin _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" vTableWin _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE RowObject
       {"af/obj2/gsmtlfullo.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
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
/*---------------------------------------------------------------------------------
  File: gsmtlviewv.w

  Description:  Translation Viewer

  Purpose:      Translation Viewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   10/18/2001  Author:     

  Update Notes: Added extra option in combo-box for Tab Folder Page.

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       gsmtlviewv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{af/sup2/afglobals.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "af/obj2/gsmtlfullo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.widget_type RowObject.widget_name ~
RowObject.widget_entry RowObject.original_label RowObject.translation_label ~
RowObject.original_tooltip RowObject.translation_tooltip 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define DISPLAYED-FIELDS RowObject.widget_type RowObject.widget_name ~
RowObject.widget_entry RowObject.original_label RowObject.translation_label ~
RowObject.original_tooltip RowObject.translation_tooltip 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_dynlookup AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gsclgdcs2v AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     RowObject.widget_type AT ROW 3.1 COL 23.4 COLON-ALIGNED
          VIEW-AS COMBO-BOX SORT INNER-LINES 5
          LIST-ITEM-PAIRS "Window Title","TITLE",
                     "Browse Column","BROWSE",
                     "Fill In","FILL-IN",
                     "Radio Set","RADIO-SET",
                     "Text Field","TEXT",
                     "Button","BUTTON",
                     "Toggle Box","TOGGLE-BOX",
                     "Combo Box","COMBO-BOX",
                     "Slider","SLIDER",
                     "Editor","EDITOR",
                     "Tab Folder Page","TAB"
          DROP-DOWN-LIST
          SIZE 51.2 BY 1
     RowObject.widget_name AT ROW 4.1 COL 23.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 51.2 BY 1
     RowObject.widget_entry AT ROW 4.1 COL 95 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.2 BY 1
     RowObject.original_label AT ROW 5.1 COL 23.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 78 BY 1
     RowObject.translation_label AT ROW 6.1 COL 23.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 78 BY 1
     RowObject.original_tooltip AT ROW 7.1 COL 23.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 78 BY 1
     RowObject.translation_tooltip AT ROW 8.1 COL 23.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 78 BY 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "af/obj2/gsmtlfullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {af/obj2/gsmtlfullo.i}
      END-FIELDS.
   END-TABLES.
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW vTableWin ASSIGN
         HEIGHT             = 8.71
         WIDTH              = 109.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB vTableWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW vTableWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK vTableWin 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects vTableWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE currentPage  AS INTEGER NO-UNDO.

  ASSIGN currentPage = getCurrentPage().

  CASE currentPage: 

    WHEN 0 THEN DO:
       RUN constructObject (
             INPUT  'af/obj2/gsclgdcs2v.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'FieldNamelanguage_objDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_gsclgdcs2v ).
       RUN repositionObject IN h_gsclgdcs2v ( 1.00 , 12.60 ) NO-ERROR.
       RUN resizeObject IN h_gsclgdcs2v ( 1.05 , 65.20 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_object.object_filenameKeyFieldgsc_object.object_filenameFieldLabelObject FilenameFieldTooltipEnter Object Filename or Press F4 for Object LookupKeyFormatX(35)KeyDatatypecharacterDisplayFormatX(35)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object NO-LOCK
                     BY gsc_object.object_filenameQueryTablesgsc_objectBrowseFieldsgsc_object.object_filename,gsc_object.object_descriptionBrowseFieldDataTypescharacter,characterBrowseFieldFormatsX(35),X(35)RowsToBatch200BrowseTitleLookup ObjectsViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOFieldNameobject_filenameDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dynlookup ).
       RUN repositionObject IN h_dynlookup ( 2.05 , 25.40 ) NO-ERROR.
       RUN resizeObject IN h_dynlookup ( 1.00 , 51.20 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_gsclgdcs2v ,
             RowObject.widget_type:HANDLE IN FRAME frMain , 'BEFORE':U ).
       RUN adjustTabOrder ( h_dynlookup ,
             h_gsclgdcs2v , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI vTableWin  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME frMain.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RTB_xref_generator vTableWin 
PROCEDURE RTB_xref_generator :
/* -----------------------------------------------------------
Purpose:    Generate RTB xrefs for SMARTOBJECTS.
Parameters: <none>
Notes:      This code is generated by the UIB.  DO NOT modify it.
            It is included for Roundtable Xref generation. Without
            it, Xrefs for SMARTOBJECTS could not be maintained by
            RTB.  It will in no way affect the operation of this
            program as it never gets executed.
-------------------------------------------------------------*/
  RUN "af\obj2\gsclgdcs2v.w *RTB-SmObj* ".
  RUN "adm2/dynlookup.w *RTB-SmObj* ".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
