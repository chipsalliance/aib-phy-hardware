// file = 0; split type = patterns; threshold = 100000; total count = 0.
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include "rmapats.h"

void  hsG_0__0 (struct dummyq_struct * I1381, EBLK  * I1376, U  I616);
void  hsG_0__0 (struct dummyq_struct * I1381, EBLK  * I1376, U  I616)
{
    U  I1644;
    U  I1645;
    U  I1646;
    struct futq * I1647;
    struct dummyq_struct * pQ = I1381;
    I1644 = ((U )vcs_clocks) + I616;
    I1646 = I1644 & ((1 << fHashTableSize) - 1);
    I1376->I662 = (EBLK  *)(-1);
    I1376->I663 = I1644;
    if (0 && rmaProfEvtProp) {
        vcs_simpSetEBlkEvtID(I1376);
    }
    if (I1644 < (U )vcs_clocks) {
        I1645 = ((U  *)&vcs_clocks)[1];
        sched_millenium(pQ, I1376, I1645 + 1, I1644);
    }
    else if ((peblkFutQ1Head != ((void *)0)) && (I616 == 1)) {
        I1376->I665 = (struct eblk *)peblkFutQ1Tail;
        peblkFutQ1Tail->I662 = I1376;
        peblkFutQ1Tail = I1376;
    }
    else if ((I1647 = pQ->I1284[I1646].I685)) {
        I1376->I665 = (struct eblk *)I1647->I683;
        I1647->I683->I662 = (RP )I1376;
        I1647->I683 = (RmaEblk  *)I1376;
    }
    else {
        sched_hsopt(pQ, I1376, I1644);
    }
}
void  hs_0_M_109_0__simv_daidir (UB  * pcode, scalar  val)
{
    UB  * I1713;
    *(pcode + 0) = val;
    *(pcode + 1) = X4val[val];
    RmaRtlXEdgesHdr  * I993 = (RmaRtlXEdgesHdr  *)(pcode + 8);
    RmaRtlEdgeBlock  * I721;
    U  I58 = I993->I58;
    scalar  I753 = (((I58) >> (16)) & ((1 << (8)) - 1));
    US  I1525 = (1 << (((I753) << 2) + (X4val[val])));
    if (I1525 & 31692) {
        rmaSchedRtlXEdges(I993, I1525, X4val[val]);
    }
    (I58) = (((I58) & ~(((U )((1 << (8)) - 1)) << (16))) | ((X4val[val]) << (16)));
    I993->I58 = I58;
    {
        unsigned long long * I1771 = derivedClk + (4U * X4val[val]);
        memcpy(pcode + 104 + 4, I1771, 25U);
    }
    {
        {
            RP  I1570;
            RP  * I653 = (RP  *)(pcode + 136);
            {
                I1570 = *I653;
                if (I1570) {
                    hsimDispatchCbkMemOptNoDynElabS(I653, val, 0U);
                }
            }
        }
    }
    {
        scalar  I1603;
        scalar  I1513;
        U  I1558;
        U  I1610;
        U  I1611;
        EBLK  * I1376;
        struct dummyq_struct * pQ;
        U  I1379;
        I1379 = 0;
        pQ = (struct dummyq_struct *)ref_vcs_clocks;
        I1513 = X4val[val];
        I1603 = *(pcode + 144);
        *(pcode + 144) = I1513;
        I1558 = (I1603 << 2) + I1513;
        I1558 = 1 << I1558;
        if (I1558 & 16) {
            if (getCurSchedRegion()) {
                SchedSemiLerTBReactiveRegion_th((struct eblk *)(pcode + 152), I1379);
            }
            else {
                sched0_th(pQ, (EBLK  *)(pcode + 152));
            }
        }
        if (I1558 & 2) {
            if (getCurSchedRegion()) {
                SchedSemiLerTBReactiveRegion_th((struct eblk *)(pcode + 192), I1379);
            }
            else {
                sched0_th(pQ, (EBLK  *)(pcode + 192));
            }
        }
    }
    {
        scalar  I1773 = X4val[val];
        scalar  I1774 = *(scalar  *)(pcode + 232 + 2U);
        *(scalar  *)(pcode + 232 + 2U) = I1773;
        UB  * I993 = *(UB  **)(pcode + 232 + 8U);
        if (I993) {
            U  I1775 = I1773 * 2;
            U  I1776 = 1 << ((I1774 << 2) + I1773);
            *(pcode + 232 + 0U) = 1;
            while (I993){
                UB  * I1778 = *(UB  **)(I993 + 16U);
                if ((*(US  *)(I993 + 0U)) & I1776) {
                    *(*(UB  **)(I993 + 48U)) = 1;
                    (*(FP  *)(I993 + 32U))((void *)(*(RP  *)(I993 + 40U)), (((*(scalar  *)(I993 + 2U)) >> I1775) & 3));
                }
                I993 = I1778;
            };
            *(pcode + 232 + 0U) = 0;
            rmaRemoveNonEdgeLoads(pcode + 232);
        }
    }
}
void  hs_0_M_151_0__simv_daidir (UB  * pcode, scalar  val)
{
    UB  * I1713;
    val = (scalar )(((RP )pcode) & 3);
    pcode = (UB  *)((RP )pcode & ~3);
    if (*(pcode + 0) == val) {
        return  ;
    }
    *(pcode + 0) = val;
    *(pcode + 1) = X4val[val];
    RmaRtlXEdgesHdr  * I993 = (RmaRtlXEdgesHdr  *)(pcode + 8);
    RmaRtlEdgeBlock  * I721;
    U  I58 = I993->I58;
    scalar  I753 = (((I58) >> (16)) & ((1 << (8)) - 1));
    US  I1525 = (1 << (((I753) << 2) + (X4val[val])));
    if (I1525 & 31692) {
        rmaSchedRtlXEdges(I993, I1525, X4val[val]);
    }
    (I58) = (((I58) & ~(((U )((1 << (8)) - 1)) << (16))) | ((X4val[val]) << (16)));
    I993->I58 = I58;
    {
        unsigned long long * I1771 = derivedClk + (4U * X4val[val]);
        memcpy(pcode + 104 + 4, I1771, 25U);
    }
    {
        {
            RP  I1570;
            RP  * I653 = (RP  *)(pcode + 136);
            {
                I1570 = *I653;
                if (I1570) {
                    hsimDispatchCbkMemOptNoDynElabS(I653, val, 0U);
                }
            }
        }
    }
    {
        scalar  I1603;
        scalar  I1513;
        U  I1558;
        U  I1610;
        U  I1611;
        EBLK  * I1376;
        struct dummyq_struct * pQ;
        U  I1379;
        I1379 = 0;
        pQ = (struct dummyq_struct *)ref_vcs_clocks;
        I1513 = X4val[val];
        I1603 = *(pcode + 144);
        *(pcode + 144) = I1513;
        I1558 = (I1603 << 2) + I1513;
        I1558 = 1 << I1558;
        if (I1558 & 12) {
            EBLK  * I1376 = (EBLK  *)((UB  *)(pcode + 152 + 0U));
            UB  * I1141 = (UB  *)I1376->I660;
            RP  I1112 = *(RP  *)(I1141 + 8U);
            if (I1112) {
                if ((I1376->I662 == 0)) {
                    U  I1608 = (X4val[val] << ((sizeof(U ) * 8) - 3));
                    U  I1077 = *(U  *)(I1141 + 4U);
                    I1077 &= ~(0x3 << ((sizeof(U ) * 8) - 3));
                    I1077 |= I1608;
                    *(U  *)(I1141 + 4U) = I1077;
                }
            }
            if (getCurSchedRegion()) {
                SchedSemiLerTBReactiveRegion_th((struct eblk *)(pcode + 152), I1379);
            }
            else {
                sched0_th(pQ, (EBLK  *)(pcode + 152));
            }
        }
        if (I1558 & 192) {
            EBLK  * I1376 = (EBLK  *)((UB  *)(pcode + 152 + 40U));
            UB  * I1141 = (UB  *)I1376->I660;
            RP  I1112 = *(RP  *)(I1141 + 8U);
            if (I1112) {
                if ((I1376->I662 == 0)) {
                    U  I1608 = (X4val[val] << ((sizeof(U ) * 8) - 3));
                    U  I1077 = *(U  *)(I1141 + 4U);
                    I1077 &= ~(0x3 << ((sizeof(U ) * 8) - 3));
                    I1077 |= I1608;
                    *(U  *)(I1141 + 4U) = I1077;
                }
            }
            if (getCurSchedRegion()) {
                SchedSemiLerTBReactiveRegion_th((struct eblk *)(pcode + 192), I1379);
            }
            else {
                sched0_th(pQ, (EBLK  *)(pcode + 192));
            }
        }
        if (I1558 & 18432) {
            EBLK  * I1376 = (EBLK  *)((UB  *)(pcode + 152 + 80U));
            UB  * I1141 = (UB  *)I1376->I660;
            RP  I1112 = *(RP  *)(I1141 + 8U);
            if (I1112) {
                if ((I1376->I662 == 0)) {
                    U  I1608 = (X4val[val] << ((sizeof(U ) * 8) - 3));
                    U  I1077 = *(U  *)(I1141 + 4U);
                    I1077 &= ~(0x3 << ((sizeof(U ) * 8) - 3));
                    I1077 |= I1608;
                    *(U  *)(I1141 + 4U) = I1077;
                }
            }
            if (getCurSchedRegion()) {
                SchedSemiLerTBReactiveRegion_th((struct eblk *)(pcode + 232), I1379);
            }
            else {
                sched0_th(pQ, (EBLK  *)(pcode + 232));
            }
        }
        if (I1558 & 2) {
            EBLK  * I1376 = (EBLK  *)((UB  *)(pcode + 152 + 120U));
            UB  * I1141 = (UB  *)I1376->I660;
            RP  I1112 = *(RP  *)(I1141 + 8U);
            if (I1112) {
                if ((I1376->I662 == 0)) {
                    U  I1608 = (X4val[val] << ((sizeof(U ) * 8) - 3));
                    U  I1077 = *(U  *)(I1141 + 4U);
                    I1077 &= ~(0x3 << ((sizeof(U ) * 8) - 3));
                    I1077 |= I1608;
                    *(U  *)(I1141 + 4U) = I1077;
                }
            }
            if (getCurSchedRegion()) {
                SchedSemiLerTBReactiveRegion_th((struct eblk *)(pcode + 272), I1379);
            }
            else {
                sched0_th(pQ, (EBLK  *)(pcode + 272));
            }
        }
        if (I1558 & 16) {
            EBLK  * I1376 = (EBLK  *)((UB  *)(pcode + 152 + 160U));
            UB  * I1141 = (UB  *)I1376->I660;
            RP  I1112 = *(RP  *)(I1141 + 8U);
            if (I1112) {
                if ((I1376->I662 == 0)) {
                    U  I1608 = (X4val[val] << ((sizeof(U ) * 8) - 3));
                    U  I1077 = *(U  *)(I1141 + 4U);
                    I1077 &= ~(0x3 << ((sizeof(U ) * 8) - 3));
                    I1077 |= I1608;
                    *(U  *)(I1141 + 4U) = I1077;
                }
            }
            if (getCurSchedRegion()) {
                SchedSemiLerTBReactiveRegion_th((struct eblk *)(pcode + 312), I1379);
            }
            else {
                sched0_th(pQ, (EBLK  *)(pcode + 312));
            }
        }
    }
    {
        scalar  I1603;
        scalar  I1513;
        U  I1558;
        U  I1610;
        U  I1611;
        RP  * I1562;
        US  * I1612;
        RP  I1613;
        EBLK  * I1376;
        struct dummyq_struct * pQ;
        U  I1379;
        I1379 = 0;
        pQ = (struct dummyq_struct *)ref_vcs_clocks;
        I1513 = X4val[val];
        I1603 = *(pcode + 352);
        *(pcode + 352) = I1513;
        I1558 = (I1603 << 2) + I1513;
        I1558 = 1 << I1558;
        I1562 = *(RP  **)(*(UB  **)(pcode + 360 + 0U + 8U) + 16U);
        I1612 = (US  *)(*(UB  **)(pcode + 360 + 0U + 8U) + 0U);
        if (I1562 && (I1558 & 12)) {
            *((US  *)I1612) |= (US )I1558;
            *(RP  **)(*(UB  **)(pcode + 360 + 0U + 8U) + 16U) = (RP  *)((RP )I1562 | 1);
            if (getCurSchedRegion()) {
                SchedSemiLerTBReactiveRegion_th((struct eblk *)(pcode + 360), I1379);
            }
            else {
                sched0_th(pQ, (EBLK  *)(pcode + 360));
            }
        }
        I1562 = *(RP  **)(*(UB  **)(pcode + 360 + 40U + 8U) + 16U);
        I1612 = (US  *)(*(UB  **)(pcode + 360 + 40U + 8U) + 0U);
        if (I1562 && (I1558 & 8704)) {
            *((US  *)I1612) |= (US )I1558;
            *(RP  **)(*(UB  **)(pcode + 360 + 40U + 8U) + 16U) = (RP  *)((RP )I1562 | 1);
            if (getCurSchedRegion()) {
                SchedSemiLerTBReactiveRegion_th((struct eblk *)(pcode + 400), I1379);
            }
            else {
                sched0_th(pQ, (EBLK  *)(pcode + 400));
            }
        }
        I1562 = *(RP  **)(*(UB  **)(pcode + 360 + 80U + 8U) + 16U);
        I1612 = (US  *)(*(UB  **)(pcode + 360 + 80U + 8U) + 0U);
        if (I1562 && (I1558 & 192)) {
            *((US  *)I1612) |= (US )I1558;
            *(RP  **)(*(UB  **)(pcode + 360 + 80U + 8U) + 16U) = (RP  *)((RP )I1562 | 1);
            if (getCurSchedRegion()) {
                SchedSemiLerTBReactiveRegion_th((struct eblk *)(pcode + 440), I1379);
            }
            else {
                sched0_th(pQ, (EBLK  *)(pcode + 440));
            }
        }
        I1562 = *(RP  **)(*(UB  **)(pcode + 360 + 120U + 8U) + 16U);
        I1612 = (US  *)(*(UB  **)(pcode + 360 + 120U + 8U) + 0U);
        if (I1562 && (I1558 & 4352)) {
            *((US  *)I1612) |= (US )I1558;
            *(RP  **)(*(UB  **)(pcode + 360 + 120U + 8U) + 16U) = (RP  *)((RP )I1562 | 1);
            if (getCurSchedRegion()) {
                SchedSemiLerTBReactiveRegion_th((struct eblk *)(pcode + 480), I1379);
            }
            else {
                sched0_th(pQ, (EBLK  *)(pcode + 480));
            }
        }
        I1562 = *(RP  **)(*(UB  **)(pcode + 360 + 160U + 8U) + 16U);
        I1612 = (US  *)(*(UB  **)(pcode + 360 + 160U + 8U) + 0U);
        if (I1562 && (I1558 & 18432)) {
            *((US  *)I1612) |= (US )I1558;
            *(RP  **)(*(UB  **)(pcode + 360 + 160U + 8U) + 16U) = (RP  *)((RP )I1562 | 1);
            if (getCurSchedRegion()) {
                SchedSemiLerTBReactiveRegion_th((struct eblk *)(pcode + 520), I1379);
            }
            else {
                sched0_th(pQ, (EBLK  *)(pcode + 520));
            }
        }
        I1562 = *(RP  **)(*(UB  **)(pcode + 360 + 200U + 8U) + 16U);
        I1612 = (US  *)(*(UB  **)(pcode + 360 + 200U + 8U) + 0U);
        if (I1562 && (I1558 & 2)) {
            *((US  *)I1612) |= (US )I1558;
            *(RP  **)(*(UB  **)(pcode + 360 + 200U + 8U) + 16U) = (RP  *)((RP )I1562 | 1);
            if (getCurSchedRegion()) {
                SchedSemiLerTBReactiveRegion_th((struct eblk *)(pcode + 560), I1379);
            }
            else {
                sched0_th(pQ, (EBLK  *)(pcode + 560));
            }
        }
        I1562 = *(RP  **)(*(UB  **)(pcode + 360 + 240U + 8U) + 16U);
        I1612 = (US  *)(*(UB  **)(pcode + 360 + 240U + 8U) + 0U);
        if (I1562 && (I1558 & 16)) {
            *((US  *)I1612) |= (US )I1558;
            *(RP  **)(*(UB  **)(pcode + 360 + 240U + 8U) + 16U) = (RP  *)((RP )I1562 | 1);
            if (getCurSchedRegion()) {
                SchedSemiLerTBReactiveRegion_th((struct eblk *)(pcode + 600), I1379);
            }
            else {
                sched0_th(pQ, (EBLK  *)(pcode + 600));
            }
        }
    }
    {
        scalar  I1773 = X4val[val];
        scalar  I1774 = *(scalar  *)(pcode + 640 + 2U);
        *(scalar  *)(pcode + 640 + 2U) = I1773;
        UB  * I993 = *(UB  **)(pcode + 640 + 8U);
        if (I993) {
            U  I1775 = I1773 * 2;
            U  I1776 = 1 << ((I1774 << 2) + I1773);
            *(pcode + 640 + 0U) = 1;
            while (I993){
                UB  * I1778 = *(UB  **)(I993 + 16U);
                if ((*(US  *)(I993 + 0U)) & I1776) {
                    *(*(UB  **)(I993 + 48U)) = 1;
                    (*(FP  *)(I993 + 32U))((void *)(*(RP  *)(I993 + 40U)), (((*(scalar  *)(I993 + 2U)) >> I1775) & 3));
                }
                I993 = I1778;
            };
            *(pcode + 640 + 0U) = 0;
            rmaRemoveNonEdgeLoads(pcode + 640);
        }
    }
}
void  hs_0_M_164_0__simv_daidir (UB  * pcode, scalar  val)
{
    UB  * I1713;
    *(pcode + 0) = val;
    RmaRtlXEdgesHdr  * I993 = (RmaRtlXEdgesHdr  *)(pcode + 8);
    RmaRtlEdgeBlock  * I721;
    U  I58 = I993->I58;
    scalar  I753 = (((I58) >> (16)) & ((1 << (8)) - 1));
    US  I1525 = (1 << (((I753) << 2) + (X4val[val])));
    if (I1525 & 31692) {
        rmaSchedRtlXEdges(I993, I1525, X4val[val]);
    }
    (I58) = (((I58) & ~(((U )((1 << (8)) - 1)) << (16))) | ((X4val[val]) << (16)));
    I993->I58 = I58;
    {
        unsigned long long * I1771 = derivedClk + (4U * X4val[val]);
        memcpy(pcode + 104 + 4, I1771, 25U);
    }
    {
        {
            RP  I1570;
            RP  * I653 = (RP  *)(pcode + 136);
            {
                I1570 = *I653;
                if (I1570) {
                    hsimDispatchCbkMemOptNoDynElabS(I653, val, 0U);
                }
            }
        }
    }
    {
        scalar  I1603;
        scalar  I1513;
        U  I1558;
        U  I1610;
        U  I1611;
        EBLK  * I1376;
        struct dummyq_struct * pQ;
        U  I1379;
        I1379 = 0;
        pQ = (struct dummyq_struct *)ref_vcs_clocks;
        I1513 = X4val[val];
        I1603 = *(pcode + 144);
        *(pcode + 144) = I1513;
        I1558 = (I1603 << 2) + I1513;
        I1558 = 1 << I1558;
        if (I1558 & 2) {
            EBLK  * I1376 = (EBLK  *)((UB  *)(pcode + 152 + 0U));
            UB  * I1141 = (UB  *)I1376->I660;
            RP  I1112 = *(RP  *)(I1141 + 8U);
            if (I1112) {
                if ((I1376->I662 == 0)) {
                    U  I1608 = (X4val[val] << ((sizeof(U ) * 8) - 3));
                    U  I1077 = *(U  *)(I1141 + 4U);
                    I1077 &= ~(0x3 << ((sizeof(U ) * 8) - 3));
                    I1077 |= I1608;
                    *(U  *)(I1141 + 4U) = I1077;
                }
            }
            if (getCurSchedRegion()) {
                SchedSemiLerTBReactiveRegion_th((struct eblk *)(pcode + 152), I1379);
            }
            else {
                sched0_th(pQ, (EBLK  *)(pcode + 152));
            }
        }
        if (I1558 & 16) {
            EBLK  * I1376 = (EBLK  *)((UB  *)(pcode + 152 + 40U));
            UB  * I1141 = (UB  *)I1376->I660;
            RP  I1112 = *(RP  *)(I1141 + 8U);
            if (I1112) {
                if ((I1376->I662 == 0)) {
                    U  I1608 = (X4val[val] << ((sizeof(U ) * 8) - 3));
                    U  I1077 = *(U  *)(I1141 + 4U);
                    I1077 &= ~(0x3 << ((sizeof(U ) * 8) - 3));
                    I1077 |= I1608;
                    *(U  *)(I1141 + 4U) = I1077;
                }
            }
            if (getCurSchedRegion()) {
                SchedSemiLerTBReactiveRegion_th((struct eblk *)(pcode + 192), I1379);
            }
            else {
                sched0_th(pQ, (EBLK  *)(pcode + 192));
            }
        }
    }
    {
        scalar  I1603;
        scalar  I1513;
        U  I1558;
        U  I1610;
        U  I1611;
        RP  * I1562;
        US  * I1612;
        RP  I1613;
        EBLK  * I1376;
        struct dummyq_struct * pQ;
        U  I1379;
        I1379 = 0;
        pQ = (struct dummyq_struct *)ref_vcs_clocks;
        I1513 = X4val[val];
        I1603 = *(pcode + 232);
        *(pcode + 232) = I1513;
        I1558 = (I1603 << 2) + I1513;
        I1558 = 1 << I1558;
        I1562 = *(RP  **)(*(UB  **)(pcode + 240 + 0U + 8U) + 16U);
        I1612 = (US  *)(*(UB  **)(pcode + 240 + 0U + 8U) + 0U);
        if (I1562 && (I1558 & 12)) {
            *((US  *)I1612) |= (US )I1558;
            *(RP  **)(*(UB  **)(pcode + 240 + 0U + 8U) + 16U) = (RP  *)((RP )I1562 | 1);
            if (getCurSchedRegion()) {
                SchedSemiLerTBReactiveRegion_th((struct eblk *)(pcode + 240), I1379);
            }
            else {
                sched0_th(pQ, (EBLK  *)(pcode + 240));
            }
        }
        I1562 = *(RP  **)(*(UB  **)(pcode + 240 + 40U + 8U) + 16U);
        I1612 = (US  *)(*(UB  **)(pcode + 240 + 40U + 8U) + 0U);
        if (I1562 && (I1558 & 8704)) {
            *((US  *)I1612) |= (US )I1558;
            *(RP  **)(*(UB  **)(pcode + 240 + 40U + 8U) + 16U) = (RP  *)((RP )I1562 | 1);
            if (getCurSchedRegion()) {
                SchedSemiLerTBReactiveRegion_th((struct eblk *)(pcode + 280), I1379);
            }
            else {
                sched0_th(pQ, (EBLK  *)(pcode + 280));
            }
        }
        I1562 = *(RP  **)(*(UB  **)(pcode + 240 + 80U + 8U) + 16U);
        I1612 = (US  *)(*(UB  **)(pcode + 240 + 80U + 8U) + 0U);
        if (I1562 && (I1558 & 192)) {
            *((US  *)I1612) |= (US )I1558;
            *(RP  **)(*(UB  **)(pcode + 240 + 80U + 8U) + 16U) = (RP  *)((RP )I1562 | 1);
            if (getCurSchedRegion()) {
                SchedSemiLerTBReactiveRegion_th((struct eblk *)(pcode + 320), I1379);
            }
            else {
                sched0_th(pQ, (EBLK  *)(pcode + 320));
            }
        }
        I1562 = *(RP  **)(*(UB  **)(pcode + 240 + 120U + 8U) + 16U);
        I1612 = (US  *)(*(UB  **)(pcode + 240 + 120U + 8U) + 0U);
        if (I1562 && (I1558 & 4352)) {
            *((US  *)I1612) |= (US )I1558;
            *(RP  **)(*(UB  **)(pcode + 240 + 120U + 8U) + 16U) = (RP  *)((RP )I1562 | 1);
            if (getCurSchedRegion()) {
                SchedSemiLerTBReactiveRegion_th((struct eblk *)(pcode + 360), I1379);
            }
            else {
                sched0_th(pQ, (EBLK  *)(pcode + 360));
            }
        }
        I1562 = *(RP  **)(*(UB  **)(pcode + 240 + 160U + 8U) + 16U);
        I1612 = (US  *)(*(UB  **)(pcode + 240 + 160U + 8U) + 0U);
        if (I1562 && (I1558 & 18432)) {
            *((US  *)I1612) |= (US )I1558;
            *(RP  **)(*(UB  **)(pcode + 240 + 160U + 8U) + 16U) = (RP  *)((RP )I1562 | 1);
            if (getCurSchedRegion()) {
                SchedSemiLerTBReactiveRegion_th((struct eblk *)(pcode + 400), I1379);
            }
            else {
                sched0_th(pQ, (EBLK  *)(pcode + 400));
            }
        }
        I1562 = *(RP  **)(*(UB  **)(pcode + 240 + 200U + 8U) + 16U);
        I1612 = (US  *)(*(UB  **)(pcode + 240 + 200U + 8U) + 0U);
        if (I1562 && (I1558 & 2)) {
            *((US  *)I1612) |= (US )I1558;
            *(RP  **)(*(UB  **)(pcode + 240 + 200U + 8U) + 16U) = (RP  *)((RP )I1562 | 1);
            if (getCurSchedRegion()) {
                SchedSemiLerTBReactiveRegion_th((struct eblk *)(pcode + 440), I1379);
            }
            else {
                sched0_th(pQ, (EBLK  *)(pcode + 440));
            }
        }
        I1562 = *(RP  **)(*(UB  **)(pcode + 240 + 240U + 8U) + 16U);
        I1612 = (US  *)(*(UB  **)(pcode + 240 + 240U + 8U) + 0U);
        if (I1562 && (I1558 & 16)) {
            *((US  *)I1612) |= (US )I1558;
            *(RP  **)(*(UB  **)(pcode + 240 + 240U + 8U) + 16U) = (RP  *)((RP )I1562 | 1);
            if (getCurSchedRegion()) {
                SchedSemiLerTBReactiveRegion_th((struct eblk *)(pcode + 480), I1379);
            }
            else {
                sched0_th(pQ, (EBLK  *)(pcode + 480));
            }
        }
    }
    {
        scalar  I1773 = X4val[val];
        scalar  I1774 = *(scalar  *)(pcode + 520 + 2U);
        *(scalar  *)(pcode + 520 + 2U) = I1773;
        UB  * I993 = *(UB  **)(pcode + 520 + 8U);
        if (I993) {
            U  I1775 = I1773 * 2;
            U  I1776 = 1 << ((I1774 << 2) + I1773);
            *(pcode + 520 + 0U) = 1;
            while (I993){
                UB  * I1778 = *(UB  **)(I993 + 16U);
                if ((*(US  *)(I993 + 0U)) & I1776) {
                    *(*(UB  **)(I993 + 48U)) = 1;
                    (*(FP  *)(I993 + 32U))((void *)(*(RP  *)(I993 + 40U)), (((*(scalar  *)(I993 + 2U)) >> I1775) & 3));
                }
                I993 = I1778;
            };
            *(pcode + 520 + 0U) = 0;
            rmaRemoveNonEdgeLoads(pcode + 520);
        }
    }
    {
        typedef
        US
         stateType;
        scalar  newval;
        stateType  state;
        U  iinput;
        UB  * pcode1;
        UB  * I1382;
        UB  * I1485;
        pcode += 560;
        {
            typedef
            US
             stateType;
            typedef
            US
             * stateTypePtr;
            pcode1 = *(UB  **)(pcode + 0);
            iinput = (U )(((RP )pcode1) & 7);
            pcode1 = (UB  *)(((RP )pcode1) & ~7);
            {
                RP  I1480 = 1;
                if (I1480) {
                    state = *(stateTypePtr )(pcode1 + 16U);
                    state &= ~(3 << (iinput * 2));
                    state |= X4val[val] << (iinput * 2);
                    *(stateTypePtr )(pcode1 + 16U) = state;
                    newval = *((*(UB  **)(pcode1 + 8U)) + state);
                    if (newval != *(pcode1 + 18U)) {
                        *(pcode1 + 18U) = newval;
                        (*(FP  *)(pcode1 + 0U))(pcode1, newval);
                    }
                }
            }
        }
    }
    {
        scalar  I1389;
        I1389 = val;
        (*(FP  *)(pcode + 8))(*(UB  **)(pcode + 16), I1389);
    }
}
void  hs_0_M_183_0__simv_daidir (UB  * pcode, scalar  val)
{
    UB  * I1713;
    *(pcode + 0) = val;
    RmaRtlXEdgesHdr  * I993 = (RmaRtlXEdgesHdr  *)(pcode + 8);
    RmaRtlEdgeBlock  * I721;
    U  I58 = I993->I58;
    scalar  I753 = (((I58) >> (16)) & ((1 << (8)) - 1));
    US  I1525 = (1 << (((I753) << 2) + (X4val[val])));
    if (I1525 & 31692) {
        rmaSchedRtlXEdges(I993, I1525, X4val[val]);
    }
    (I58) = (((I58) & ~(((U )((1 << (8)) - 1)) << (16))) | ((X4val[val]) << (16)));
    I993->I58 = I58;
    {
        unsigned long long * I1771 = derivedClk + (4U * X4val[val]);
        memcpy(pcode + 104 + 4, I1771, 25U);
    }
    {
        {
            RP  I1570;
            RP  * I653 = (RP  *)(pcode + 136);
            {
                I1570 = *I653;
                if (I1570) {
                    hsimDispatchCbkMemOptNoDynElabS(I653, val, 0U);
                }
            }
        }
    }
    {
        scalar  I1603;
        scalar  I1513;
        U  I1558;
        U  I1610;
        U  I1611;
        EBLK  * I1376;
        struct dummyq_struct * pQ;
        U  I1379;
        I1379 = 0;
        pQ = (struct dummyq_struct *)ref_vcs_clocks;
        I1513 = X4val[val];
        I1603 = *(pcode + 144);
        *(pcode + 144) = I1513;
        I1558 = (I1603 << 2) + I1513;
        I1558 = 1 << I1558;
        if (I1558 & 2) {
            if (getCurSchedRegion()) {
                SchedSemiLerTBReactiveRegion_th((struct eblk *)(pcode + 152), I1379);
            }
            else {
                sched0_th(pQ, (EBLK  *)(pcode + 152));
            }
        }
    }
    {
        scalar  I1603;
        scalar  I1513;
        U  I1558;
        U  I1610;
        U  I1611;
        RP  * I1562;
        US  * I1612;
        RP  I1613;
        EBLK  * I1376;
        struct dummyq_struct * pQ;
        U  I1379;
        I1379 = 0;
        pQ = (struct dummyq_struct *)ref_vcs_clocks;
        I1513 = X4val[val];
        I1603 = *(pcode + 192);
        *(pcode + 192) = I1513;
        I1558 = (I1603 << 2) + I1513;
        I1558 = 1 << I1558;
        I1562 = *(RP  **)(*(UB  **)(pcode + 200 + 0U + 8U) + 16U);
        I1612 = (US  *)(*(UB  **)(pcode + 200 + 0U + 8U) + 0U);
        if (I1562 && (I1558 & 12)) {
            *((US  *)I1612) |= (US )I1558;
            *(RP  **)(*(UB  **)(pcode + 200 + 0U + 8U) + 16U) = (RP  *)((RP )I1562 | 1);
            if (getCurSchedRegion()) {
                SchedSemiLerTBReactiveRegion_th((struct eblk *)(pcode + 200), I1379);
            }
            else {
                sched0_th(pQ, (EBLK  *)(pcode + 200));
            }
        }
        I1562 = *(RP  **)(*(UB  **)(pcode + 200 + 40U + 8U) + 16U);
        I1612 = (US  *)(*(UB  **)(pcode + 200 + 40U + 8U) + 0U);
        if (I1562 && (I1558 & 8704)) {
            *((US  *)I1612) |= (US )I1558;
            *(RP  **)(*(UB  **)(pcode + 200 + 40U + 8U) + 16U) = (RP  *)((RP )I1562 | 1);
            if (getCurSchedRegion()) {
                SchedSemiLerTBReactiveRegion_th((struct eblk *)(pcode + 240), I1379);
            }
            else {
                sched0_th(pQ, (EBLK  *)(pcode + 240));
            }
        }
        I1562 = *(RP  **)(*(UB  **)(pcode + 200 + 80U + 8U) + 16U);
        I1612 = (US  *)(*(UB  **)(pcode + 200 + 80U + 8U) + 0U);
        if (I1562 && (I1558 & 192)) {
            *((US  *)I1612) |= (US )I1558;
            *(RP  **)(*(UB  **)(pcode + 200 + 80U + 8U) + 16U) = (RP  *)((RP )I1562 | 1);
            if (getCurSchedRegion()) {
                SchedSemiLerTBReactiveRegion_th((struct eblk *)(pcode + 280), I1379);
            }
            else {
                sched0_th(pQ, (EBLK  *)(pcode + 280));
            }
        }
        I1562 = *(RP  **)(*(UB  **)(pcode + 200 + 120U + 8U) + 16U);
        I1612 = (US  *)(*(UB  **)(pcode + 200 + 120U + 8U) + 0U);
        if (I1562 && (I1558 & 4352)) {
            *((US  *)I1612) |= (US )I1558;
            *(RP  **)(*(UB  **)(pcode + 200 + 120U + 8U) + 16U) = (RP  *)((RP )I1562 | 1);
            if (getCurSchedRegion()) {
                SchedSemiLerTBReactiveRegion_th((struct eblk *)(pcode + 320), I1379);
            }
            else {
                sched0_th(pQ, (EBLK  *)(pcode + 320));
            }
        }
        I1562 = *(RP  **)(*(UB  **)(pcode + 200 + 160U + 8U) + 16U);
        I1612 = (US  *)(*(UB  **)(pcode + 200 + 160U + 8U) + 0U);
        if (I1562 && (I1558 & 18432)) {
            *((US  *)I1612) |= (US )I1558;
            *(RP  **)(*(UB  **)(pcode + 200 + 160U + 8U) + 16U) = (RP  *)((RP )I1562 | 1);
            if (getCurSchedRegion()) {
                SchedSemiLerTBReactiveRegion_th((struct eblk *)(pcode + 360), I1379);
            }
            else {
                sched0_th(pQ, (EBLK  *)(pcode + 360));
            }
        }
        I1562 = *(RP  **)(*(UB  **)(pcode + 200 + 200U + 8U) + 16U);
        I1612 = (US  *)(*(UB  **)(pcode + 200 + 200U + 8U) + 0U);
        if (I1562 && (I1558 & 2)) {
            *((US  *)I1612) |= (US )I1558;
            *(RP  **)(*(UB  **)(pcode + 200 + 200U + 8U) + 16U) = (RP  *)((RP )I1562 | 1);
            if (getCurSchedRegion()) {
                SchedSemiLerTBReactiveRegion_th((struct eblk *)(pcode + 400), I1379);
            }
            else {
                sched0_th(pQ, (EBLK  *)(pcode + 400));
            }
        }
        I1562 = *(RP  **)(*(UB  **)(pcode + 200 + 240U + 8U) + 16U);
        I1612 = (US  *)(*(UB  **)(pcode + 200 + 240U + 8U) + 0U);
        if (I1562 && (I1558 & 16)) {
            *((US  *)I1612) |= (US )I1558;
            *(RP  **)(*(UB  **)(pcode + 200 + 240U + 8U) + 16U) = (RP  *)((RP )I1562 | 1);
            if (getCurSchedRegion()) {
                SchedSemiLerTBReactiveRegion_th((struct eblk *)(pcode + 440), I1379);
            }
            else {
                sched0_th(pQ, (EBLK  *)(pcode + 440));
            }
        }
    }
    {
        scalar  I1773 = X4val[val];
        scalar  I1774 = *(scalar  *)(pcode + 480 + 2U);
        *(scalar  *)(pcode + 480 + 2U) = I1773;
        UB  * I993 = *(UB  **)(pcode + 480 + 8U);
        if (I993) {
            U  I1775 = I1773 * 2;
            U  I1776 = 1 << ((I1774 << 2) + I1773);
            *(pcode + 480 + 0U) = 1;
            while (I993){
                UB  * I1778 = *(UB  **)(I993 + 16U);
                if ((*(US  *)(I993 + 0U)) & I1776) {
                    *(*(UB  **)(I993 + 48U)) = 1;
                    (*(FP  *)(I993 + 32U))((void *)(*(RP  *)(I993 + 40U)), (((*(scalar  *)(I993 + 2U)) >> I1775) & 3));
                }
                I993 = I1778;
            };
            *(pcode + 480 + 0U) = 0;
            rmaRemoveNonEdgeLoads(pcode + 480);
        }
    }
}
void  hs_0_M_202_0__simv_daidir (UB  * pcode, scalar  val)
{
    UB  * I1713;
    *(pcode + 0) = val;
    RmaRtlXEdgesHdr  * I993 = (RmaRtlXEdgesHdr  *)(pcode + 8);
    RmaRtlEdgeBlock  * I721;
    U  I58 = I993->I58;
    scalar  I753 = (((I58) >> (16)) & ((1 << (8)) - 1));
    US  I1525 = (1 << (((I753) << 2) + (X4val[val])));
    if (I1525 & 31692) {
        rmaSchedRtlXEdges(I993, I1525, X4val[val]);
    }
    (I58) = (((I58) & ~(((U )((1 << (8)) - 1)) << (16))) | ((X4val[val]) << (16)));
    I993->I58 = I58;
    {
        unsigned long long * I1771 = derivedClk + (4U * X4val[val]);
        memcpy(pcode + 104 + 4, I1771, 25U);
    }
    {
        {
            RP  I1570;
            RP  * I653 = (RP  *)(pcode + 136);
            {
                I1570 = *I653;
                if (I1570) {
                    hsimDispatchCbkMemOptNoDynElabS(I653, val, 0U);
                }
            }
        }
    }
    {
        scalar  I1603;
        scalar  I1513;
        U  I1558;
        U  I1610;
        U  I1611;
        EBLK  * I1376;
        struct dummyq_struct * pQ;
        U  I1379;
        I1379 = 0;
        pQ = (struct dummyq_struct *)ref_vcs_clocks;
        I1513 = X4val[val];
        I1603 = *(pcode + 144);
        *(pcode + 144) = I1513;
        I1558 = (I1603 << 2) + I1513;
        I1558 = 1 << I1558;
        if (I1558 & 2) {
            if (getCurSchedRegion()) {
                SchedSemiLerTBReactiveRegion_th((struct eblk *)(pcode + 152), I1379);
            }
            else {
                sched0_th(pQ, (EBLK  *)(pcode + 152));
            }
        }
    }
    {
        scalar  I1773 = X4val[val];
        scalar  I1774 = *(scalar  *)(pcode + 192 + 2U);
        *(scalar  *)(pcode + 192 + 2U) = I1773;
        UB  * I993 = *(UB  **)(pcode + 192 + 8U);
        if (I993) {
            U  I1775 = I1773 * 2;
            U  I1776 = 1 << ((I1774 << 2) + I1773);
            *(pcode + 192 + 0U) = 1;
            while (I993){
                UB  * I1778 = *(UB  **)(I993 + 16U);
                if ((*(US  *)(I993 + 0U)) & I1776) {
                    *(*(UB  **)(I993 + 48U)) = 1;
                    (*(FP  *)(I993 + 32U))((void *)(*(RP  *)(I993 + 40U)), (((*(scalar  *)(I993 + 2U)) >> I1775) & 3));
                }
                I993 = I1778;
            };
            *(pcode + 192 + 0U) = 0;
            rmaRemoveNonEdgeLoads(pcode + 192);
        }
    }
}
#ifdef __cplusplus
extern "C" {
#endif
void SinitHsimPats(void);
#ifdef __cplusplus
}
#endif
