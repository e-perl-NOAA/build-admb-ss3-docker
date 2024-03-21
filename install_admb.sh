# From https://github.com/cgrandin/docker-projects/blob/master/hake/install_admb.sh
#!/bin/bash
POSITIONAL=()
set -- "${POSITIONAL[@]}" # restore positional parameters

install_dir=/usr/bin
admb_dir=$install_dir/admb

cd $install_dir

rm -rf admb
echo "Removed ${admb_dir} directory and all its contents before downloading new."
git clone --branch admb-13.2 https://github.com/admb-project/admb

cd $admb_dir

# Add semicolons to the end of all lines in all sedflex files,
# and then remove ^M's which were added by the adding of semicolons step
sed -i '/[^;] *$/s/$/;/' src/df1b2-separable/sedflex
sed -i 's/\r//' src/df1b2-separable/sedflex

sed -i '/[^;] *$/s/$/;/' src/nh99/sedflex
sed -i 's/\r//' src/nh99/sedflex

sed -i '/[^;] *$/s/$/;/' tests/xml/sedflex
sed -i 's/\r//' tests/xml/sedflex

# Remove ^M's from admb, adcomp, and adlink scripts
sed -i 's/\r//' scripts/admb/adcomp
sed -i 's/\r//' scripts/admb/adlink
sed -i 's/\r//' scripts/admb/admb

num_cpus=`cat /proc/cpuinfo | grep processor | wc -l`
num_cpus_minus1=$((num_cpus-1))
make -j $num_cpus_minus1

# This link is required for the examples to build
ln -s build/admb/bin/admb admb || true

# Contrib libraries need to be renamed, use symbolic links instead
cd $admb_dir/build/admb/lib

ln -s libadmb-x86_64-linux-g++9.a libadmb.a || true
ln -s libadmbo-x86_64-linux-g++9.a libadmbo.a || true

ln -s libadmb-contrib-x86_64-linux-g++9.a libadmb-contrib.a || true
ln -s libadmb-contribo-x86_64-linux-g++9.a libadmb-contribo.a || true

# Build ad2csv
mkdir $admb_dir/build/ad2csv
cd $admb_dir/contrib/ad2csv

make
