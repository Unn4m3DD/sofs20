# $1 target directory
function populate_fs() {
  local path
  path=$(pwd)
  cd "$path/$1"
  if [ "$?" != 0 ]; then return; fi
  for ((i = 0; i < 3; i++)); do
    mkdir "d"$i
    if [ $(($i % 2)) == 0 ]; then
      for ((j = 0; j < 50; j++)); do
        mkdir "d"$i"/"$j
        echo "i love jelly" > "d"$i"/"$j"/aFile.txt"
        truncate "d"$i"/"$j"/aFile.txt" --size=$(($j * 10))
        echo "its the end" >> "d"$i"/"$j"/aFile.txt"
        mv "d"$i"/"$j "d"$i"/d""$(($j % 2))"
      done
    fi
  done
  cd $path
}
# $1 target directory
function clean_fs() {
  local path
  path=$(pwd)
  cd $1
  rm -rf *
  cd path
}