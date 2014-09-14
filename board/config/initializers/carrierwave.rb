# Allow non-ascii letters in uploaded filenames
CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\s\.\-\+]/ #한글 및 공백 처리. 이걸 안해주면 한글이 들어올때 모두 "_"이걸로 대체됨