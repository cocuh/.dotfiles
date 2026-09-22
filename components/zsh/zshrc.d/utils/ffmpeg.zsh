function ffmpeg-conv() {
    local cmd=$1 ext=$2 codec=$3
    shift 3
    local symmetry=false metadata=(-map_metadata -1)
    local opt OPTIND=1
    local inputfile outputfile

    while getopts sm opt
    do
        case "$opt" in
            "s") symmetry=true;;
            "m") metadata=();;
            *) echo "USAGE: $cmd [-s] [-m] input output"; return 1;;
        esac
    done

    shift $((OPTIND -1))

    case $# in
        1 )
            if ! $symmetry; then
                echo "USAGE: $cmd [-s] [-m] input output"
                return 1
            fi
            inputfile=$1
            outputfile=${inputfile%.*}.$ext
            ;;
        2 )
            inputfile=$1
            outputfile=$2
            ;;
        * )
            echo "USAGE: $cmd [-s] [-m] input output"
            return 1
            ;;
    esac
    ffmpeg -i "$inputfile" $metadata -acodec $codec -vn -ab 256k "$outputfile"
}

function ffmpeg-conv2ogg(){
    ffmpeg-conv $0 ogg libvorbis "$@"
}

function ffmpeg-conv2mp3(){
    ffmpeg-conv $0 mp3 mp3 "$@"
}

function ffmpeg-conv2twitter(){
  ffmpeg -i "$1" -vcodec h264 "$2"
}
