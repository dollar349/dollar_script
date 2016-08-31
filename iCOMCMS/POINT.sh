#/bin/sh
Link_list="src"
Link_list+=" meta-icom-cms"
Link_list+=" meta-avct-browser"

for Link in ${Link_list};
do
    rm -rf $Link
    ln -s $1/$Link $Link 
done


#echo ${Link_list}
#SIPATH=~/_for_SourceInsight
#len=`expr length $0`
#len=`expr $len - 7`
# echo $len
#substr=`expr substr $0 5 $len`
#echo $substr

#rm -rf $SIPATH/$substr
#ln -s $1 $SIPATH/$substr

exit 0
