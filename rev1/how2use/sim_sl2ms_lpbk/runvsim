echo "Cleaning old files"
#ls | grep -v *.sh | xargs rm -rf
rm -rf work/ transcript *.bsf *.qip *.wlf *~cd

echo "executing self_test.do"
vsim -t 1ps -c -do self_test.do >> sim.log

p=`grep "PASSED" sim.log`
# echo $p8l6g

if [ "$p" = "" ]
    then
    echo "Failed"
    exit 66
else
    
    echo "PASSED"
    echo "PASSED" >> reg.rout

fi
    

