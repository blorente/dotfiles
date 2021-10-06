function peek_jar() {
  jarfile=$1
  jar tvf "${jarfile}" | awk '{print $8}' | sort
}


function peek_jar_file() {
  jarfile=$1
  file_to_peek=$2
  unzip -p "${jarfile}" "${file_to_peek}"
}

function peek_jar_manifest() {
  jarfile=$1
  peek_jar_file "${jarfile}" "META-INF/MANIFEST.MF"
}

