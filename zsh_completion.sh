autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
BMA_PATH="$(cd "$(dirname "$0")" && pwd)"
source "${BMA_PATH}/bash_completion.sh"
