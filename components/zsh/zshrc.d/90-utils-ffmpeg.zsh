
# ffmpeg
function ffmpeg-conv2ogg(){
    cmd=$0
    Usage() {
        echo "USAGE: $cmd [-s] input output"
    }
    inputfile= outputfile= symmetry=false

    while getopts s opt
    do
        case "$opt" in
            "s") symmetry=true;;
        esac
    done

    shift $((OPTIND -1))

    case $# in
        1 )
            if ! $symmetry; then
                Usage
                return 1
            fi
            inputfile=$1
            outputfile=${inputfile%.*}.ogg
            ;;
        2 )
            inputfile=$1
            outputfile=$2
            ;;
        * ) 
            Usage
            return 1
            ;;
    esac
    ffmpeg -i $inputfile -map_metadata -1 -acodec libvorbis -vn -ab 256k $outputfile
}

function ffmpeg-conv2mp3(){
    cmd=$0
    Usage() {
        echo "USAGE: $cmd [-s] input output"
        return 1
    }
    inputfile= outputfile= symmetry=false

    while getopts s opt
    do
        case "$opt" in
            "s") symmetry=true;;
        esac
    done

    shift $((OPTIND -1))

    case $# in
        1 )
            if ! $symmetry; then
                Usage
                return 1
            fi
            inputfile=$1
            outputfile=${inputfile%.*}.mp3
            ;;
        2 )
            inputfile=$1
            outputfile=$2
            ;;
        * ) 
            Usage
            return 1
            ;;
    esac
    ffmpeg -i $inputfile -map_metadata -1 -acodec mp3 -vn -ab 256k $outputfile
}
