#!/bin/bash

main(){
fvar=false
while getopts ":hf:r" opt; do
  case ${opt} in
    h )usage
	;;
    f ) filename=${OPTARG}
	fvar=true
	if [ $filename == "-r" ] ;then
		echo "f needs an argument"  
	fi
	;;
    r ) make_report
	;;
    : ) echo "${OPTARG} needs an argument"
	;;
    \? ) echo "Usage: cmd [-h] [-f filename] [-r]"
  esac
done
}
function usage(){
echo "Usage $1 -f file [-r] 
     -f file, specify input file 
     -r, generate a report"
}
function wrong_usage(){
>&2 echo "Try script.sh -h for more information."
}
function get_student_name(){
name=$1
while [[ $name == *"_"* ]]
do
 	name=${name#*_}
done
while [[ $name == *"."* ]]
do	
	name=${name%.*}
done
}
strindex() { 
  x="${1%%$2*}"
	result=-1
if  [[ "$x" != "$1" ]];then
result=${#x}
fi
}
function parse_assignment_file(){
file=`cat $filename`
parse=""
while [[ $file == *'echo -ne "'*'"'* ]]
do	
	strindex "$file" '"'
	pos=`echo $result + 1 | bc`
	file=${file:$pos}
	strindex "$file" '"'
	length=$result
	strreplacement=${file:0:$length}
if [[ $strreplacement == *'Q'*':'* ]];then
	parse=$parse${file:0:$length}"
"
fi
	length=`echo $length + 1|bc`
	file=${file:$length}
done
parse1=$parse
echo "$parse1"
}
function calc_num_of_points(){
	calc_num=0
count=0
while [[ $parse == *"\n"*"\n"* ]]
do
	strindex "$parse" ":"
	index=`echo $result+1|bc`
	parse=${parse:index}
	num=${parse:0:1}
	calc_num=`echo "$calc_num + $num * 4"|bc`
	strindex "$parse" "\n"
	index=`echo $result + 3 |bc`
	parse=${parse:index}
count=`echo "$count+1"|bc`
done
echo "$calc_num"
}
function print_final_mark(){
final_mark=`echo "scale=2;($calc_num*124)/100"|bc -l`
}
function make_report(){
count=0
while [[ $parse1 == *"\n"*"\n"* ]]
do
count=`echo "$count+1"|bc`;
	strindex "$parse1" ":"
	index=`echo $result+1|bc`
	indexQ=`echo $index-4|bc`
	parse1=${parse1:$indexQ}
	Qnumber=${parse1:$indexQ:3}
index=`echo "$index-$indexQ"|bc`
	parse1=${parse1:$index}
	num=${parse1:0:1}
back="
"
strindex "$parse1" "$back"
result=`echo "$result-3"|bc`
if [ $num != 1 ];then
	echo "$Qnumber [$num] -> ${parse1:3:$result}"
fi
result=`echo "$result+4"|bc`
parse1=${parse1:$result}
done
}

echo -ne "Q01:\n"
echo "false #!/bin/bash is enough no exit or return is needed unless you need to return something from a function or a case exit"
echo -ne "Q02:\n"
echo "false my script should handle exceptions by sending error messages tp stderr the default error standard output or to a log file for errors"
echo -ne "Q03:\n"
main "$@";
echo -ne "Q04:\n"
wrong_usage
echo -ne "Q05:\n"
usage
echo -ne "Q06:\n"
if [ $fvar == true ] && [ $filename != "-r" ];then
	get_student_name $filename
	echo $name
else
	echo "can't get student name file name not set"
fi
echo -ne "Q07:\n"
if [ $fvar == true ] && [ $filename != "-r" ];then
	get_student_name $filename
	echo $name
	parse_assignment_file
fi
echo -ne "Q08:\n"
if [ $fvar == true ] && [ $filename != "-r" ];then
calc_num_of_points
else
	echo "can't get student name and its points file name not set"
fi
echo -ne "Q09:\n"
if [ $fvar == true ] && [ $filename != "-r" ];then
print_final_mark
else
	echo "can't get student name and its points file name not set"
fi
echo -ne "Q10:\n"
echo "Final mark for student id [$name] is $final_mark"
echo -ne "Q11:\n"
make_report 
echo -ne "Q12:\n"
if [ $fvar == false ] || [ $filename == "-r" ];then
wrong_usage
fi
echo -ne "Q13:\n"

