log() {
  echo >&2 "[~/.zshrc] $(tput setaf 245)$*$(tput sgr0)"
}

retry() {
  while true; do $@; sleep 1; done
}

til() {
  while true; do $@; if [ $? -eq 0 ]; then break; fi; sleep 1; done
}

tilfails() {
  while $@; do; sleep 1; done
}

mcd() {
  mkdir -p "${1:?Need to specify an argument}" && cd "$1"
}

goto() {
  cd "$(dirname "$(readlink -f "$(command -v "$@")")")" || false
}

togcr() {
  docker pull "$1"
  local proj img
  proj="$(gcloud config get-value core/project -q)"
  img="gcr.io/$proj/$(basename "$1")"
  docker tag "$1" "$img"
  docker push "$img"
  echo >&2 "Pushed $(tput setaf 1)$img$(tput sgr0)"
}

portkill() {
  ps="$(lsof -t -i:"$1")"
  if [[ -z "$ps" ]]; then
    echo "no processes found"
  else
    kill -9 "$ps" && echo "$ps"
  fi
}

measure() {
  local ts=$(date +%s%N)
  $@
  local tt=$((($(date +%s%N) - $ts)/1000000))
  echo "$(tput setaf 245)\"${1}\" took $tt ms.$(tput sgr0)" >&2
}

_git_dbg() {
  echo >&2 "$(tput setaf 1)+ git $@$(tput sgr0)"
  git "$@"
}

_kubectl_dbg() {
  echo >&2 "$(tput setaf 1)+ kubectl $@$(tput sgr0)"
  kubectl "$@"
}

gcr() {
    [ -n "$1" ] && [[ ! "$1" =~ ^gcr.io ]] && 1="gcr.io/$1"
    c=$(echo "$1" | grep -o '/' | wc -l)
    if [[ 1 == "$c" ]]; then gcloud container images list --repository "$1" --limit=99999
    elif [[ 2 == "$c" ]]; then gcloud container images list-tags "$1" --limit=99999
    else gcloud container images list; fi
}

run() {
    img="$1"
    shift 1
    name="$1"
    if [[ -n "$name" ]]; then
        shift 1
    else
        name="$(basename "$img")"
    fi
    set -x
    gcloud run deploy --region us-central1 --platform=managed \
        --allow-unauthenticated --image="$img" "$name" "$@"
}

dbp() {
    proj="$(gcloud config get-value core/project -q)"
    if [[ -z $proj ]]; then
        echo "can't get project";
        return
    fi
    img="gcr.io/${proj}/$(basename $PWD)"
    echo >&2 "$(tput setaf 2)build+push $img $(tput sgr0)"
    (
    set -x
    docker build --tag "$img" ${1:-.} 1>/dev/null && \
        docker push "$img" 1>/dev/null && echo "$img"
    )
}

dbpr() {
    local img
    img="$(dbp)"
    echo >&2 "$(tput setaf 2)deploy $img to cloud run...$(tput sgr0)"
    run "$img" "$(basename "$img")" "$@"
}

kr() {
    set -x;
    image="$1"
    shift
    kubectl run --rm --restart=Never --image-pull-policy=IfNotPresent -i -t \
    	--image="${image}" tmp-"${RANDOM}" $@
}

demo() {
    PS1=$(tput setaf 2)\$\ $(tput sgr0)
    export PS1
    clear
}

sum() {
   awk '{ sum += $1; } END { print sum; }'
}


lmlm() {
  local dir op
  dir=/Users/ahmet/workspace/junk/lmdirect
  op=$1
  cd $dir || exit 1
  case $op in
    on)
      echo 1 on | timeout 8 python ./test.py
      ;;
    off)
      echo 1 off | timeout 8 python ./test.py
      ;;
    *)
      echo >&2 'usage: [on|off]'
      ;;
  esac
}

mkgoenvrc() {
  echo 'source <(golnkd-core shell-env)' > .envrc && \
    direnv allow
}
