
# ffmpeg
function ffmpeg-conv2ogg(){
    case $# in
        2 )
            ffmpeg -i $1 -map_metadata -1 -acodec libvorbis -vn -ab 256k $2
            ;;
        * ) echo "USAGE: $0 input output"
            ;;
    esac
}

function ffmpeg-conv2mp3(){
    case $# in
        2 )
            ffmpeg -i $1 -map_metadata -1 -acodec mp3 -vn $2
            ;;
        * ) echo "USAGE: $0 input output"
            ;;
    esac
}
