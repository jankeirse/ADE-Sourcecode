DEFINE TEMP-TABLE ttFixProgram NO-UNDO
  FIELD iProgNo   AS INTEGER
  FIELD cProgName AS CHARACTER
  FIELD cFullProgPath AS CHARACTER
  INDEX pudx IS UNIQUE PRIMARY
    iProgNo
  INDEX udx IS UNIQUE
    cProgName
  .