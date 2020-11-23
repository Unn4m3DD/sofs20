function populateFS() {
  local path
  path=$(pwd)
  cd /tmp/dirTest
  for ((i = 0; i < 200; i++)); do
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
    #echo "This is a great file" > "d"$i"/f1"
    #truncate "d"$i"/f1" --size=50
  done
  touch $path"/populatedDirTree.log"
  tree > $path"/populatedDirTree.log"
}
populateFS