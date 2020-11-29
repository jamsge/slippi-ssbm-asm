################################################################################
# Address: 8009e090
################################################################################
.include "Common/Common.s"

# setup mtx for fighter jobj
  lwz r3,0x28(r27)
  bl JOBJ_SetupMatrixSubAll
  b Exit

#######################
JOBJ_SetupMatrixSubAll:
# r3 = jobj
# f1 = alpha

.set REG_JObj, 31

# backup jobj
  mflr r0
  stw	r0, 0x0004 (sp)
  stwu	sp, -0x0018 (sp)
  stw	REG_JObj, 0x0014 (sp)
  mr REG_JObj,r3

# ensure some flags are set
  lwz r3,0x14(REG_JObj)
  rlwinm. r0,r3,0,0x00800000
  bne JOBJ_SetupMatrixSubAll_Skip
  rlwinm. r0,r3,0,0x40
  beq JOBJ_SetupMatrixSubAll_Skip
  mr r3,REG_JObj
  branchl r12,0x80373078
JOBJ_SetupMatrixSubAll_Skip:

# run on child
  lwz r3,0x10(REG_JObj)
  cmpwi r3,0
  beq 0x8
  bl  JOBJ_SetupMatrixSubAll
# run on sibling
  lwz r3,0x8(REG_JObj)
  cmpwi r3,0
  beq 0x8
  bl  JOBJ_SetupMatrixSubAll

JOBJ_SetupMatrixSubAll_Exit:
  lwz	REG_JObj, 0x0014 (sp)
  lwz r0,0x1C(sp)
  addi	sp, sp, 0x0018
  mtlr r0
  blr
#######################

Exit:
lmw	r24, 0x0028 (sp)