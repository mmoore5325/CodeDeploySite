# # #!/bin/bash
# # nohup sudo bundle exec rackup -p80 -o 0.0.0.0 &
# # echo "Hello"

# /bin/bash
# # echo ls
# # echo "GOING BACK A LEVEL"
# # cd ..
# # echo ls
# # echo "SHOULD BE IN MAIN APP FOLDER"
# # nohup sudo bundle exec rackup -p80 -o 0.0.0.0 &
# # echo "Hello"

# #!/bin/bash
# echo "hi"
# SOURCE="${BASH_SOURCE[0]}"
# while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
#   TARGET="$(readlink "$SOURCE")"
#   if [[ $TARGET == /* ]]; then
#     echo "SOURCE '$SOURCE' is an absolute symlink to '$TARGET'"
#     SOURCE="$TARGET"
#   else
#     DIR="$( dirname "$SOURCE" )"
#     echo "SOURCE '$SOURCE' is a relative symlink to '$TARGET' (relative to '$DIR')"
#     SOURCE="$DIR/$TARGET" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
#   fi
# done
# echo "SOURCE is '$SOURCE'"
# RDIR="$( dirname "$SOURCE" )"
# DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
# if [ "$DIR" != "$RDIR" ]; then
#   echo "DIR '$RDIR' resolves to '$DIR'"
# fi
# cd ..
# echo "DIR is '$DIR'"

# cd ..
# echo "The directory is now '$DIR'"
# cd ../deployment-archive nohup sudo bundle exec rackup -p80 -o 0.0.0.0 &
(cd .. && nohup sudo bundle exec rackup -p80 -o 0.0.0.0 &)
echo "working?"