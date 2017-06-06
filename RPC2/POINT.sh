#/bin/sh
Link_list="sources"
Link_list+=" common"

for Link in ${Link_list};
do
    rm -rf $Link
    chmod +w -R $1/$Link
    ln -s $1/$Link $Link 
done

exit 0
