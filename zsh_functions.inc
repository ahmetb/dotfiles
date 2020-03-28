log() {
  echo >&2 "[~/.zshrc] $(tput setaf 245)$*$(tput sgr0)"
}

brew() {
  sudo chown -R "$(whoami)" /usr/local/bin /usr/local/etc /usr/local/sbin /usr/local/share /usr/local/share/doc
  chmod u+w /usr/local/bin /usr/local/etc /usr/local/sbin /usr/local/share /usr/local/share/doc
  command "brew" $@
}

retry() {
  while true; do $@; sleep 1; done
}

til() {
  while true; do $@; if [ $? -eq 0 ]; then break; fi; sleep 1; done
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
  echo "time took: $tt ms." >&2
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
        docker push "$img" 1>/dev/null
    )
    echo "$img"
}

kr() {
    set -x;
    image="$1"
    shift
    kubectl run --rm --restart=Never --image-pull-policy=IfNotPresent -i -t \
    	--image="${image}" tmp-"${RANDOM}" $@
}

