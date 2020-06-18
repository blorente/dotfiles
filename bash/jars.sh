function peek_jar() {
  jarfile=$1
  jar tvf "${jarfile}" | awk '{print $8}' | sort
}

