dockrant() {
  local cmd=$1
  local args=()
  shift
  case "$cmd" in
    "up" )
      args+=("up")
      args+=("--provider=docker")
      ;;
    * )
      args+=(${cmd})
      ;;
  esac
  echo "vagrant ${args[@]}"
  vagrant ${args[@]}
}
