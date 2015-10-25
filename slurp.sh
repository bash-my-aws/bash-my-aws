for f in $(dirname ${BASH_SOURCE[0]})/lib/*-functions; do
  source $f;
done
