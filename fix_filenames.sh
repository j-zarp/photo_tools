# convert encodings if needed (e.g. if filenames or folders contain special characters)
  convmv -f utf-8 -t utf-8 --notest --nfc --replace -r <target_folder>

# Use the detox debian package to cleanup problematic filenames:
#  dry run:
detox -r -v -n <path to folder or file>

#  normal run:
detox -r -v <path to folder or file>

#  postprocessing to remove some characters not captured by detox:
files=`find <my_folder> -name "*+*"`
for f in $files
do
  mv "${f}" $(echo "${f}" | sed -e 's/[+]/et/g')
done

files=`find <my_folder> -name "*%*"`
for f in $files
do
  mv "${f}" $(echo "${f}" | sed -e 's/[%]/_/g')
done

files=`find <my_folder> -name "*~*"`
for f in $files
do
  mv "${f}" $(echo "${f}" | sed -e 's/[~]/_/g')
done

files=`find <my_folder> -name "*,*"`
for f in $files
do
  mv "${f}" $(echo "${f}" | sed -e 's/[,]//g')
done

