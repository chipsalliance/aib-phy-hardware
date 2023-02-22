#!/bin/csh -f

cd /nfs/site/disks/psg_data_14/huizhan1/aib-phy-hardware_bca_release/v1.0/rev1/how2use/sim_sl_lpbk

#This ENV is used to avoid overriding current script in next vcselab run 
setenv SNPS_VCSELAB_SCRIPT_NO_OVERRIDE  1

/p/psg/eda/synopsys/vcsmx/T-2022.06/linux64/suse/suse64/bin/vcselab $* \
    -o \
    simv \
    -nobanner \

cd -

